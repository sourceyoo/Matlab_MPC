function run_bayesopt
    % [Step/Ramp Response 최적화] 상세 결과 리포트 기능 포함

    %% 0. 초기화
    rng(1);

    %% 1. 병렬 워커 설정
    logicalCores    = feature('numcores');
    safeWorkerCount = 5;           % PC 사양에 맞춰 조정

    pool = gcp('nocreate');
    if ~isempty(pool), delete(pool); end

    fprintf('>>> 최적화 시작: 코어 %d개 중 %d개 사용\n', ...
            logicalCores, safeWorkerCount);
    pool = parpool(safeWorkerCount);

    % 워커에 필요한 파일 배포
    addAttachedFiles(pool, ...
        {'mpc_rsme_fun.m', 'init_vehicle_params.m', 'bicycle_kinematic.slx'});

    % 실시간 로그용 DataQueue
    q = parallel.pool.DataQueue;
    afterEach(q, @(msg) fprintf('%s\n', msg));

    %% 2. 튜닝 변수 정의
    Qy_var    = optimizableVariable('Qy',   [100, 10000], 'Transform','log');
    Qpsi_var  = optimizableVariable('Qpsi', [10, 500],  'Transform','log');
    Rdelta_var= optimizableVariable('Rdelta',[0.001, 1], 'Transform','log');
    vars = [Qy_var; Qpsi_var; Rdelta_var];

    %% 3. 최적화 실행
    costFcn = @(x) mpc_rsme_fun(x, q);

    try
        fprintf('>>> 최적화 시작... (MaxEval: 150)\n');

        results = bayesopt(costFcn, vars, ...
            'MaxObjectiveEvaluations', 300, ...
            'IsObjectiveDeterministic', true, ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ...
            'ExplorationRatio', 0.3, ...
            'UseParallel', true, ...
            'Verbose', 1, ...
            'SaveFileName', 'bayesopt_checkpoint.mat', ...
            'PlotFcn', {@plotMinObjective, @plotElapsedTime});

        %% 4. 최종 결과 상세 리포트
        bestPoint    = results.XAtMinObjective;
        minObjective = results.MinObjective;

        fprintf('\n========================================\n');
        fprintf('       최적 파라미터 상세 검증 리포트       \n');
        fprintf('========================================\n');

        % 최적 파라미터로 1회 재시뮬레이션 (q = [] → 로그 중복 방지)
        [verified_J, metrics] = mpc_rsme_fun(bestPoint, []);

        fprintf('1. 파라미터 (Parameters)\n');
        disp(bestPoint);

        fprintf('2. 성능 지표 (Performance Metrics)\n');
        fprintf('   - Cost (J)      : %.4f\n', verified_J);

        % ====== 여기서 "성공 / 실패" 분기 ======
        if isfield(metrics, 'Error')
            % 시뮬레이션 실패 케이스
            fprintf('   - [ERROR] 시뮬레이션 실패: %s\n', metrics.Error);
            fprintf('   - RMSE/MaxErr/Settling/Heading 값은 유효하지 않습니다.\n');
        else
            % 정상 시뮬레이션 케이스
            fprintf('   - RMSE          : %.4f m (평균 주행 오차)\n', metrics.RMSE);
            fprintf('   - Max Error     : %.4f m (최대 이탈 거리)\n', metrics.MaxErr);
            fprintf('   - Settling Time : %.2f s (정착 시간)\n', metrics.T_settle);
            fprintf('   - Max Heading   : %.2f deg (최대 틀어짐)\n', metrics.MaxPsi_deg);
        end
        fprintf('========================================\n');

        % 결과 저장 (metrics까지 같이)
        save('best_mpc_params.mat', 'bestPoint', 'results', 'metrics');

    catch ME
        fprintf('\n!!! 에러 발생 !!!\n');
        disp(getReport(ME));
        save('bayesopt_crash_dump.mat');
    end

    delete(gcp('nocreate'));
end
