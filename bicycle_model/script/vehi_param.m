% vehi_param.m  (함수 버전)
function vehicleParams = vehi_param(rosParams, tireParams, assumptions)
    % 기본값 (인자 미전달 시)
    if nargin < 1
        rosParams = struct( ...
            'wheel_base',     1.03, ...
            'wheel_tread',    1.03, ...
            'front_overhang', 0.21, ...
            'rear_overhang',  0.19, ...
            'vehicle_mass',   250 );
    end
    if nargin < 2
        tireParams = struct( ...
            'width',        0.175, ...
            'aspect_ratio', 0.60, ...
            'rim_diameter', 13 );
    end
    if nargin < 3
        assumptions = struct( ...
            'cg_distribution_ratio',    0.5, ...
            'belt_compression_modulus', 27e6, ...
            'belt_thickness',           0.015, ...
            'sidewall_deflection',      0.15, ...
            'reference_vertical_load',  3000 );
    end

    % ==== 아래는 기존 스크립트 본문과 동일 ====
    g = 9.81;

    vehicleParams = struct;
    vehicleParams.m = rosParams.vehicle_mass;

    vehicleParams.a = rosParams.wheel_base * assumptions.cg_distribution_ratio;
    vehicleParams.b = rosParams.wheel_base * (1 - assumptions.cg_distribution_ratio);

    vehicle_length = rosParams.wheel_base + rosParams.front_overhang + rosParams.rear_overhang;
    vehicle_width  = rosParams.wheel_tread;
    vehicleParams.Izz = (1/12) * vehicleParams.m * (vehicle_length^2 + vehicle_width^2);

    w = tireParams.width;
    a_ratio = tireParams.aspect_ratio;
    r = (tireParams.rim_diameter / 2) * 0.0254;
    s = assumptions.sidewall_deflection;
    E = assumptions.belt_compression_modulus;
    b_thick = assumptions.belt_thickness;

    L = 2 * (r + w * a_ratio) * sin(acos(1 - (s * w * a_ratio) / (r + w * a_ratio)));
    x_trail = L / 6;
    C_alpha_base = (4 * E * b_thick * w^3) / (3 * x_trail * (2 * pi * (r + w * a_ratio) - L));
    Fz_per_tire = (vehicleParams.m * g) / 4;
    C_alpha_final = C_alpha_base * (Fz_per_tire / assumptions.reference_vertical_load);

    vehicleParams.Cy_f = C_alpha_final;
    vehicleParams.Cy_r = C_alpha_final;
end
