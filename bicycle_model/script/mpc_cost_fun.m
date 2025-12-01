function [J, metrics] = mpc_cost_fun(x, q)
    % --------------------------------
    % [Universal Cost Function]
    % Step, Sine, Ramp 등 다양한 경로 추종을 위한 통합 비용 함수
    % ITAE(시간 가중 오차 적분)를 적용하여 정착 시간과 추종 오차를 동시에 최소화
    % 또한, 상세 성능 지표(RMSE, Settling Time 등)를 반환하여 분석을 용이하게 함
    % --------------------------------
    
    if nargin < 2, q = []; end

    % --------------------------------
    % 0. 제어 및 하드웨어 제약 조건 설정
    % (최적화 대상이 아닌 고정된 상수값 정의)
    % --------------------------------
    Np_fixed       = 120;    % 예측 구간 (Prediction Horizon) - 시야 대폭 확장 (80->120)
    Nc_fixed       = 24;     % 제어 구간 (Control Horizon) - 제어 자유도 확보
    dmax_deg_fixed = 27;     % 차량의 최대 조향각 한계

    % --------------------------------
    % 1. 초기화 및 모델 로드 (속도 최적화)
    % (Persistent 변수를 사용하여 매 실행마다 초기화 스크립트가 도는 것을 방지)
    % --------------------------------
    persistent staticVars
    if isempty(staticVars)
        run('init_vehicle_params.m');
        s = struct();
        
        % 작업 공간에 있는 차량 파라미터 백업
        if exist('rosParams', 'var'),     s.rosParams     = rosParams;     end
        if exist('tireParams', 'var'),    s.tireParams    = tireParams;    end
        if exist('assumptions', 'var'),   s.assumptions   = assumptions;   end
        if exist('vehicleParams', 'var'), s.vehicleParams = vehicleParams; end
        
        % 휠베이스(L) 계산 로직
        if exist('L', 'var')
            s.L = L;
        elseif isfield(s, 'vehicleParams') && isfield(s.vehicleParams, 'a')
            s.L = s.vehicleParams.a + s.vehicleParams.b;
        else
            s.L = 2.7; % 비상용 기본값
        end
        
        % 기타 필수 물리량 저장
        if exist('delta_max', 'var'), s.delta_max = delta_max; end
        if exist('a_max', 'var'),     s.a_max     = a_max;     end
        if exist('v0', 'var'),        s.v0        = v0;        end
        if exist('x0', 'var'),        s.x0        = x0;        end
        if exist('y0', 'var'),        s.y0        = y0;        end
        if exist('psi0', 'var'),      s.psi0      = psi0;      end
        if exist('Ts', 'var'),        s.Ts        = Ts;        end
        
        staticVars = s;
        
        % Fast Restart 기능을 위해 모델을 메모리에 미리 로드
        load_system('bicycle_kinematic');
    end
    
    % --------------------------------
    % 2. 시뮬레이션 입력 설정 (SimulationInput)
    % (최적화 변수와 고정 파라미터를 시뮬링크 모델에 주입)
    % --------------------------------
    simIn = Simulink.SimulationInput('bicycle_kinematic');
    
    % 베이지안 최적화가 제안한 변수 (가변)
    simIn = simIn.setVariable('Qy',       x.Qy);
    simIn = simIn.setVariable('Qpsi',     x.Qpsi);
    simIn = simIn.setVariable('Rdelta',   x.Rdelta);
    
    % 고정 제어 변수
    simIn = simIn.setVariable('Np',       Np_fixed);
    simIn = simIn.setVariable('Nc',       Nc_fixed);
    simIn = simIn.setVariable('dmax_deg', dmax_deg_fixed);
    
    % 정적 차량 파라미터 일괄 주입
    fields = fieldnames(staticVars);
    for i = 1:numel(fields)
        simIn = simIn.setVariable(fields{i}, staticVars.(fields{i}));
    end
    
    % 시뮬레이션 옵션 설정 (FastRestart ON)
    simIn = simIn.setModelParameter('FastRestart', 'on');
    simIn = simIn.setModelParameter('StopTime', '10'); 
    simIn = simIn.setModelParameter('SaveOutput', 'off');

    % --------------------------------
    % 3. 시뮬레이션 실행 및 예외 처리
    % (수학적 오류 등으로 시뮬레이션 실패 시 최적화 중단 방지)
    % --------------------------------
    try
        simOut = sim(simIn);
    catch
        J = 1e9; metrics.Error = 'SimFail'; return; 
    end
    
    if simOut.ErrorMessage
        J = 1e9; metrics.Error = 'SimError'; return;
    end
    
    % --------------------------------
    % 4. 로그 데이터 추출
    % (비용 함수 계산에 필요한 위치, 헤딩, 조향각 데이터 확보)
    % --------------------------------
    logs = simOut.logsout;
    try
        Yref_ts  = logs.get('Y_ref').Values;
        Y_ts     = logs.get('Y').Values;
        delta_ts = logs.get('delta_cmd').Values;
        
        % [주의] Sine/Ramp 주행 시 Psi_ref는 0이 아님! 
        try
            Psi_ts = logs.get('psi').Values;
            Psi_ref_ts = logs.get('psi_ref').Values; 
        catch
            % 로그가 없으면 0 처리 (Simulink 연결 확인 필요)
            Psi_ts = Y_ts; Psi_ts.Data(:) = 0;
            Psi_ref_ts = Y_ts; Psi_ref_ts.Data(:) = 0;
        end
    catch
        J = 1e9; metrics.Error = 'LogFail'; return;
    end
    
    % 벡터 변환
    t = Y_ts.Time;
    Y = Y_ts.Data;
    Yr = Yref_ts.Data;
    d = delta_ts.Data;
    Psi = Psi_ts.Data;
    Psi_ref = Psi_ref_ts.Data;
    
    % --------------------------------
    % 5. 성능 지표(Metrics) 계산 (분석용)
    % (비용 함수 계산과는 별개로, 사용자가 결과를 분석하기 위한 지표들)
    % --------------------------------
    
    e_y = Yr - Y;           % 위치 에러
    e_psi = Psi_ref - Psi;  % 헤딩 에러
    
    % (1) 정착 시간 (Settling Time) - Step 주행 시 유효
    target_y = 1.0;
    tol_y = 0.05;            % 위치 오차 5cm 이내
    tol_psi = deg2rad(0.5);  % 헤딩 오차 0.5도 이내 (게걸음 방지)
    
    unsettled_indices = find((abs(Y - target_y) > tol_y) | (abs(e_psi) > tol_psi));
    if isempty(unsettled_indices)
        t_settle = 0;
    else
        t_settle = t(unsettled_indices(end));
    end
    
    % (2) RMSE 및 최대 오차 계산
    rmse = sqrt(mean(e_y.^2));
    max_dev = max(abs(e_y));
    max_psi_deg = rad2deg(max(abs(Psi)));
    
    % [Output 2] 상세 지표 구조체 생성
    metrics.RMSE = rmse;
    metrics.MaxErr = max_dev;
    metrics.T_settle = t_settle;
    metrics.MaxPsi_deg = max_psi_deg;
    
    % --------------------------------
    % 6. 비용 함수 계산 (Cost Function Calculation)
    % --------------------------------
    
    % (1) Tracking Accuracy (ITAE 기법)
    % 시간이 갈수록(t) 가중치를 높여, 후반부의 미세한 오차를 강력하게 처벌함.
    % Step에서는 빠른 정착을, Sine에서는 위상 지연(Lag) 감소를 유도.
    cost_tracking = trapz(t, (e_y.^2) .* (1 + t)); 
    
    % (2) Heading Alignment (게걸음 방지)
    % 목표 헤딩과 실제 헤딩이 다르면 페널티 부여.
    cost_heading = 50 * trapz(t, e_psi.^2);
    
    % (3) Terminal Cost (종단 비용) - [핵심]
    % 시뮬레이션의 '마지막 순간'에 오차가 남아있으면 가중치 10,000배 부여
    % -> MPC가 "시간 내에 무조건 도달해야 한다"는 압박을 받음
    terminal_error = e_y(end)^2 + e_psi(end)^2;
    cost_terminal = 10000 * terminal_error;
    
    % (4) Stability (핸들 댐핑) - [핵심]
    % 조향각의 급격한 변화율(dd)을 억제하여 부드러운 주행 유도 (진동 억제)
    % 가중치 100배로 상향하여 묵직한 핸들링 유도
    if length(d) > 1
        dd = diff(d) / mean(diff(t));
        cost_stability = 100 * trapz(t(2:end), dd.^2); 
    else
        cost_stability = 0;
    end
    
    % (5) Worst-Case Penalty (안전 장치)
    % 차량이 경로에서 1.5m 이상 크게 벗어나면 즉시 실격 처리(폭탄 비용)
    penalty = (max_dev > 1.5) * 1e5;
    
    % (6) Peak Error Penalty
    % 오버슈트나 코너링 시 최대 쏠림량을 줄이도록 유도
    cost_peak = 10 * max_dev;
    
    % --------------------------------
    % 최종 비용 합산
    % --------------------------------
    J = cost_tracking + cost_heading + cost_terminal + cost_stability + cost_peak + penalty;

    % --------------------------------
    % 7. 실시간 로그 전송 (Reporting)
    % (run_bayesopt 화면에 현재 상태를 출력하기 위함)
    % --------------------------------
    if ~isempty(q)
        try, wID = labindex; catch, wID = 1; end
        msg = sprintf('[W%d] RMSE:%.3f | T_set:%.2fs | MaxErr:%.3f | Qy:%.1f, Qp:%.1f, Rd:%.1f', ...
                      wID, rmse, t_settle, max_dev, x.Qy, x.Qpsi, x.Rdelta);
        send(q, msg);
    end
end