function [Ad, Bd] = kinematic_lin_disc(X, Y, psi, v, delta, L, Ts)
% 풀 kinematic bicycle 모델을 현재 상태 근방에서 선형화한
% 이산시간 행렬 Ad, Bd를 계산한다.
%
% 상태: x = [X; Y; psi; v]
% 입력: u = delta (조향각 하나만 제어)

    % --- 연속시간 A 행렬 ---
    A = [ 0, 0, -v*sin(psi),  cos(psi);
          0, 0,  v*cos(psi),  sin(psi);
          0, 0,  0,           (1/L)*tan(delta);
          0, 0,  0,           0 ];

    % --- 연속시간 B (delta에 대한 열만) ---
    B = [ 0;
          0;
          (v/L)*sec(delta)^2;
          0 ];

    % --- 이산화 (Forward Euler) ---
    Ad = eye(4) + Ts*A;
    Bd = Ts * B;
end
