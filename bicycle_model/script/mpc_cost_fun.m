function [J, metrics] = mpc_cost_fun(x, q)
    % --------------------------------
    % [Universal Cost Function - Ramp Edition]
    % Step, Sine뿐만 아니라 Ramp(경사) 추종에 특화된 비용 함수
    % 위치 오차 + 기울기 오차 + Soft Lane Constraint 적용
    % --------------------------------
    
    if nargin < 2, q = []; end

    % --------------------------------
    % 0. 제어 및 하드웨어 제약 조건 설정
    % --------------------------------
    Np_fixed       = 60;    % 예측 구간 (Prediction Horizon)
    Nc_fixed       = 10;    % 제어 구간 (Control Horizon)
    dmax_deg_fixed = 2;     % Δdelta 제약 [deg]

    % --------------------------------
    % 1. 초기화 및 모델 로드 (persistent)
    % --------------------------------
    persistent staticVars
    if isempty(staticVars)
        run('init_vehicle_params.m');
        s = struct();
        
        if exist('rosParams', 'var'),     s.rosParams     = rosParams;     end
        if exist('tireParams', 'var'),    s.tireParams    = tireParams;    end
        if exist('assumptions', 'var'),   s.assumptions   = assumptions;   end
        if exist('vehicleParams', 'var'), s.vehicleParams = vehicleParams; end
        
        if exist('L', 'var')
            s.L = L;
        elseif isfield(s, 'vehicleParams') && isfield(s.vehicleParams, 'a')
            s.L = s.vehicleParams.a + s.vehicleParams.b;
        else
            s.L = 2.7; 
        end
        
        if exist('delta_max', 'var'), s.delta_max = delta_max; end
        if exist('a_max', 'var'),     s.a_max     = a_max;     end
        if exist('v0', 'var'),        s.v0        = v0;        end
        if exist('x0', 'var'),        s.x0        = x0;        end
        if exist('y0', 'var'),        s.y0        = y0;        end
        if exist('psi0', 'var'),      s.psi0      = psi0;      end
        if exist('Ts', 'var'),        s.Ts        = Ts;        end
        
        staticVars = s;
        
        load_system('bicycle_kinematic');
    end
    
    % --------------------------------
    % 2. 시뮬레이션 입력 설정 (SimulationInput)
    % --------------------------------
    simIn = Simulink.SimulationInput('bicycle_kinematic');
    
    % 베이즈옵트에서 넘어온 튜닝 파라미터
    simIn = simIn.setVariable('Qy',       x.Qy);
    simIn = simIn.setVariable('Qpsi',     x.Qpsi);
    simIn = simIn.setVariable('Rdelta',   x.Rdelta);
    
    % 고정 제어 파라미터
    simIn = simIn.setVariable('Np',       Np_fixed);
    simIn = simIn.setVariable('Nc',       Nc_fixed);
    simIn = simIn.setVariable('dmax_deg', dmax_deg_fixed);
    
    % 차량 파라미터 일괄 주입
    fields = fieldnames(staticVars);
    for i = 1:numel(fields)
        simIn = simIn.setVariable(fields{i}, staticVars.(fields{i}));
    end
    
    % Sim 옵션
    simIn = simIn.setModelParameter('FastRestart', 'on');
    simIn = simIn.setModelParameter('StopTime', '10'); 
    simIn = simIn.setModelParameter('SaveOutput', 'off');

    % --------------------------------
    % 3. 시뮬레이션 실행 및 예외 처리
    % --------------------------------
    try
        simOut = sim(simIn);
    catch
        J = 1e9; 
        metrics = struct('Error','SimFail');
        return; 
    end
    
    if simOut.ErrorMessage
        J = 1e9; 
        metrics = struct('Error','SimError');
        return;
    end
    
    % --------------------------------
    % 4. 로그 데이터 추출 (이제 Y_ref 하나만 존재)
    % --------------------------------
    logs = simOut.logsout;
    try
        % Y
        Y_ts     = logs.get('Y').Values;
        % Y_ref (유일한 하나)
        Yref_ts  = logs.get('Y_ref').Values;
        % delta_cmd
        delta_ts = logs.get('delta_cmd').Values;
        
        % psi, psi_ref (없으면 0으로 대체)
        try
            Psi_ts     = logs.get('psi').Values;
            Psi_ref_ts = logs.get('psi_ref').Values; 
        catch
            Psi_ts     = Y_ts; Psi_ts.Data(:)     = 0;
            Psi_ref_ts = Y_ts; Psi_ref_ts.Data(:) = 0;
        end
    catch
        J = 1e9; 
        metrics = struct('Error','LogFail');
        return;
    end
    
    % 벡터 변환
    t       = Y_ts.Time;
    Y       = Y_ts.Data;
    Yr      = Yref_ts.Data;
    d       = delta_ts.Data;
    Psi     = Psi_ts.Data;
    Psi_ref = Psi_ref_ts.Data;
    
    % --------------------------------
    % 5. 성능 지표(Metrics) 계산
    % --------------------------------
    e_y   = Yr - Y;           % 위치 에러
    e_psi = Psi_ref - Psi;    % 헤딩 에러
    
    target_y = 1.0;           % Step 기준 값 (Ramp에서도 호환용)
    tol_y    = 0.05;
    tol_psi  = deg2rad(0.5);
    
    unsettled_indices = find((abs(Y - target_y) > tol_y) | (abs(e_psi) > tol_psi));
    if isempty(unsettled_indices)
        t_settle = 0;
    else
        t_settle = t(unsettled_indices(end));
    end
    
    rmse        = sqrt(mean(e_y.^2));
    max_dev     = max(abs(e_y));
    max_psi_deg = rad2deg(max(abs(Psi)));
    
    metrics.RMSE       = rmse;
    metrics.MaxErr     = max_dev;
    metrics.T_settle   = t_settle;
    metrics.MaxPsi_deg = max_psi_deg;
    
    % --------------------------------
    % 6. 비용 함수 계산 (Ramp 대응 버전)
    % --------------------------------
    if numel(t) > 1
        dt = mean(diff(t));
    else
        dt = 0.05;
    end
    
    % (1) 위치 에러 + ITAE 완화 버전
    w_pos    = 1 + 0.5*t;                 
    cost_pos = trapz(t, w_pos .* (e_y.^2));
    
    % (2) 램프 기울기 추종 (Y_dot vs Yref_dot)
    if numel(Y) > 1
        dY   = diff(Y)  / dt;
        dYr  = diff(Yr) / dt;
        e_dY = dYr - dY;
        w_slope    = 5;                   
        cost_slope = trapz(t(2:end), w_slope * (e_dY.^2));
    else
        cost_slope = 0;
    end
    
    cost_tracking = cost_pos + cost_slope;
    
    % (3) Heading Alignment
    cost_heading = 10 * trapz(t, e_psi.^2);
    
    % (4) Terminal Cost
    terminal_error = e_y(end)^2 + e_psi(end)^2;
    cost_terminal  = terminal_error;
    
    % (5) Stability (조향 변화율 억제)
    if numel(d) > 1
        dd = diff(d) / dt;
        cost_stability = trapz(t(2:end), dd.^2); 
    else
        cost_stability = 0;
    end
    
    % (6) Lane soft penalty
    lane_limit = 0.8;                           
    violation  = max(0, abs(e_y) - lane_limit); 
    cost_lane  = 1e4 * trapz(t, violation.^2);  
    
    % (7) Peak Error Penalty
    cost_peak = 2 * max_dev;
    
    % 최종 비용
    J = cost_tracking + cost_heading + cost_terminal + ...
        cost_stability + cost_peak + cost_lane;

    % --------------------------------
    % 7. 실시간 로그 전송 (Reporting)
    % --------------------------------
    if ~isempty(q)
        tsk = getCurrentTask();
        if isempty(tsk)
            wID = 1;
        else
            wID = tsk.ID;
        end
    
        msg = sprintf('[W%d] RMSE:%.3f | T_set:%.2fs | MaxErr:%.3f | Qy:%.1f, Qp:%.1f, Rd:%.1f', ...
                      wID, rmse, t_settle, max_dev, x.Qy, x.Qpsi, x.Rdelta);
        send(q, msg);
    end
end
