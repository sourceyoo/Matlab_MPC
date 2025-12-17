function [delta_cmd, J_opt] = AdaptiveLinMPC( ...
    X, Y, psi, v, delta_prev, ...
    L, delta_max, Y_ref, psi_ref,...
    Qy, Qpsi, Rdelta, Np, Nc, dmax_deg)
%---------------------------------
% AdaptiveLinMPC
%
% - 선형화된 Kinematic Bicycle Model 기반의 선형 MPC
% - 수정사항:
%   1) coder.extrinsic 위치 최상단 고정
%   2) dU_tmp (quadprog 출력) 변수 사이즈 오류 수정 (coder.varsize 적용)
%---------------------------------
    
    % [필수] coder.extrinsic은 반드시 함수 최상단에 위치
    coder.extrinsic('quadprog','optimoptions');
    
    %---------------------------------
    % 1) 기본 출력값 초기화
    %---------------------------------
    % 신호 차원 오류 방지를 위한 명시적 초기화 (Scalar Double)
    delta_cmd = 0; 
    J_opt     = 0;
    
    delta_cmd = delta_prev;    % 실패 시: 이전 조향 유지
    J_opt     = NaN;           % 비용은 NaN으로 표시
    
    %---------------------------------
    % 2) 샘플링 타임 및 horizon 방어 코드
    %---------------------------------
    Ts = 0.05;                 % [s] 샘플링 타임
    
    % Np, Nc 정수화 및 최소값 보장
    Np = max(1, round(Np));
    Nc = max(1, round(Nc));
    if Nc > Np
        Nc = Np;
    end
    
    %---------------------------------
    % 3) 가중치 방어
    %---------------------------------
    Qy     = max(Qy,     1e-4);
    Qpsi   = max(Qpsi,   1e-4);
    Rdelta = max(Rdelta, 1e-5);
    
    Q = diag([0, Qy, Qpsi, 0]);
    R = Rdelta;

    %---------------------------------
    % 4) 제약 조건 설정
    %---------------------------------
    d_step_max = dmax_deg * pi/180.0;          
    d_step_max = max(d_step_max, 0.5*pi/180.0);
    
    lb = -d_step_max * ones(Nc,1);             
    ub =  d_step_max * ones(Nc,1);             

    delta_limit = abs(delta_max);
    if delta_limit <= 0
        delta_limit = 30*pi/180.0;             
    end
    delta_min     = -delta_limit;
    delta_max_abs =  delta_limit;

    %---------------------------------
    % 5) 모델 선형화 (Linearization)
    %---------------------------------
    v_lin = max(v, 0.1);        
    A = [ 0, 0, -v_lin*sin(psi),  cos(psi);           
          0, 0,  v_lin*cos(psi),  sin(psi);           
          0, 0,  0,               (1/L)*tan(delta_prev); 
          0, 0,  0,               0 ];
    B = [ 0;                                        
          0;                                        
          (v_lin/L)*sec(delta_prev)^2;              
          0 ];

    Ad = eye(4) + Ts*A;
    Bd = Ts * B;
    xk = [X; Y; psi; v];

    %---------------------------------
    % 6) 참조 궤적 생성 (Reference Trajectory)
    %---------------------------------
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

    n = 4;                              
    ref_stack = zeros(Np*n, 1);         
    for i = 1:Np
        X_ref_i = X + v * Ts * (i-1) * cos(psi_ref_seq(i));
        v_ref_i = v;                    
        x_ref_i = [X_ref_i; ...
                   Y_ref_seq(i); ...
                   psi_ref_seq(i); ...
                   v_ref_i];
        
        idx_start = (i-1)*n + 1;
        idx_end   = i*n;
        ref_stack(idx_start:idx_end) = x_ref_i;
    end

    %---------------------------------
    % 7) QP 행렬 구성
    %---------------------------------
    [Phi, Gamma] = build_prediction_matrices(Ad, Bd, Np, Nc);
    
    Qbar = kron(eye(Np), Q);   
    Rbar = kron(eye(Nc), R);   
    
    X_stack_nom = Phi * xk;    
    
    H = Gamma' * Qbar * Gamma + Rbar;
    f = Gamma' * Qbar * (X_stack_nom - ref_stack);
    
    H = (H + H')/2;
    H = H + 1e-8*eye(size(H));

    %---------------------------------
    % 8) QP 풀이 (Extrinsic 호출)
    %---------------------------------
    dU    = zeros(Nc,1);    
    
    if ~isempty(H) && ~isempty(f)
        nvar = length(f);
        if nvar > 0
            
            % 고정 크기 결과 버퍼 (Simulink용 안전 변수)
            dU_safe = zeros(Nc,1);   

            % [수정 핵심] dU_tmp를 가변 크기 변수로 선언하고 초기화
            % - coder.varsize: 변수 크기가 런타임에 변할 수 있음을 선언
            % - [100, 1]: 최대 크기 (Horizon이 100을 넘지 않는다고 가정)
            % - [1, 0]: 첫 번째 차원(행)이 가변적임을 의미
            coder.varsize('dU_tmp', [100, 1], [1 0]); 
            dU_tmp = zeros(Nc, 1); % 초기값은 현재 Nc 크기로 설정
            
            fval_tmp = 0;
            
            opts = optimoptions('quadprog','Display','off');

            % quadprog 호출
            [dU_tmp, fval_tmp] = quadprog( ...
                H, f, [], [], [], [], lb, ub, [], opts);

            % mxArray 결과를 고정 크기 버퍼로 안전하게 복사
            if ~isempty(dU_tmp)
                % quadprog가 반환한 크기와 Nc 중 작은 것만큼 복사
                copy_len = min(length(dU_tmp), Nc);
                for i = 1:copy_len
                    dU_safe(i) = dU_tmp(i);
                end
            end
            
            dU    = dU_safe;
            J_opt = fval_tmp;
        end
    end

    %---------------------------------
    % 9) 최종 조향 명령 계산
    %---------------------------------
    delta_raw = delta_prev + dU(1);
    delta_cmd = min(max(delta_raw, delta_min), delta_max_abs);
end

%====================================================================
% 로컬 함수
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