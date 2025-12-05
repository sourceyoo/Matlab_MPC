function run_bayesopt
    % [Step Response 최적화] 상세 결과 리포트 기능 추가
    % 최적화 완료 후 RMSE, MaxErr, T_settle 등 상세 지표를 출력합니다.
    
    % 0. 초기화
    rng(1);   
    
    % 1. 병렬 워커 설정
    logicalCores = feature('numcores');
    safeWorkerCount = 5; % PC 사양에 맞게 조절
    
    pool = gcp('nocreate');
    if ~isempty(pool), delete(pool); end
    
    fprintf('>>> 최적화 시작: 코어 %d개 중 %d개 사용\n', logicalCores, safeWorkerCount);
    pool = parpool(safeWorkerCount); 
    
    % [필수] 파일 배포 (AttachedFiles 에러 방지용)
    addAttachedFiles(pool, {'mpc_cost_fun.m', 'init_vehicle_params.m', 'bicycle_kinematic.slx'});
    
    % 실시간 로그용 무전기
    q = parallel.pool.DataQueue;
    afterEach(q, @(msg) fprintf('%s\n', msg)); 
    
    % =========================================================================
    % 2. 튜닝 범위 설정 (강력한 반응성 + 진동 억제)
    % =========================================================================
    % Qy: 50 이상으로 설정하여 1m 도달 반응성 극대화
    Qy_var   = optimizableVariable('Qy',   [50, 300], 'Transform','log'); 
    
    % Qpsi: 게걸음 방지(0.5) 및 곡선 추종(20)
    Qpsi_var = optimizableVariable('Qpsi', [2, 100], 'Transform','log'); 
    
    % Rdelta: 10~25로 좁게 설정하여 확실한 댐핑(진동 억제) 유도
    Rdelta_var = optimizableVariable('Rdelta', [10, 50], 'Transform','log');
    
    vars = [Qy_var; Qpsi_var; Rdelta_var];

    % =========================================================================
    % 3. 최적화 실행
    % =========================================================================
    costFcn = @(x) mpc_cost_fun(x, q);
    
    try
        fprintf('>>> 최적화 시작... (MaxEval: 150)\n');
        
        results = bayesopt(costFcn, vars, ...
            'MaxObjectiveEvaluations', 150, ...    
            'IsObjectiveDeterministic', true, ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ...
            'UseParallel', true, ...
            'Verbose', 1, ...
            'SaveFileName', 'bayesopt_checkpoint.mat', ...
            'PlotFcn', {@plotMinObjective, @plotElapsedTime});
            
        % 4. [NEW] 최종 결과 상세 리포트 출력
        bestPoint = results.XAtMinObjective;
        minObjective = results.MinObjective;
        
        fprintf('\n========================================\n');
        fprintf('       최적 파라미터 상세 검증 리포트       \n');
        fprintf('========================================\n');
        
        % [핵심] 최적 파라미터로 시뮬레이션을 한 번 더 돌려서 상세 지표(metrics) 획득
        % (두 번째 인자 q에 []를 넣어 로그 중복 출력 방지)
        [verified_J, metrics] = mpc_cost_fun(bestPoint, []);
        
        fprintf('1. 파라미터 (Parameters)\n');
        disp(bestPoint);
        
        fprintf('2. 성능 지표 (Performance Metrics)\n');
        fprintf('   - Cost (J)      : %.4f\n', verified_J);
        fprintf('   - RMSE          : %.4f m (평균 주행 오차)\n', metrics.RMSE);
        fprintf('   - Max Error     : %.4f m (최대 이탈 거리)\n', metrics.MaxErr);
        fprintf('   - Settling Time : %.2f s (정착 시간)\n', metrics.T_settle);
        fprintf('   - Max Heading   : %.2f deg (최대 틀어짐)\n', metrics.MaxPsi_deg);
        fprintf('========================================\n');

        % 결과 파일 저장 (metrics 포함)
        save('best_mpc_params.mat', 'bestPoint', 'results', 'metrics');
        
    catch ME
       fprintf('\n!!! 에러 발생 !!!\n');
       disp(getReport(ME));
       save('bayesopt_crash_dump.mat'); 
    end
    
    delete(gcp('nocreate'));
end