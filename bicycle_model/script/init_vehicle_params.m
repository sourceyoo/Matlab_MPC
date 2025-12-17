% --- init_vehicle_params.m ---
%% Vehicle & Tire Parameters (Rear Axle Reference)
% ─────────────────────────────────────────────
% 1) ROS / Vehicle Geometry Parameters
% ─────────────────────────────────────────────
rosParams = struct( ...
    'wheel_base',     2.652, ...   % [m] 축간거리 (L)
    'wheel_tread',    1.60,  ...   % [m] 윤거
    'front_overhang', 0.40,  ...   % [m]
    'rear_overhang',  0.40,  ...   % [m]
    'vehicle_mass',   1820   ...   % [kg] 차량 총 질량
);

% ─────────────────────────────────────────────
% 2) Tire Parameters
% ─────────────────────────────────────────────
tireParams = struct( ...
    'width',        0.25, ...  % [m]
    'aspect_ratio', 0.60, ...  % 60 시리즈
    'rim_diameter', 16   ...   % [inch]
);

% ─────────────────────────────────────────────
% 3) Modeling Assumptions
% ─────────────────────────────────────────────
assumptions = struct( ...
    'cg_distribution_ratio',    0.5,   ...  % (참고용) Izz 계산 등에 사용
    'belt_compression_modulus', 27e6,  ...  % [Pa]
    'belt_thickness',           0.015, ...  % [m]
    'sidewall_deflection',      0.15,  ...  % [m]
    'reference_vertical_load',  4500   ...  % [N]
);

% ─────────────────────────────────────────────
% 4) Vehicle Parameters Calculation
%    - vehi_param.m 내부에서 기준점을 뒷바퀴 중심으로 변환함
%    - vehicleParams.a = L (Wheelbase)
%    - vehicleParams.b = 0
% ─────────────────────────────────────────────
vehicleParams = vehi_param(rosParams, tireParams, assumptions);

% ─────────────────────────────────────────────
% 5) Simulation / Initial State
% ─────────────────────────────────────────────
L         = rosParams.wheel_base;  % 휠베이스 [m]
delta_max = deg2rad(30);           % [수정] 최대 조향각 (물리적 한계 30도까지 해제)
a_max     = 2.0;                   % 최대 가감속 [m/s^2]

% 초기 상태 (Simulink Integrator 초기값용)
v0    = 3.0;   % 초기 속도 [m/s]
x0    = 0;     % 초기 X [m] (뒷바퀴 중심 기준)
y0    = 0;     % 초기 Y [m] (뒷바퀴 중심 기준)
psi0  = 0;     % 초기 헤딩 [rad]

% ─────────────────────────────────────────────
% 6) Default MPC Parameters (최적화 결과 반영)
%    - 베이지안 최적화를 안 돌리고 그냥 Simulink만 실행할 때 사용될 기본값
% ─────────────────────────────────────────────
Ts = 0.05;   % [s] 샘플링 타임

% [최적화 결과 기반 추천값]
% Qy가 크고 Rdelta가 작아야 경로에 잘 붙음
Qy     = 1;    
Qpsi   = 1;      
Rdelta = 1;    

% [반응성 설정]
Np = 30;          % Horizon (단기 반응성 강화)
Nc = 5;          % Control Horizon
dmax_deg = 7.0;  % [deg/step] 조향 변화율 제한 해제 (빠른 핸들링)

% ─────────────────────────────────────────────
% workspace 확인용 메시지
fprintf('Initialized Vehicle Params (Rear Axle Reference).\n');
fprintf('  - L (Wheelbase): %.3f m\n', L);
fprintf('  - Mass: %.1f kg\n', vehicleParams.m);
fprintf('  - MPC Default: Np=%d, dmax=%.1f deg\n', Np, dmax_deg);