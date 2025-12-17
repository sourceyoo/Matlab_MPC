function vehicleParams = vehi_param(rosParams, tireParams, assumptions)
    % ==== 0) 기본값 설정 (기존과 동일) ==========================
    if nargin < 1
        rosParams = struct( ...
            'wheel_base',     2.652, ...
            'wheel_tread',    1.60,  ...
            'front_overhang', 0.40,  ...
            'rear_overhang',  0.40,  ...
            'vehicle_mass',   1820   ...
        );
    end
    if nargin < 2
        tireParams = struct('width', 0.25, 'aspect_ratio', 0.60, 'rim_diameter', 16);
    end
    if nargin < 3
        assumptions = struct( ...
            'cg_distribution_ratio',    0.5, ... 
            'belt_compression_modulus', 27e6, 'belt_thickness', 0.015, ...
            'sidewall_deflection', 0.15, 'reference_vertical_load', 4500);
    end

    % ==== 1) [핵심 수정] 기준점을 뒷바퀴 중심(Rear Axle)으로 변경 =======
    g = 9.81;
    vehicleParams = struct;
    vehicleParams.m = rosParams.vehicle_mass;

    % [변경 전] 무게중심(CG) 기준
    % vehicleParams.a = rosParams.wheel_base * assumptions.cg_distribution_ratio;
    % vehicleParams.b = rosParams.wheel_base * (1 - assumptions.cg_distribution_ratio);

    % [변경 후] 뒷바퀴 축 중심(Rear Axle) 기준
    % a (lf): 기준점(뒷바퀴)에서 앞바퀴까지의 거리 = 휠베이스 전체
    vehicleParams.a = rosParams.wheel_base; 
    
    % b (lr): 기준점(뒷바퀴)에서 뒷바퀴까지의 거리 = 0
    vehicleParams.b = 0; 

    % -----------------------------------------------------------
    % 참고: Izz (관성모멘트) 계산
    % 기준점이 바뀌었지만, 물리적인 회전 저항(관성) 자체는 차체 고유의 성질입니다.
    % 다만, 동역학 시뮬레이션에서 이 Izz를 쓸 때는 "뒷바퀴 축 기준 회전 관성"이 필요한지
    % "무게중심 기준 관성"이 필요한지 모델 수식에 따라 다릅니다.
    % 
    % Kinematic MPC를 쓰신다면 Izz는 거의 쓰이지 않으므로 
    % 아래 식(무게중심 기준 근사치)을 그대로 둬도 무방합니다.
    % -----------------------------------------------------------
    vehicle_length = rosParams.wheel_base + rosParams.front_overhang + rosParams.rear_overhang;
    vehicle_width  = rosParams.wheel_tread;
    vehicleParams.Izz = (1/12) * vehicleParams.m * (vehicle_length^2 + vehicle_width^2);

    % ==== 2) 타이어 측강성 계산 (기존 로직 유지) ============
    % Kinematic 모델에서는 측강성(Cy)을 사용하지 않으므로, 이 부분은 계산만 해두고 실제로는 안 쓰일 것입니다.
    w       = tireParams.width;
    a_ratio = tireParams.aspect_ratio;
    r       = (tireParams.rim_diameter / 2) * 0.0254;
    s       = assumptions.sidewall_deflection;
    E       = assumptions.belt_compression_modulus;
    b_thick = assumptions.belt_thickness;

    L_patch = 2 * (r + w * a_ratio) * sin(acos(1 - (s * w * a_ratio) / (r + w * a_ratio)));
    x_trail = L_patch / 6;
    C_alpha_base = (4 * E * b_thick * w^3) / (3 * x_trail * (2 * pi * (r + w * a_ratio) - L_patch));
    Fz_per_tire   = (vehicleParams.m * g) / 4;
    C_alpha_final = C_alpha_base * (Fz_per_tire / assumptions.reference_vertical_load);
    vehicleParams.Cy_f = C_alpha_final;
    vehicleParams.Cy_r = C_alpha_final;
end