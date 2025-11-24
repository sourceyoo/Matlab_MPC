% --- init_vehicle_params.m ---

% 1) 차량 파라미터 (ROS 기준과 일치시키기)
rosParams = struct('wheel_base',     1.03, ...   % [m]
                   'wheel_tread',    1.03, ...
                   'front_overhang', 0.21, ...
                   'rear_overhang',  0.19, ...
                   'vehicle_mass',   250);

tireParams = struct('width',        0.175, ...
                    'aspect_ratio', 0.60, ...
                    'rim_diameter', 13);

assumptions = struct('cg_distribution_ratio',    0.5, ...
                     'belt_compression_modulus',27e6, ...
                     'belt_thickness',          0.015, ...
                     'sidewall_deflection',     0.15, ...
                     'reference_vertical_load', 3000);

% 2) vehicleParams (필요하면 사용)
vehicleParams = vehi_param(rosParams, tireParams, assumptions);

% 3) 차량/조향 관련 파라미터만 정의 (MPC 파라미터 X)
L         = rosParams.wheel_base;  % 휠베이스 [m]
delta_max = deg2rad(27);           % 최대 조향 각 [rad]

% 4) 초기 상태 / 가감속 제약 (vehicle 쪽이라 여기 둬도 됨)
a_max = 2.0;   % 최대 가감속 [m/s^2]
v0    = 3.0;   % 초기 속도 [m/s]
x0    = 0;
y0    = 0;
psi0  = 0;

Ts = 0.05;


Qy = 1;
Qpsi = 1;
Rdelta = 1;
Np = 10;
Nc = 3;
dmax_deg = 27.0;


% 이 스크립트를 실행하면 base workspace에
% rosParams, tireParams, assumptions, vehicleParams,
% L, delta_max, a_max, v0, x0, y0, psi0
% 가 생기고, Simulink와 MPC 코드에서 참조 가능
