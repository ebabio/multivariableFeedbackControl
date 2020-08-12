%% Setup Workspace

close all
clc

% Add Library
lib_path = fullfile(fileparts(mfilename('fullpath')), '..', '0_lib');
remote_feval(lib_path, 'init_libs');

%% Define Plant

% 1. Define the siso open loop model and define the disturbance point
% subparts
g1 = zpk_time([], [0.05 0.05], 2);
g2 = zpk_time([], 10, 100);
d = AnalysisPoint('d');

G = g2 * d * g1;

%% Define Controller

% K0: Inverse-based Controller:
% give bandwidth, a integrator for the step and invert plant
wc = 10;
K = wc * tf(1, [1 0]) / g2 * zpk_time(0.1, 0.01, 1/2); %g1 is inverted perfectly thanks to the integrator, g2 is approxed this way

% K2: A simple controller with integral action to reject the disturbance
K = 0.5 * tf([1, 2], [1, 0]);

% K3: The simple controller with derivative action
K = 0.5 * tf([1, 2], [1, 0]) * zpk_time(0.05, 0.005);

Kr = 1; % a unity pre-filter controller

% 2DOF Controller
% K is taken from K3
Kr = zpk_time(0.5, [0.65, 0.03]);

%% Construct generalized system

% Define Open Loop System
L = G * K;

% Get sensitivities
y = AnalysisPoint('y'); 
T = feedback(y*L,1);
S = getSensitivity(T, 'y');

% Add a 2DOF controller
Tr = T * Kr;

% Get TF from disturbance d to output y
Td = getIOTransfer(T, 'd', 'y');

% These are different ways of getting the same realization of Td
minzpk = @(sys) zpk(minreal(sys, 1e-3));

minzpk(Td);
minzpk(g2 / (1 + g2 * g1 * K));
minzpk(S * g2);

%% Analyze

% Step Response Plots
tfinal = 3;
figure(1)

% Input Output response
subplot(2,1,1)
step(Tr, tfinal)

% Disturbance Rejection response
subplot(2,1,2)
step(Td, tfinal)