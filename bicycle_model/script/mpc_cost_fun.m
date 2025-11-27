function J = mpc_cost_fun(x)
    % x : bayesopt에서 넘어오는 파라미터 구조체
    %     사용 필드: Qy, Qpsi, Rdelta
    %     (Np, Nc는 여기서 고정값 사용)
    
    %=============================
    % 0) Horizon 및 하드웨어 제약 고정
    %=============================
    Np_fixed       = 60;    % prediction horizon
    Nc_fixed       = 12;    % control horizon
    dmax_deg_fixed = 27;    % 최대 조향 각 [deg]

    %==========================================================
    % 0-1) [핵심 변경] 워커별 1회 초기화 & 구조체 저장
    %      매번 run을 하지 않고, 첫 실행 때만 변수를 메모리에 저장
    %==========================================================
    persistent staticVars
    if isempty(staticVars)
        % 1. 초기화 스크립트 실행 (변수들이 이 함수 workspace에 생성됨)
        run('init_vehicle_params.m');
        
        % 2. 생성된 변수들을 구조체(staticVars)에 백업
        %    (init_vehicle_params.m에 있는 변수 리스트를 모두 등록)
        s = struct();
        
        % 필수 변수들 체크 및 저장
        if exist('rosParams', 'var'),     s.rosParams     = rosParams;     end
        if exist('tireParams', 'var'),    s.tireParams    = tireParams;    end
        if exist('assumptions', 'var'),   s.assumptions   = assumptions;   end
        if exist('vehicleParams', 'var'), s.vehicleParams = vehicleParams; end
        
        % L (휠베이스) 처리
        if exist('L', 'var')
            s.L = L;
        elseif isfield(s, 'vehicleParams') && isfield(s.vehicleParams, 'a')
            s.L = s.vehicleParams.a + s.vehicleParams.b;
        else
            error('L 또는 vehicleParams가 정의되지 않았습니다.');
        end
        
        % 기타 주행 파라미터 저장
        if exist('delta_max', 'var'), s.delta_max = delta_max; end
        if exist('a_max', 'var'),     s.a_max     = a_max;     end
        if exist('v0', 'var'),        s.v0        = v0;        end
        if exist('x0', 'var'),        s.x0        = x0;        end
        if exist('y0', 'var'),        s.y0        = y0;        end
        if exist('psi0', 'var'),      s.psi0      = psi0;      end
        if exist('Ts', 'var'),        s.Ts        = Ts;        end
        
        % persistent 변수에 저장 (다음 호출부터는 이 블록 건너뜀)
        staticVars = s;
        
        % Fast Restart를 위해 모델 한 번 로드
        load_system('bicycle_kinematic');
    end
    
    %=============================
    % 1) SimulationInput 객체 생성
    %=============================
    simIn = Simulink.SimulationInput('bicycle_kinematic');
    
    %=============================
    % 2) [변경] 모든 변수를 setVariable로 주입
    %    (Base Workspace 의존성 제거 -> FastRestart 호환성 확보)
    %=============================
    
    % 2-1. 최적화 변수 (Bayesopt에서 옴)
    simIn = simIn.setVariable('Qy',       x.Qy);
    simIn = simIn.setVariable('Qpsi',     x.Qpsi);
    simIn = simIn.setVariable('Rdelta',   x.Rdelta);
    
    % 2-2. 고정 제어 변수
    simIn = simIn.setVariable('Np',       Np_fixed);
    simIn = simIn.setVariable('Nc',       Nc_fixed);
    simIn = simIn.setVariable('dmax_deg', dmax_deg_fixed);
    
    % 2-3. 초기화 스크립트에서 가져온 정적 변수들 일괄 주입
    %      (staticVars 구조체에 있는 모든 필드를 simIn에 넣음)
    fields = fieldnames(staticVars);
    for i = 1:numel(fields)
        varName = fields{i};
        simIn = simIn.setVariable(varName, staticVars.(varName));
    end
    
    %=============================
    % 3) 시뮬레이션 설정 (Fast Restart ON)
    %=============================
    simIn = simIn.setModelParameter('StopTime',    '10');
    simIn = simIn.setModelParameter('SaveOutput',  'off');
    simIn = simIn.setModelParameter('SaveState',   'off');
    simIn = simIn.setModelParameter('SaveFormat',  'Dataset'); 
    simIn = simIn.setModelParameter('FastRestart', 'on'); 
    % setVariable을 썼으므로 SrcWorkspace는 기본값이어도 되지만 명확히 함
    
    %=============================
    % 4) 시뮬레이션 실행
    %=============================
    try
        simOut = sim(simIn); 
    catch ME
        warning('Simulink 실행 실패: %s', ME.message);
        J = 1e9; % 실패 시 매우 큰 비용
        return;
    end
    
    % 5) 에러 처리 (Simulink 내부 에러)
    if simOut.ErrorMessage
        J = 1e9; 
        return;
    end
    
    %=============================
    % 6) 로그 꺼내기 및 데이터 처리
    %=============================
    logs = simOut.logsout;
    
    % 데이터 추출 (try-catch 없이 필수 신호는 존재한다고 가정)
    % 만약 신호 이름이 다르면 여기서 수정 필요
    try
        Yref_ts  = logs.get('Y_ref').Values;
        Y_ts     = logs.get('Y').Values;
        delta_ts = logs.get('delta_cmd').Values;
    catch
        warning('필수 로그 신호(Y, Y_ref, delta_cmd)를 찾을 수 없습니다.');
        J = 1e9; return;
    end
    
    t  = Y_ts.Time;
    Y  = Y_ts.Data;
    Yr = Yref_ts.Data;
    d  = delta_ts.Data;
    
    % 샘플링 타임 계산 (로그 기반)
    if length(t) > 1
        Ts_log = mean(diff(t));
    else
        Ts_log = staticVars.Ts; % 로그가 너무 짧으면 설정값 사용
    end
    
    %==================================================================
    % 8) 평가용 에러 정의 (Evaluation Metrics)
    %==================================================================
    e_y = Yr - Y;                % 횡방향 오차
    
    if length(d) > 1
        dd  = diff(d) / Ts_log;  % 조향각 변화율 (Steering Rate)
    else
        dd = 0;
    end
    
    %==================================================================
    % 9) Secondary Cost Function (고정 Alpha 기반 평가)
    %==================================================================
    alpha_tracking  = 1.0;   % 경로 추종 중요도
    alpha_stability = 5.0;   % 핸들 급조작(안정성) 중요도
    
    % 1. Tracking Cost
    cost_tracking = alpha_tracking * trapz(t, e_y.^2);
    
    % 2. Stability Cost
    if length(t) > 1
        cost_stability = alpha_stability * trapz(t(2:end), dd.^2);
    else
        cost_stability = 0;
    end
    
    % 3. Constraint Penalty (차선 이탈)
    max_ey = max(abs(e_y));
    if max_ey > 1.0
        penalty = 1e5;
    else
        penalty = 0;
    end
    
    %==================================================================
    % 10) 최종 반환 비용
    %==================================================================
    J = cost_tracking + cost_stability + penalty;
end