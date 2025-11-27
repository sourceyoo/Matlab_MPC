% vehi_param.m  (함수 버전, car_sim 파라미터 기준)
function vehicleParams = vehi_param(rosParams, tireParams, assumptions)
    % 차량/타이어 파라미터 → vehicleParams 구조체 생성
    %  - rosParams, tireParams, assumptions를 인자로 안 주면
    %    init_vehicle_params.m에 맞춘 기본값을 사용

    % ==== 0) 기본값 설정 (인자 미전달 시) ==========================
    if nargin < 1
        % init_vehicle_params.m 의 rosParams와 동일하게 설정
        rosParams = struct( ...
            'wheel_base',     2.652, ...  % [m] 2 * half_wheelbase (1.326)
            'wheel_tread',    1.60,  ...  % [m] rear track 기준 (2 * 0.8)
            'front_overhang', 0.40,  ...  % [m]
            'rear_overhang',  0.40,  ...  % [m]
            'vehicle_mass',   1820   ...  % [kg] body+wheel+link 합
        );
    end

    if nargin < 2
        % init_vehicle_params.m 의 tireParams와 동일하게 설정
        tireParams = struct( ...
            'width',        0.25, ...  % [m] wheel_thickness = 0.25
            'aspect_ratio', 0.60, ...  % 60 시리즈 타이어 가정
            'rim_diameter', 16   ...   % [inch] 16인치 림 가정
        );
    end

    if nargin < 3
        % init_vehicle_params.m 의 assumptions와 동일하게 설정
        assumptions = struct( ...
            'cg_distribution_ratio',    0.5,   ...  % 50:50 하중 분배
            'belt_compression_modulus', 27e6,  ...  % [Pa]
            'belt_thickness',           0.015, ...  % [m]
            'sidewall_deflection',      0.15,  ...  % [m]
            'reference_vertical_load',  4500   ...  % [N] ≈ 1820*9.81/4
        );
    end

    % ==== 1) 차량 질량/질량중심/관성 계산 ===========================
    g = 9.81;

    vehicleParams = struct;
    vehicleParams.m = rosParams.vehicle_mass;

    % 앞/뒤 질량 중심 위치 (a, b)
    vehicleParams.a = rosParams.wheel_base * assumptions.cg_distribution_ratio;
    vehicleParams.b = rosParams.wheel_base * (1 - assumptions.cg_distribution_ratio);

    % 차량 길이/폭에 따른 요 관성 모멘트
    vehicle_length = rosParams.wheel_base + rosParams.front_overhang + rosParams.rear_overhang;
    vehicle_width  = rosParams.wheel_tread;
    vehicleParams.Izz = (1/12) * vehicleParams.m * (vehicle_length^2 + vehicle_width^2);

    % ==== 2) 타이어 측강성 계산 (기존 스크립트 로직 유지) ============
    w       = tireParams.width;
    a_ratio = tireParams.aspect_ratio;
    r       = (tireParams.rim_diameter / 2) * 0.0254;  % [m] 림 반지름
    s       = assumptions.sidewall_deflection;
    E       = assumptions.belt_compression_modulus;
    b_thick = assumptions.belt_thickness;

    % 컨택 패치 길이 L (타이어 변형 기반)
    L = 2 * (r + w * a_ratio) * sin(acos(1 - (s * w * a_ratio) / (r + w * a_ratio)));
    x_trail = L / 6;

    C_alpha_base = (4 * E * b_thick * w^3) / ...
                   (3 * x_trail * (2 * pi * (r + w * a_ratio) - L));

    Fz_per_tire   = (vehicleParams.m * g) / 4;
    C_alpha_final = C_alpha_base * (Fz_per_tire / assumptions.reference_vertical_load);

    vehicleParams.Cy_f = C_alpha_final;
    vehicleParams.Cy_r = C_alpha_final;
end
