function run_bayesopt_safe
    % [안전 모드] BAYESOPT 실행 스크립트
    % 하드웨어 보호를 위해 CPU 코어를 제한하고, 중간 결과를 자동 저장합니다.

    rng(1);   % 재현성용 시드 설정

    % =========================================================================
    % 1. [하드웨어 안전장치] 병렬 워커(Worker) 수 제한 (과열 방지)
    % =========================================================================
    logicalCores = feature('numcores');        % 물리 코어 개수 확인
    safeWorkerCount = max(1, floor(logicalCores / 2)); % 절반만 사용 (최소 1개)
    
    % 기존 풀 정리 후 안전한 개수로 재설정
    pool = gcp('nocreate');
    if ~isempty(pool)
        delete(pool);
    end
    
    fprintf('>>> 안전 모드 가동: 전체 코어 %d개 중 %d개만 사용하여 과부하를 방지합니다.\n', ...
        logicalCores, safeWorkerCount);
    parpool(safeWorkerCount); 
    
    % =========================================================================
    % 2. 최적화 변수 정의
    % =========================================================================
    Qy_var      = optimizableVariable('Qy',       [0.1, 100], 'Transform','log');
    Qpsi_var    = optimizableVariable('Qpsi',     [0.1, 100], 'Transform','log');
    Rdelta_var  = optimizableVariable('Rdelta',   [0.05, 10], 'Transform','log');

    vars = [Qy_var; Qpsi_var; Rdelta_var;];

    % =========================================================================
    % 3. bayesopt 실행 (소프트웨어 안전 옵션 추가)
    % =========================================================================
    % - MaxObjectiveEvaluations: 2000 -> 300 (안정성 위해 축소 권장)
    % - SaveFileName: 컴퓨터가 꺼져도 복구할 수 있도록 자동 저장
    results = bayesopt(@mpc_cost_fun, vars, ...
        'MaxObjectiveEvaluations', 300, ...    
        'IsObjectiveDeterministic', true, ...
        'UseParallel', true, ...               % 병렬 처리 켜기 (위에서 제한한 코어 수만큼만 돔)
        'Verbose', 1, ...
        'SaveFileName', 'bayesopt_checkpoint.mat', ... % [중요] 중간 저장
        'PlotFcn', {@plotMinObjective, @plotElapsedTime});

    % 4. 결과 처리
    bestPoint = results.XAtMinObjective;
    disp('--- 최적 파라미터 결과 ---');
    disp(bestPoint);

    save('best_mpc_params.mat', 'bestPoint');
    
    % 5. 종료 후 병렬 풀 정리 (메모리 반환)
    delete(gcp('nocreate'));
    fprintf('>>> 최적화 완료 및 리소스 정리 끝.\n');
end