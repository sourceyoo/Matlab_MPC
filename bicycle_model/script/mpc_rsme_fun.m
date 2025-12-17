function [J, metrics] = mpc_rsme_fun(x, q)
% mpc_rsme_fun (Fast Settling Booster Version)
% --------------------------------------------
%  목표: 오버슛 발생 후 즉시 경로에 안착 (Heading 정렬 + Damping 강화)
% --------------------------------------------
    if nargin < 2
        q = [];
    end
    
    % --------------------------------
    % 0. 제어 및 제약 고정값
    % --------------------------------
    Np_fixed       = 30;    % [수정] 50 -> 30 (너무 길면 반응 둔감)
    Nc_fixed       = 5;    
    dmax_deg_fixed = 7;    % 넉넉한 핸들링 허용
    
    % --------------------------------
    % 1. 초기화 (persistent)
    % --------------------------------
    persistent staticVars
    if isempty(staticVars)
        run('init_vehicle_params.m');
        s = struct();
        if exist('rosParams', 'var'),     s.rosParams     = rosParams;     end
        if exist('tireParams', 'var'),    s.tireParams    = tireParams;    end
        if exist('assumptions', 'var'),   s.assumptions   = assumptions;   end
        if exist('vehicleParams', 'var'), s.vehicleParams = vehicleParams; end
        if exist('L', 'var'), s.L = L; else, s.L = 2.7; end
        if exist('delta_max', 'var'), s.delta_max = delta_max; end
        if exist('a_max',     'var'), s.a_max     = a_max;     end
        if exist('v0',        'var'), s.v0        = v0;        end
        if exist('x0',        'var'), s.x0        = x0;        end
        if exist('y0',        'var'), s.y0        = y0;        end
        if exist('psi0',      'var'), s.psi0      = psi0;      end
        if exist('Ts',        'var'), s.Ts        = Ts;        end
        staticVars = s;
        load_system('bicycle_kinematic');
    end
    
    % --------------------------------
    % 2. SimulationInput
    % --------------------------------
    simIn = Simulink.SimulationInput('bicycle_kinematic');
    simIn = simIn.setVariable('Qy',     x.Qy);
    simIn = simIn.setVariable('Qpsi',   x.Qpsi);
    simIn = simIn.setVariable('Rdelta', x.Rdelta);
    simIn = simIn.setVariable('Np',       Np_fixed);
    simIn = simIn.setVariable('Nc',       Nc_fixed);
    simIn = simIn.setVariable('dmax_deg', dmax_deg_fixed);
    
    fields = fieldnames(staticVars);
    for i = 1:numel(fields)
        simIn = simIn.setVariable(fields{i}, staticVars.(fields{i}));
    end
    
    simIn = simIn.setModelParameter('FastRestart', 'on');
    simIn = simIn.setModelParameter('StopTime',    '20'); 
    simIn = simIn.setModelParameter('SaveOutput',  'off');
    
    try, simOut = sim(simIn); catch, J=1e9; metrics=struct('Error','SimFail'); return; end
    if isprop(simOut, 'ErrorMessage') && ~isempty(simOut.ErrorMessage), J=1e9; metrics=struct('Error','SimError'); return; end
    
    logs = simOut.logsout;
    try
        Y_ts = logs.get('Y').Values; Yref_ts = logs.get('Y_ref').Values;
        delta_ts = logs.get('delta_cmd').Values;
        try, Psi_ts = logs.get('psi').Values; Psi_ref_ts = logs.get('psi_ref').Values;
        catch, Psi_ts = Y_ts; Psi_ts.Data(:)=0; Psi_ref_ts = Y_ts; Psi_ref_ts.Data(:)=0; end
    catch, J=1e9; metrics=struct('Error','LogFail'); return; end
    
    t = Y_ts.Time; Y = Y_ts.Data; Y_ref = Yref_ts.Data;
    delta = delta_ts.Data; Psi = Psi_ts.Data; Psi_ref = Psi_ref_ts.Data;
    
    % --------------------------------
    % 5. 비용 함수 (Settling 강화)
    % --------------------------------
    e_y = Y_ref - Y;          
    e_psi = Psi_ref - Psi;      
    
    % (1) Rise Time
    target_y = Y_ref(end);
    if abs(target_y) < 1e-3, T_rise = 0; 
    else
        idx_rise = find(Y >= 0.90 * target_y, 1, 'first');
        if isempty(idx_rise), T_rise = 20; else, T_rise = t(idx_rise); end
    end
    
    % (2) IAE
    iae_y = trapz(t, abs(e_y));
    
    % (3) RMSE
    rmse_y = sqrt(mean(e_y.^2));         

    % (4) T_settle
    tol_y = 0.03 * max(abs(Y_ref)); if tol_y<0.03, tol_y=0.03; end 
    unsettled_idx = find(abs(e_y) > tol_y);
    if isempty(unsettled_idx), T_settle=0; else, T_settle=t(unsettled_idx(end)); end

    % (5) [추가] Damping (핸들 떨림 방지 -> 부드러운 안착 유도)
    if numel(t) > 1
        d_delta = diff(delta) ./ mean(diff(t));
        cost_damping = trapz(t(2:end), d_delta.^2);
    else
        cost_damping = 0;
    end

    % (6) 가중치 설정 (Settling 최우선)
    w_rise     = 200.0;     
    w_iae      = 100.0;      
    w_rmse     = 1000.0;      
    w_psi      = 200.0;     % 헤딩 가중치
    w_damping  = 1.0;       % 2차 오버슛 방지
    
    % 최종 비용 J
    J = w_rise * T_rise ...
      + w_iae  * iae_y ...
      + w_rmse * rmse_y ...
      + w_psi  * sqrt(mean(e_psi.^2)) ...
      + w_damping * cost_damping;
      
    % --------------------------------
    % 6. 결과 반환
    % --------------------------------
    metrics = struct();
    metrics.T_rise = T_rise; metrics.T_settle = T_settle;
    metrics.IAE = iae_y; metrics.RMSE = rmse_y;       
    metrics.MaxErr = max(abs(e_y)); metrics.MaxPsi_deg = max(abs(rad2deg(e_psi)));
    metrics.J_rmse = J;
    
    if ~isempty(q)
        tsk = getCurrentTask(); wID=1; if ~isempty(tsk), wID=tsk.ID; end
        msg = sprintf('[W%d] J=%.0f | Rise=%.2f | IAE=%.2f | Qy=%.0f, R=%.4f', wID, J, metrics.T_rise, metrics.IAE, x.Qy, x.Rdelta);
        send(q, msg);
    end
end