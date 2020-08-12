%% Setup Workspace

a_open_loop_stability
close all
clc

% Add Library
lib_path = fullfile(fileparts(mfilename('fullpath')), '..', '0_lib');
remote_feval(lib_path, 'init_libs');

%% Define a Control

% Add a controller in standard form
K = pidstd(1.5); % only proportional
K = pidstd(1.14, 12.7); % a PI

% Direct Loop TF, 
L = series(K, G);
L = G*K; % equivalent, just for reference

%% Analyze

% Feedback loop TF, i.e. Complementary Sensitivity Function
y = AnalysisPoint('y'); % for use in sensitivity function
T = feedback(y*L,1);

% Error dynamics, i.e. Sensitivity function
S = getSensitivity(T, 'y');

% Get poles and zeros
[z_p, p_p] = zpkdata_siso(T)

% Steady State error
ss_error = dcgain(S)

% Plot step
t_final = 100;
figure(1)
step(T, t_final)

% Get Gain and Phase Margins
% computed for the OL system
[Gm, Pm, Wcg, Wcp] = margin(L)

% Bode plot
f2 = figure(2);
bodeplot(L,T,S,custom_bodeoptions())
bode_legend(f2, 'Open Loop', 'Closed Loop', 'Sensitivity')

% Relationship of the Complementary Sensitivity and Sensitivity with
% M-circles and Nicholds Grids. These show gain peaks in the close loop
% system, i.e. M_T
figure(3)
nyquist(L)
grid on
axis([-1.6 0 -2 2]);

figure(4)
nichols(L)
grid on



