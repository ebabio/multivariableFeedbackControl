%% Setup Workspace

close all
clc

% Add Library
lib_path = fullfile(fileparts(mfilename('fullpath')), '..', '0_lib');
remote_feval(lib_path, 'init_libs');

%% Define system

% System parameters
z = 0.1;
tau = 1;

% Open Loop behavior
L = tf([-1, z], [tau, tau*z+ 2, 0]);

%% Analyze System

[Gm, Pm, Wcg, Wcp] = margin(L)

% Complementary Sensitivity Function
y = AnalysisPoint('y'); % for use in sensitivity function
T = feedback(y*L,1);

% Sensitivity function
S = getSensitivity(T, 'y');

% Bode plot
f2 = figure(1);
bodeplot(L,T,S)
bode_legend(f2, 'Open Loop', 'Closed Loop', 'Sensitivity')

% Step response
figure(2)
step(T)

% Comments:
% The different possible bandwidths definitions are greatly affected by the
% RHP zero. T is almost unitary but S is not, the sytem response to a step
% gives a bandwidth idea that is more similar to omega_s than omega_t

%% Continue on 2.6.2