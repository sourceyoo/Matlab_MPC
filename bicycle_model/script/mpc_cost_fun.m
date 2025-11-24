function J = mpc_cost_fun(x)


    % x : bayesopt에서 넘어오는 파라미터 구조체
    %     사용 필드: Qy, Qpsi, Rdelta
    %     (Np, Nc는 여기서 고정값 사용)

    %=============================
    % 0) Horizon 고정 (v = 3 m/s, Ts = 0.05s 기준)
    %=============================
    Np_fixed = 30;   % prediction horizon (≈ 1.5 s)
    Nc_fixed = 6;    % control horizon   (Np의 1/5)

    % (2) 조향각 최대값 [deg] — 하드웨어 스펙 반영
    dmax_deg_fixed = 27;   % servo/steering 최대 조향각 ±27도
    
    % 1) SimulationInput 객체 생성
    simIn = Simulink.SimulationInput('bicycle_kinematic');
    
    % 2) 파라미터 주입 (MPC 내부에서 쓸 Q,R,Np,Nc,dmax)
    simIn = simIn.setVariable('Qy',       x.Qy);
    simIn = simIn.setVariable('Qpsi',     x.Qpsi);
    simIn = simIn.setVariable('Rdelta',   x.Rdelta);
    % 👉 여기서 Np, Nc를 고정값으로 주입
    simIn = simIn.setVariable('Np',       Np_fixed);
    simIn = simIn.setVariable('Nc',       Nc_fixed);
    % 👉 dmax_deg도 고정값 사용
    simIn = simIn.setVariable('dmax_deg', dmax_deg_fixed);
    
    % 3) 시뮬레이션 설정
    simIn = simIn.setModelParameter('StopTime', '10');
    simIn = simIn.setModelParameter('SaveOutput', 'off');
    simIn = simIn.setModelParameter('SaveState', 'off');
    simIn = simIn.setModelParameter('SaveFormat', 'Dataset'); 
    
    % 4) 시뮬레이션 실행
    simOut = sim(simIn); 
    
    % 5) 에러 처리
    if simOut.ErrorMessage
        J = NaN; 
        return;
    end
    
    % 6) 로그 꺼내기
    logs = simOut.logsout;
    
    Yref_ts  = logs.get('Y_ref').Values;
    Y_ts     = logs.get('Y').Values;
    delta_ts = logs.get('delta_cmd').Values;

    % (있다면) yaw 에러도 같이 꺼내기
    hasPsi = false;
    try
        psi_ref_ts = logs.get('psi_ref').Values;
        psi_ts     = logs.get('psi').Values;
        hasPsi = true;
    catch
        hasPsi = false;
    end
    
    % 7) 타임/데이터 벡터 준비
    t  = Y_ts.Time;
    Y  = Y_ts.Data;
    Yr = Yref_ts.Data;
    d  = delta_ts.Data;
    
    Ts = mean(diff(t));
    if isnan(Ts) || isempty(Ts) || Ts <= 0
        Ts = 0.01; 
    end 
    
    %==================================================================
    %   8) 상태/입력 에러 정의
    %==================================================================
    % 상태 1: 횡방향 오차 e_y
    e_y = Yr - Y;                % e_y(t)
    
    % 상태 2: yaw 오차 e_psi (있으면 사용, 없으면 0으로 둠)
    if hasPsi
        e_psi = psi_ref_ts.Data - psi_ts.Data;
    else
        e_psi = zeros(size(e_y));
    end

    % 입력: 조향각 변화율 ≈ d_dot
    dd    = diff(d) / Ts;        % d_dot(t_k) ≈ (d_k - d_{k-1})/Ts
    t_dd  = t(2:end);

    %==================================================================
    %   9) Q,R 기반 stage cost 계산
    %==================================================================
    % Q = diag(Qy, Qpsi), R = Rdelta 라고 보는 것
    Qy     = x.Qy;
    Qpsi   = x.Qpsi;
    Rdelta = x.Rdelta;

    % 상태 비용: e_y^2, e_psi^2에 Qy, Qpsi 가중
    L_state = Qy   * (e_y.^2) + ...
              Qpsi * (e_psi.^2);

    % 입력 비용: (1) 조향각 변화율 + (2) 절대 조향각 둘 다 패널티
    Rdelta_rate = Rdelta;          % 기존 Rdelta는 rate에
    Rdelta_abs  = 0.1 * Rdelta;    % 절대값용은 조금 더 작게
    
    % 9-1) rate 비용 (dd: 길이 N-1, t_dd 사용)
    L_rate  = Rdelta_rate * (dd.^2);
    J_rate  = trapz(t_dd, L_rate);

    % 9-2) absolute 비용 (d: 길이 N, t 사용)
    L_abs   = Rdelta_abs  * (d.^2);
    J_abs   = trapz(t,    L_abs);

    % 시간 적분 (연속시간 근사)
    J_state = trapz(t,    L_state);   % ∫ x^T Q x dt
    % 최종 입력 비용
    J_input = J_rate + J_abs;

    %==================================================================
    %  10) Terminal Cost: P * x_T^2  (여기선 e_y, e_psi만 사용)
    %==================================================================
    % P_y, P_psi는 별도 튜닝 파라미터로 둘 수도 있고,
    % 간단히 Qy, Qpsi와 동일하게 둘 수도 있음.
    P_y   = Qy;      % 혹은 고정 상수/별도 변수로 바꿔도 됨
    P_psi = Qpsi;    % yaw도 중요하게 보려면 이렇게

    e_y_final   = e_y(end);
    e_psi_final = e_psi(end);

    J_terminal = P_y   * (e_y_final^2) + ...
                 P_psi * (e_psi_final^2);

    %==================================================================
    %  11) Soft Constraint: 차선 이탈 패널티 (슬랙 변수 느낌)
    %==================================================================
    abs_e = abs(e_y);
    over1 = max(0, abs_e - 1);   % |e_y| > 1인 구간만
    pen   = over1.^2;

    lambda_pen = 10.0;           % 슬랙 가중치 (고정 상수)
    J_pen = lambda_pen * trapz(t, pen);

    %==================================================================
    %  12) 최종 비용 합산 (Q,R,P 스타일 + soft constraint)
    %==================================================================
    J = J_state + J_input + J_pen + J_terminal;

end
