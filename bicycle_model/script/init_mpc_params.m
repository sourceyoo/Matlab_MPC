function init_mpc_params()
    % 저장해둔 결과 불러오기
    data = load('best_mpc_params.mat','bestPoint');
    bp = data.bestPoint;

    % base workspace 변수로 뿌려주기
    assignin('base','Qy',       bp.Qy);
    assignin('base','Qpsi',     bp.Qpsi);
    assignin('base','Rdelta',   bp.Rdelta);

    % 3) MPC 구조/하드웨어에 맞게 고정하는 값들
    Np_fixed       = 30;   % prediction horizon
    Nc_fixed       = 5;    % control horizon
    dmax_deg_fixed = 7;   % 최대 조향각 [deg]

    assignin('base','Np',       Np_fixed);
    assignin('base','Nc',       Nc_fixed);
    assignin('base','dmax_deg', dmax_deg_fixed);
end
