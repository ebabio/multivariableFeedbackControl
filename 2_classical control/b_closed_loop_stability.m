%% Setup Workspace

a_open_loop_stability
close all
clc

%% Define a Control

% Add a controller in standard form
K = pidstd(1.5); % only proportional
K = pidstd(1.14, 12.7); % a PI

% Direct Loop TF, 
L = series(K, G);
L = G*K; % equivalent, just for reference

% Feedback loop TF, i.e. Complementary Sensitivity Function
y = AnalysisPoint('y'); % for use in sensitivity function
T = feedback(y*L,1);

% Error dynamics, i.e. Sensitivity function
S = getSensitivity(T, 'y');

%% Analyze

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

%% Continue on 2.4.3



