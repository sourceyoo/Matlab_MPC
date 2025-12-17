%% 디버깅용: 최적화 없이 1회 강제 실행
clc; clear; close all;

% 1. 초기 파라미터 임의 설정 (로그 스케일 아님, 실제 값)
% 예: Qy=200, Qpsi=10, Rdelta=100
test_params = table(200, 10, 100, 'VariableNames', {'Qy', 'Qpsi', 'Rdelta'});

fprintf('>>> 디버깅 시뮬레이션 시작...\n');

try
    % q(DataQueue)는 디버깅 땐 없으므로 [] 처리
    % mpc_rsme_fun 함수 내부의 try-catch를 주석 처리하거나, 
    % 에러 발생 시 rethrow(ME)를 하도록 수정하고 돌려야 확실합니다.
    
    [J, metrics] = mpc_rsme_fun(test_params, []);
    
    fprintf('>>> 성공!\n');
    fprintf('Cost: %.4f\n', J);
    disp(metrics);
    
catch ME
    fprintf('\n!!! 시뮬레이션 치명적 오류 !!!\n');
    fprintf('이 에러 메시지를 확인해야 합니다:\n');
    fprintf('------------------------------------------------\n');
    disp(ME.message); % 가장 중요한 에러 메시지
    fprintf('------------------------------------------------\n');
    
    % 스택 추적 (어디서 터졌는지)
    for i = 1:length(ME.stack)
        fprintf('File: %s, Line: %d, Name: %s\n', ...
            ME.stack(i).file, ME.stack(i).line, ME.stack(i).name);
    end
end