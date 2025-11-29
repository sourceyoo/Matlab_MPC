function run_bayesopt
    % [Step Response 최적화] 게걸음 완벽 차단 + 빠른 응답 + 문법 오류 수정
    
    % 0. 초기화
    rng(1);   
    
    % 1. 병렬 워커 설정
    logicalCores = feature('numcores');
    safeWorkerCount = 4; % PC 성능에 따라 조절
    
    pool = gcp('nocreate');
    if ~isempty(pool), delete(pool); end
    
    fprintf('>>> 최적화 시작: 코어 %d개 중 %d개 사용\n', logicalCores, safeWorkerCount);
    pool = parpool(safeWorkerCount); 
    
    % [수정] 파일 배포는 bayesopt 옵션이 아니라, pool에 직접 명령해야 합니다.
    % 워커들이 필요한 파일들을 미리 전송합니다.
    addAttachedFiles(pool, {'mpc_cost_fun.m', 'init_vehicle_params.m', 'bicycle_kinematic.slx'});
    
    % 실시간 로그용 무전기 생성
    q = parallel.pool.DataQueue;
    afterEach(q, @(msg) fprintf('%s\n', msg)); 
    
    % =========================================================================
    % 2. [게걸음 방지용 튜닝 범위]
    % =========================================================================
    
    % (1) Qy (위치): 1m 도달 속도 확보 (최소 10 이상)
    Qy_var   = optimizableVariable('Qy',   [10, 1000], 'Transform','log'); 
    
    % (2) Qpsi (헤딩): 하한 0.5 (정렬 강제), 상한 20 (진동 억제 여유)
    Qpsi_var = optimizableVariable('Qpsi', [0.5, 20], 'Transform','log'); 
    
    % (3) Rdelta (핸들 댐핑)
    Rdelta_var = optimizableVariable('Rdelta', [0.1, 50], 'Transform','log');
    
    vars = [Qy_var; Qpsi_var; Rdelta_var];

    % =========================================================================
    % 3. 최적화 실행
    % =========================================================================
    costFcn = @(x) mpc_cost_fun(x, q);
    
    try
        fprintf('>>> 최적화 시작... (Heading Tolerance 0.5도)\n');
        
        % [수정] 'AttachedFiles' 옵션 삭제 (여기 있으면 에러남)
        results = bayesopt(costFcn, vars, ...
            'MaxObjectiveEvaluations', 300, ...    
            'IsObjectiveDeterministic', true, ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ...
            'UseParallel', true, ...
            'Verbose', 1, ...
            'SaveFileName', 'bayesopt_checkpoint.mat', ...
            'PlotFcn', {@plotMinObjective, @plotElapsedTime});
            
        bestPoint = results.XAtMinObjective;
        fprintf('\n--- 최적 파라미터 발견 ---\n');
        disp(bestPoint);
        save('best_mpc_params.mat', 'bestPoint', 'results');
        
    catch ME
       fprintf('\n!!! 에러 발생 !!!\n');
       disp(getReport(ME));
       save('bayesopt_crash_dump.mat'); 
    end
    
    delete(gcp('nocreate'));
end