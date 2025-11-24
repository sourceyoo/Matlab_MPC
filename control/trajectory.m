%% ==============================================================
% cone_trajectory_visualize_and_export.m
%  - ROS2 Humble rosbag2에서
%    /planning/scenario_planning/trajectory 읽기
%  - Trajectory 생성 과정(메시지별) 애니메이션
%  - Simulink From Workspace용 timeseries 변수 생성(trajXY, trajYaw, trajV)
% ==============================================================

%% 0) 사용자 설정 -----------------------------
bagDir    = "/home/yoo/autoware_carla/autoware/trajectory_1";  % <- metadata.yaml이 있는 rosbag2 폴더
topicName = "/planning/scenario_planning/trajectory";
playback_speed = 0.5;     % 애니메이션 재생 속도(1.0=실제 간격, 0.5=절반 속도)
default_dt = 0.05;        % time_from_start 없을 때 샘플 간격(초)
choose_policy = "longest";% Simulink용 하나 선택: "latest" or "longest"

%% 1) rosbag2 열기 & 토픽 확인 ----------------
bag = ros2bagreader(bagDir);
disp("=== AvailableTopics ===");
disp(bag.AvailableTopics);

sel = select(bag,"Topic",topicName);
if height(sel.MessageList)==0
    error("토픽 %s 에 메시지가 없습니다.", topicName);
end
msgs = readMessages(sel);                         % cell array (struct)
numMsgs = numel(msgs);
fprintf("[INFO] Trajectory 메시지 수: %d\n", numMsgs);

% 메시지 타임스탬프(상대, 초)
tMsg = sel.MessageList.Time - sel.StartTime;  % duration
tMsg = seconds(tMsg);                         % → double(초)
tMsg = tMsg(:);

%% 2) Trajectory 파싱 -------------------------
% 출력 컨테이너
Traj = struct('t_msg',[],'x',[],'y',[],'yaw',[],'v',[],'t_seg',[]);
Traj(:) = [];  % 빈 초기화

for i = 1:numMsgs
    m = msgs{i};
    if ~isfield(m,'points') || isempty(m.points)
        continue
    end
    P = m.points;
    N = numel(P);

    x = zeros(N,1); y = zeros(N,1); yaw = zeros(N,1); v = zeros(N,1);
    tfs = zeros(N,1); % time_from_start

    for k = 1:N
        % 위치
        x(k) = P(k).pose.position.x;
        y(k) = P(k).pose.position.y;

        % yaw (Z-축 회전, quaternion -> yaw)
        q = P(k).pose.orientation;
        yaw(k) = atan2( 2*(q.w*q.z + q.x*q.y), 1 - 2*(q.y^2 + q.z^2) );

        % 속도(있으면)
        if isfield(P(k),'longitudinal_velocity_mps')
            v(k) = P(k).longitudinal_velocity_mps;
        end

        % time_from_start(있으면)
        if isfield(P(k),'time_from_start') && ~isempty(P(k).time_from_start)
            sec  = double(P(k).time_from_start.sec);
            nsec = double(P(k).time_from_start.nanosec);
            tfs(k) = sec + nsec*1e-9;
        end
    end

    % 시간 벡터 보정
    if all(tfs==0) || any(~isfinite(tfs))
        tfs = (0:N-1)' * default_dt;  % 균일 샘플
    else
        tfs = tfs - tfs(1);           % 0부터 시작
    end

    Traj(end+1).t_msg = tMsg(i); %#ok<SAGROW>
    Traj(end).x = x; Traj(end).y = y; Traj(end).yaw = yaw;
    Traj(end).v = v; Traj(end).t_seg = tfs;
end

% 유효 메시지만 남김
Traj = Traj(~arrayfun(@(t) isempty(t.x), Traj));
if isempty(Traj)
    error("유효한 trajectory 메시지가 없습니다.");
end
fprintf("[INFO] 유효 Trajectory 메시지: %d\n", numel(Traj));

% === 애니메이션 (트레일: 선으로 누적) ===
figure('Color','w');
ax = gca; hold(ax,'on'); grid(ax,'on'); axis(ax,'equal');
xlabel('X [m]'); ylabel('Y [m]'); title('Trajectory generation over time (with path trails)');

