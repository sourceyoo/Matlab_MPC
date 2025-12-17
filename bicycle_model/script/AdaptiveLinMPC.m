function [delta_cmd, J_opt] = AdaptiveLinMPC( ...
    X, Y, psi, v, delta_prev, ...
    L, delta_max, Y_ref, psi_ref,...
    Qy, Qpsi, Rdelta, Np, Nc, dmax_deg)
%---------------------------------
% AdaptiveLinMPC (Modified for Rate Control)
%
% - 핵심 변경:
%   1) 상태 벡터 확장: [X, Y, psi, v] -> [X, Y, psi, v, delta] (nx=5)
%   2) 제어 입력 재정의: 조향각(delta) -> 조향 변화율(d_delta)
%   3) 제약 조건 변경: 조향각 제한 -> 변화율 제한 (오실레이션 방지)
%---------------------------------
    
    % [필수] coder.extrinsic 선언
    coder.extrinsic('quadprog','optimoptions');
    
    %---------------------------------
    % 1) 출력값 초기화
    %---------------------------------
    delta_cmd = delta_prev;    
    J_opt     = 0;
    
    %---------------------------------
    % 2) 기본 설정 및 파라미터 방어
    %---------------------------------
    Ts = 0.05;                 % [s] 샘플링 타임
    
    Np = max(1, round(Np));
    Nc = max(1, round(Nc));
    if Nc > Np, Nc = Np; end
    
    %---------------------------------
    % 3) [수정] 상태 벡터 확장 (nx = 5)
    %---------------------------------
    % 기존 상태: [X, Y, psi, v]
    % 확장 상태: [X, Y, psi, v, delta]
    nx = 5; 
    nu = 1;
    
    % 현재 상태 벡터 구성 (delta_prev를 5번째 상태로 포함)
    xk = [X; Y; psi; v; delta_prev];
    
    %---------------------------------
    % 4) [수정] 가중치 행렬 재구성 (5x5)
    %---------------------------------
    % Q 행렬: 5번째 상태(delta) 자체에 대한 가중치는 작게 주어 
    % 불필요한 조향을 억제 (선택사항)
    Qy     = max(Qy,     1e-4);
    Qpsi   = max(Qpsi,   1e-4);
    Rdelta = max(Rdelta, 1e-5); % 이제 R은 '변화율'에 대한 가중치가 됨 (진동 억제 핵심)
    
    % Q = diag([X, Y, psi, v, delta])
    % X, v, delta 자체에는 큰 가중치를 두지 않음 (필요시 조정)
    Q = diag([0, Qy, Qpsi, 0, 0.1]); 
    R = Rdelta; 
    
    %---------------------------------
    % 5) [수정] 모델 선형화 & 확장 (Augmented Model)
    %---------------------------------
    v_lin = max(v, 0.1); 
    
    % 5-1) 기존 Kinematic Model (4x4) 행렬 A_kin
    A_kin = [ 1, 0, -v_lin*sin(psi)*Ts, cos(psi)*Ts;           
              0, 1,  v_lin*cos(psi)*Ts, sin(psi)*Ts;           
              0, 0,  1,                 (1/L)*tan(delta_prev)*Ts; 
              0, 0,  0,                 1 ];
          
    % 5-2) 기존 입력 행렬 B_kin (4x1) -> 이제 A 행렬의 일부가 됨
    % (조향각 delta가 상태 변수들에 미치는 영향)
    sec_delta_sq = (sec(delta_prev))^2;
    B_kin = [ 0;                                        
              0;                                        
              (v_lin/L)*sec_delta_sq*Ts;              
              0 ];
          
    % 5-3) 확장된 시스템 행렬 A (5x5) 구성
    % x_{k+1} = A_kin * x_k + B_kin * delta_k
    % delta_{k+1} = delta_k + u_k (여기서 u_k는 d_delta)
    A = eye(nx);
    A(1:4, 1:4) = A_kin;       % 기존 역학
    A(1:4, 5)   = B_kin;       % delta가 상태에 미치는 영향
    A(5, 5)     = 1;           % delta 적분 (delta_{k+1} = delta_k + ...)
    
    % 5-4) 확장된 입력 행렬 B (5x1) 구성
    % 입력 u는 오직 5번째 상태(delta)만 변화시킴
    B = zeros(nx, nu);
    B(5, 1) = 1;               % delta_{k+1} = ... + 1 * u_k
    
    Ad = A; % 이미 이산화(Discrete) 형태로 구성함
    Bd = B;
    
    %---------------------------------
    % 6) [수정] 참조 궤적 생성 (Reference Trajectory)
    %---------------------------------
    % ... (기존 참조 생성 로직 동일, 단 ref_stack 사이즈가 5배수로 커짐) ...
    persistent prev_Y_ref prev_psi_ref
    if isempty(prev_Y_ref)
        prev_Y_ref  = Y_ref;
        prev_psi_ref= psi_ref;
    end
    dY_ref   = (Y_ref   - prev_Y_ref);
    dPsi_ref = (psi_ref - prev_psi_ref);
    prev_Y_ref   = Y_ref;
    prev_psi_ref = psi_ref;
    
    Y_ref_seq   = zeros(Np,1);
    psi_ref_seq = zeros(Np,1);
    for i = 1:Np
        Y_ref_seq(i)   = Y_ref   + (i-1) * dY_ref;
        psi_ref_seq(i) = psi_ref + (i-1) * dPsi_ref;
    end
    
    ref_stack = zeros(Np*nx, 1);         
    for i = 1:Np
        X_ref_i = X + v * Ts * (i-1) * cos(psi_ref_seq(i));
        
        % 5번째 상태(delta)에 대한 참조값은 0으로 설정 (중립 복귀 유도)
        x_ref_i = [X_ref_i; ...
                   Y_ref_seq(i); ...
                   psi_ref_seq(i); ...
                   v; ...
                   0]; 
        
        idx_start = (i-1)*nx + 1;
        idx_end   = i*nx;
        ref_stack(idx_start:idx_end) = x_ref_i;
    end
    
    %---------------------------------
    % 7) [수정] 제약 조건 설정 (Rate Control)
    %---------------------------------
    % 7-1) 입력 제약 (Inequality Constraints for Input u = d_delta)
    % -d_step_max <= u <= d_step_max
    d_step_max = dmax_deg * pi/180.0;          
    d_step_max = max(d_step_max, 0.5*pi/180.0); % 최소 0.5도 보장
    
    lb = -d_step_max * ones(Nc,1);             
    ub =  d_step_max * ones(Nc,1);             
    
    % 7-2) 상태 제약 (Inequality Constraints for State delta)
    % -delta_max <= delta_prev + sum(u) <= delta_max
    delta_limit = abs(delta_max);
    if delta_limit <= 0, delta_limit = 30*pi/180.0; end
    
    % 절대 조향각 제한을 위한 선형 부등식 제약조건 행렬 (A_ineq * U <= b_ineq)
    % C++ 코드의 CI_eig 부분과 동일한 역할
    % delta_k = delta_0 + u_0 + ... + u_{k-1}
    % A_ineq 행렬 구성 (L_tril: 하삼각 행렬)
    L_tril = tril(ones(Nc, Nc));
    
    % A_ineq = [ L_tril; -L_tril ]
    A_ineq = [ L_tril; -L_tril ];
    
    % b_ineq (Upper bounds)
    % L_tril * U <= delta_limit - delta_prev
    % -L_tril * U <= delta_limit + delta_prev (즉, L_tril * U >= -delta_limit - delta_prev)
    b_upper = (delta_limit - delta_prev) * ones(Nc, 1);
    b_lower = (delta_limit + delta_prev) * ones(Nc, 1);
    b_ineq  = [b_upper; b_lower];

    %---------------------------------
    % 8) QP 행렬 구성 & 풀이
    %---------------------------------
    [Phi, Gamma] = build_prediction_matrices(Ad, Bd, Np, Nc);
    
    Qbar = kron(eye(Np), Q);   
    Rbar = kron(eye(Nc), R);   
    
    X_stack_nom = Phi * xk;    
    
    H = Gamma' * Qbar * Gamma + Rbar;
    f = Gamma' * Qbar * (X_stack_nom - ref_stack);
    
    H = (H + H')/2;
    H = H + 1e-8*eye(size(H));
    
    % QP 풀이
    dU    = zeros(Nc,1);    
    
    if ~isempty(H) && ~isempty(f)
        % coder.varsize 선언 (필수)
        coder.varsize('dU_tmp', [100, 1], [1 0]); 
        dU_tmp = zeros(Nc, 1);
        fval_tmp = 0;
        
        opts = optimoptions('quadprog','Display','off');
        
        % [수정] quadprog에 선형 부등식 제약(A_ineq, b_ineq) 추가
        [dU_tmp, fval_tmp] = quadprog( ...
            H, f, A_ineq, b_ineq, [], [], lb, ub, [], opts);
            
        if ~isempty(dU_tmp)
            dU_safe = zeros(Nc,1);
            copy_len = min(length(dU_tmp), Nc);
            for i = 1:copy_len
                dU_safe(i) = dU_tmp(i);
            end
            dU = dU_safe;
            J_opt = fval_tmp;
        end
    end
    
    %---------------------------------
    % 9) [수정] 최종 조향 명령 계산
    %---------------------------------
    % MPC 출력 dU(1)은 '변화량'이므로 현재 값에 더해줌
    delta_raw = delta_prev + dU(1);
    
    % 안전을 위한 Saturation (이중 체크)
    delta_cmd = min(max(delta_raw, -delta_limit), delta_limit);
end

%====================================================================
% 로컬 함수 (수정 없음, 단 차원 증가에 자동 대응)
%====================================================================
function [Phi, Gamma] = build_prediction_matrices(Ad, Bd, Np, Nc)
    n = size(Ad,1);   
    m = size(Bd,2);   
    Phi   = zeros(Np*n, n);
    Gamma = zeros(Np*n, Nc*m);
    
    A_power = eye(n);
    for i = 1:Np
        A_power = Ad * A_power;
        Phi((i-1)*n+1:i*n, :) = A_power;
    end
    
    for r = 1:Np
        for c = 1:Nc
            if r >= c
                A_pc = eye(n);
                for k = 1:(r-c)
                    A_pc = Ad * A_pc;
                end
                Gamma((r-1)*n+1:r*n, (c-1)*m+1:c*m) = A_pc * Bd;
            end
        end
    end
end