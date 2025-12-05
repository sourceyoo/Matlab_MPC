% --- init_vehicle_params.m ---

%% Vehicle & Tire Parameters (car_sim URDF 기반)

% ─────────────────────────────────────────────
% 1) ROS / Vehicle Geometry Parameters
%   - wheel_base      : 축간거리 [m]
%   - wheel_tread     : 트레드(좌우 바퀴 중심 간 거리) [m]
%   - front_overhang  : 앞 오버행 (앞바퀴 축 ~ 차 앞끝) [m]
%   - rear_overhang   : 뒤 오버행 (뒷바퀴 축 ~ 차 뒤끝) [m]
%   - vehicle_mass    : 차량 총 질량 [kg]
% ─────────────────────────────────────────────
rosParams = struct( ...
    'wheel_base',     2.652, ...   % [m] 2 * half_wheelbase (1.326)
    'wheel_tread',    1.60,  ...   % [m] rear track 기준 (2 * 0.8)
    'front_overhang', 0.40,  ...   % [m] (총 길이 3.452 - wheelbase 2.652)/2
    'rear_overhang',  0.40,  ...   % [m]
    'vehicle_mass',   1820   ...   % [kg] body(1620) + wheels(160) + steer links(40)
);

% ─────────────────────────────────────────────
% 2) Tire Parameters (URDF + 합리적 가정)
%   - width        : 타이어 단면 폭 [m]
%   - aspect_ratio : 편평비 (모델용 가정치)
%   - rim_diameter : 림 직경 [inch] (모델용 가정치)
% ─────────────────────────────────────────────
tireParams = struct( ...
    'width',        0.25, ...  % [m] wheel_thickness = 0.25
    'aspect_ratio', 0.60, ...  % 60 시리즈 타이어 가정
    'rim_diameter', 16   ...   % [inch] 16인치 림 가정
);

% ─────────────────────────────────────────────
% 3) Modeling Assumptions
%   - cg_distribution_ratio   : 전/후륜 하중 분배 (예: 0.5 → 50:50)
%   - belt_compression_modulus: 벨트 압축 탄성계수 [Pa]
%   - belt_thickness          : 벨트 두께 [m]
%   - sidewall_deflection     : 기준 하중에서의 사이드월 변형량 [m]
%   - reference_vertical_load : 기준 수직하중 [N]
%                               (여기서는 1820kg 차량의 1/4 하중 ≈ 4500N로 가정)
% ─────────────────────────────────────────────
assumptions = struct( ...
    'cg_distribution_ratio',    0.5,   ...  % 50:50 가정
    'belt_compression_modulus', 27e6,  ...  % [Pa]
    'belt_thickness',           0.015, ...  % [m]
    'sidewall_deflection',      0.15,  ...  % [m]
    'reference_vertical_load',  4500   ...  % [N] ≈ 1820*9.81/4
);


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
Np = 1;
Nc = 1;
dmax_deg = 2.0;


% 이 스크립트를 실행하면 base workspace에
% rosParams, tireParams, assumptions, vehicleParams,
% L, delta_max, a_max, v0, x0, y0, psi0
% 가 생기고, Simulink와 MPC 코드에서 참조 가능