allXY = cell2mat(arrayfun(@(t) [t.x t.y], Traj(:), 'UniformOutput', false));
if ~isempty(allXY)
    pad = 2; xlim([min(allXY(:,1))-pad, max(allXY(:,1))+pad]);
             ylim([min(allXY(:,2))-pad, max(allXY(:,2))+pad]);
end

% 이미 그려진 과거 경로(회색)들을 담아둘 핸들 배열
trailHandles = gobjects(0);
% 현재 경로(파란 굵은 선)
hCurrPath = plot(ax, NaN, NaN, 'b-', 'LineWidth', 2);

txt = annotation('textbox',[0.15 0.82 0.3 0.1],'String','', ...
                 'FitBoxToText','on','EdgeColor','none');

for i = 1:numel(Traj)
    % 1) 직전 경로는 회색 얇은 선으로 "고정"해 두기
    if i > 1
        h = plot(ax, Traj(i-1).x, Traj(i-1).y, '-', ...
                 'Color', [0.75 0.75 0.75], 'LineWidth', 1);
        trailHandles(end+1) = h; %#ok<AGROW>
    end

    % 2) 현재 메시지 경로를 갱신
    set(hCurrPath, 'XData', Traj(i).x, 'YData', Traj(i).y);

    % 3) 정보 텍스트 (duration→double 변환)
    t_val = Traj(i).t_msg; if ~isnumeric(t_val), t_val = seconds(t_val); end
    txt.String = sprintf('msg %d/%d  (t=%.2fs, N=%d)', ...
                         i, numel(Traj), t_val, numel(Traj(i).x));

    drawnow;

    % 4) 재생 속도 반영
    if i < numel(Traj)
        dt = Traj(i+1).t_msg - Traj(i).t_msg; 
        if ~isnumeric(dt), dt = seconds(dt); end
        pause(playback_speed * max(0, dt));
    end
end


% 전체 범위 한번에 산정(보기 좋게 여백 추가)
allXY = cell2mat(arrayfun(@(t) [t.x t.y], Traj(:), 'UniformOutput', false));
if ~isempty(allXY)
    pad = 2;
    xlim([min(allXY(:,1))-pad, max(allXY(:,1))+pad]);
    ylim([min(allXY(:,2))-pad, max(allXY(:,2))+pad]);
end

plt = plot(ax, NaN, NaN, 'b-', 'LineWidth', 2);
txt = annotation('textbox',[0.15 0.82 0.3 0.1],'String','', ...
                 'FitBoxToText','on','EdgeColor','none');

for i = 1:numel(Traj)
    set(plt, 'XData', Traj(i).x, 'YData', Traj(i).y);

    % (A) 텍스트 표시: t 값을 double로
    t_val = Traj(i).t_msg;                  % 혹시 모를 duration 대비
    if ~isnumeric(t_val)
        t_val = seconds(t_val);
    end
    txt.String = sprintf('msg %d/%d  (t=%.2fs, N=%d)', ...
                         i, numel(Traj), t_val, numel(Traj(i).x));

    drawnow;

    % (B) 다음 메시지까지 대기: dt도 double로
    if i < numel(Traj)
        dt = Traj(i+1).t_msg - Traj(i).t_msg;
        if ~isnumeric(dt)
            dt = seconds(dt);
        end
        dt = max(0, dt);
        pause(playback_speed * dt);
    end
end


%% 4) Simulink From Workspace용 변수 만들기 --------
switch lower(choose_policy)
    case "latest"
        idx = numel(Traj); % 가장 최신
    case "longest"
        [~, idx] = max(arrayfun(@(t) numel(t.x), Traj)); % 포인트 가장 많은 것
    otherwise
        idx = numel(Traj);
end

% timeseries (권장)
trajXY  = timeseries([Traj(idx).x Traj(idx).y], Traj(idx).t_seg);
trajYaw = timeseries(Traj(idx).yaw, Traj(idx).t_seg);
trajV   = timeseries(Traj(idx).v,   Traj(idx).t_seg);

% struct 포맷(원하면 From Workspace에서 사용 가능)
traj_struct.time                 = Traj(idx).t_seg;
traj_struct.signals.values       = [Traj(idx).x Traj(idx).y];
traj_struct.signals.dimensions   = 2;

fprintf("[INFO] Simulink용 변수 준비 완료: trajXY, trajYaw, trajV, traj_struct\n");

% (옵션) .mat로 저장해 두면 다른 세션에서도 바로 사용 가능
% save("traj_export.mat","trajXY","trajYaw","trajV","traj_struct");
