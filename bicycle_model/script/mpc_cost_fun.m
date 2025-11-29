function J = mpc_cost_fun(x, q)
    % [목표] Fast Rise + 0.5 deg Alignment Criteria (게걸음 방지)
    
    % 방어 코드
    if nargin < 2, q = []; end

    % 0. 설정 고정
    Np_fixed       = 80;    % 시야 확보
    Nc_fixed       = 20;    
    dmax_deg_fixed = 27;

    % 1. 초기화 (Persistent 사용으로 속도 향상)
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
            s.L = 2.7; % 기본값 (필요시 수정)
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
    
    % 2. SimulationInput 객체 생성
    simIn = Simulink.SimulationInput('bicycle_kinematic');
    simIn = simIn.setVariable('Qy',       x.Qy);
    simIn = simIn.setVariable('Qpsi',     x.Qpsi);
    simIn = simIn.setVariable('Rdelta',   x.Rdelta);
    simIn = simIn.setVariable('Np',       Np_fixed);
    simIn = simIn.setVariable('Nc',       Nc_fixed);
    simIn = simIn.setVariable('dmax_deg', dmax_deg_fixed);
    
    fields = fieldnames(staticVars);
    for i = 1:numel(fields)
        simIn = simIn.setVariable(fields{i}, staticVars.(fields{i}));
    end
    
    simIn = simIn.setModelParameter('FastRestart', 'on');
    simIn = simIn.setModelParameter('StopTime', '10'); 
    simIn = simIn.setModelParameter('SaveOutput', 'off');

    % 3. 실행
    try
        simOut = sim(simIn);
    catch
        J = 1e9; return;
    end
    
    if simOut.ErrorMessage
        J = 1e9; return;
    end
    
    % 4. 데이터 추출
    logs = simOut.logsout;
    try
        Yref_ts  = logs.get('Y_ref').Values;
        Y_ts     = logs.get('Y').Values;
        delta_ts = logs.get('delta_cmd').Values;
        
        try
            Psi_ts = logs.get('psi').Values;
            Psi_ref_ts = logs.get('psi_ref').Values; 
        catch
            % psi 로그 없으면 0 처리 (게걸음 판별 불가 주의)
            Psi_ts = Y_ts; Psi_ts.Data(:) = 0;
            Psi_ref_ts = Y_ts; Psi_ref_ts.Data(:) = 0;
        end
    catch
        J = 1e9; return;
    end
    
    t = Y_ts.Time;
    Y = Y_ts.Data;
    Yr = Yref_ts.Data;
    d = delta_ts.Data;
    Psi = Psi_ts.Data;
    Psi_ref = Psi_ref_ts.Data;
    
    % =====================================================================
    % 5. 비용 함수 (게걸음 방지: 0.5도 허용 오차)
    % =====================================================================
    
    % (1) 정착 시간 (Settling Time) - 조건 매우 엄격하게 강화
    target_y = 1.0;
    tol_y = 0.05;            % 위치 오차 5cm 이내
    tol_psi = deg2rad(0.5);  % [핵심] 헤딩 오차 0.5도 이내 (약 0.0087 rad)
    
    e_y = Yr - Y;
    e_psi = Psi_ref - Psi;
    
    % 정착 실패 조건: 위치가 벗어났거나 OR 헤딩이 0.5도 이상 틀어졌거나
    % (둘 중 하나라도 만족하지 못하면 아직 정착하지 못한 것임)
    unsettled_indices = find((abs(Y - target_y) > tol_y) | (abs(e_psi) > tol_psi));
    
    if isempty(unsettled_indices)
        t_settle = 0;
    else
        % 마지막으로 범위를 벗어난 시간이 정착 시간임
        t_settle = t(unsettled_indices(end));
    end
    
    % (2) 상승 시간 가속 (Rise Time Weight)
    % 초반 3초간 에러 페널티 2배
    time_weight = 1 + (t < 3.0) * 2.0; 
    cost_tracking = trapz(t, (e_y.^2) .* time_weight); 
    
    % (3) 정렬 비용 (Alignment Cost)
    % 목표 지점 근처(0.8m~)에서 헤딩이 틀어지면 페널티 부여
    is_near_target = (abs(Y) > 0.8);
    cost_alignment = 50 * trapz(t, (e_psi.^2) .* is_near_target); 
    
    % (4) 안정성 (Damping)
    if length(d) > 1
        dd = diff(d) / mean(diff(t));
        cost_stability = 0.5 * trapz(t(2:end), dd.^2);
    else
        cost_stability = 0;
    end
    
    % (5) 정착 시간 벌점 (가장 중요한 평가 요소)
    cost_settling = 100 * t_settle; % 1초 늦어질 때마다 100점 감점
    
    % (6) Barrier Penalty (폭주 방지)
    max_ey = max(abs(Y)); 
    penalty = (max_ey > 1.2) * 1e5;
    
    J = cost_tracking + cost_alignment + cost_stability + cost_settling + penalty;

    % 실시간 로그 전송
    if ~isempty(q)
        try, wID = labindex; catch, wID = 1; end
        % MaxPsi를 각도(deg)로 변환하여 출력 (직관적 확인용)
        msg = sprintf('[W%d] T_set:%.2fs | MaxY:%.2f | MaxPsi:%.2fdeg | Qy:%.1f, Qp:%.1f, Rd:%.1f', ...
                      wID, t_settle, max(Y), rad2deg(max(abs(Psi))), x.Qy, x.Qpsi, x.Rdelta);
        send(q, msg);
    end
end