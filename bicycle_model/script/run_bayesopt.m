function run_bayesopt
    % [안전 모드] BAYESOPT 실행 스크립트 (논문 기반 튜닝 적용)
    % 하드웨어 보호 및 최적화 효율성 강화 버전
    
    % 0. 재현성 시드 설정
    rng(1);   
    
    % =========================================================================
    % 1. [하드웨어 안전장치] 병렬 워커(Worker) 수 제한
    % =========================================================================
    logicalCores = feature('numcores');
    safeWorkerCount = 2; % 절반만 사용
    
    pool = gcp('nocreate');
    if ~isempty(pool)
        delete(pool);
    end
    
    fprintf('>>> 안전 모드 가동: 코어 %d개 중 %d개만 사용합니다.\n', logicalCores, safeWorkerCount);
    parpool(safeWorkerCount); 

    
    % =========================================================================
    % 2. 최적화 변수 정의 (MPC 내부 제어용 가중치)
    % =========================================================================
    Qy_var      = optimizableVariable('Qy',       [0.1, 200], 'Transform','log');
    Qpsi_var    = optimizableVariable('Qpsi',     [0.1, 200], 'Transform','log');
    Rdelta_var  = optimizableVariable('Rdelta',   [0.01, 50], 'Transform','log'); 
    % (Tip: Rdelta 하한을 조금 더 낮춰서 공격적인 제어도 탐색하게 함)
    
    vars = [Qy_var; Qpsi_var; Rdelta_var];

    % =========================================================================
    % 3. bayesopt 실행 (안전 옵션 + 알고리즘 강화)
    % =========================================================================
    % [중요] 여기서 호출하는 @mpc_cost_fun은 
    % 반드시 "고정된 Alpha 가중치"로 평가하는 함수여야 합니다.
    
    try
        fprintf('>>> 최적화 시작... (최대 300회)\n');
        
        results = bayesopt(@mpc_cost_fun, vars, ...
            'MaxObjectiveEvaluations', 300, ...    
            'IsObjectiveDeterministic', true, ...
            'AcquisitionFunctionName', 'expected-improvement-plus', ...
            'UseParallel', true, ...
            'Verbose', 1, ...
            'SaveFileName', 'bayesopt_checkpoint.mat', ...
            'PlotFcn', {@plotMinObjective, @plotElapsedTime});
            
        % 4. 결과 처리
        bestPoint = results.XAtMinObjective;
        minObjective = results.MinObjective;
        
        fprintf('\n--- 최적 파라미터 발견 ---\n');
        disp(bestPoint);
        fprintf('최소 비용(J): %.4f\n', minObjective);
        
        save('best_mpc_params.mat', 'bestPoint', 'results');
        
    catch ME
       fprintf('\n!!! 에러 발생 (상세 리포트) ==============================\n');
        % 전체 스택 + 원인까지 출력
        disp(getReport(ME, 'extended', 'hyperlinks', 'off'));
    
        % 혹시 내부 cause에 워커 쪽 에러가 들어있으면 한 번 더 풀어서 봄
        if ~isempty(ME.cause)
            fprintf('\n--- 내부 cause(1) 리포트 ---\n');
            disp(getReport(ME.cause{1}, 'extended', 'hyperlinks', 'off'));
        end

        save('bayesopt_crash_dump.mat'); % 현재 상태라도 저장
    end
    
    % 5. [안전 종료] 병렬 풀 정리 (에러가 나도 실행됨)
    delete(gcp('nocreate'));
    fprintf('>>> 리소스 정리 완료. 프로그램 종료.\n');
end
