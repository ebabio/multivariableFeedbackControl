%% Setup Workspace

close all
clc

%% Define System

% 1. Define the siso open loop model and define the disturbance point
% subparts
g1 = zpk_time([], 10, 200);
g2 = zpk_time([], [0.05 0.05], 1);
d = AnalysisPoint('d');

G = g2 * d * g1;

%% Define Controller

% Inverse-based Controller:
% give bandwidth, a integrator for the step and invert plant
wc = 10;
K = wc * tf(1, 0) / g1 * zpk_time(0.1, 0.01); %g1 is inverted perfectly thanks to the integrator, g2 is approxed this way

%% Define generalized system
% take disturbance as an extra input
S = getSensitivity(T, 'y');


%% Analyze

% Get sensitivities
y = AnalysisPoint('y'); 
T = feedback(y*L,1);
S = getSensitivity(T, 'y');


%% Analyze Controller

% Feedback loop TF, i.e. Complementary Sensitivity Function
y = AnalysisPoint('y'); % for use in sensitivity function
T = feedback(y*L,1);

% Error dynamics, i.e. Sensitivity function
S = getSensitivity(T, 'y');

% Plot step response
step(T)