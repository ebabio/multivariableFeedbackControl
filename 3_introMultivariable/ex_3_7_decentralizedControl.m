%% Ex 3.7: A decentralized control

% This exercise 3.7 following the paper book, not the computer pdf which is
% different for this case.

%% Setup Workspace

clear
close all
clc

% Add Library
lib_path = fullfile(fileparts(mfilename('fullpath')), '..', '0_lib');
remote_feval(lib_path, 'init_libs');

%% System definition

% tunable parameter
theta = 5; % use theta 5 for long delay, theta 1 for short delay

% transfer function
s = tf('s');
G = 0.01 * exp(-theta*s) / (s + 1.72e-4) / (4.32 * s + 1) * ...
    [-34.54 * (s + 0.0572),     1.913;
     -30.22 * s,                -9.188 * (s + 6.95e-4)];

%% Relative Gain Matrix

% omega range
omega_limits = [1e-5, 1e+2];
omega_range = logspace(log10(omega_limits(1)), log10(omega_limits(2)), 100);

% Get bode over frequencies
figure(1)
h1 = bodeplot(G, custom_bodeoptions, omega_range);
% correct for negative DC gains
p = getoptions(h1);
p.PhaseMatching = 'on';
p.PhaseMatchingFreq = omega_range(1);
p.PhaseMatchingValue = -180;
setoptions(h1,p);

% Get rga matrix over the frequency range
rga_matrix = over_freq(G, omega_range, @rga);
figure(2)
plot(reshape(rga_matrix, [], numel(rga_matrix(1,1,:))), omega_range)

% Get rga number over the frequency range
[~, pairing] = rga_inf(dcgain(G));
rga_number_default = @(G) (rga_number(G, pairing));
[r, rga_number_bode] = over_freq(G, omega_range, rga_number_default);
figure(3)
bodeplot(rga_number_bode, omega_range)

%% Controller Definition

% controller simplification, based on SIMC rules, and the half rule
g_tuning(1,1) = exp((-theta) * s) * (-34.54 * 1e-2) / ((1+2.16)* s); % correcting the value in the book
g_tuning(1,2) = exp((-theta - 2.16) * s) * (1.913  * 1e-2) / s; % half the second pole added to delay
g_tuning(2,1) = exp(-theta*s) * (-30.22 * 1e-2) / (4.32 * s + 1);
g_tuning(2,2) = exp(-theta*s) * (-9.188 * 1e-2) / (4.32 * s + 1);

% bandwidth definition based on time
tc1 = 3*theta; % improves robustness of the controller to decrease bandwidth here, base don the book
tc2 = theta;

%Diagonal pairing
k11 = 1/(-34.54 * 1e-2) * ((1+2.16) / (tc1+theta)) * (1 + 1 / (4 * (tc1+theta)* s));
k22 = 1/(-9.188 * 1e-2) * (4.32 / (tc2+theta)) * (1 + 1/(4.32*s));

K = [k11, 0 ; 0, k22];

%Off-diagonal pairing: output 1 to input 2
k21 = 1/(1.913  * 1e-2) * (1 / (tc1 + theta + 2.16)) * (1 + 1 / (4 * (tc1 + theta + 2.16)* s));
k12 = 1/(-30.22 * 1e-2) * (4.32 / (tc2+theta)) * (1 + 1/(4.32*s));

K = [0, k12 ; k21, 0];

%% Analyze controller response

% Use diagonal or off diagonal pairing, based on values of the rga matrix,
% for high theta the off-diagonal will work better since the bandwidth is
% lower since the off-diagonal rgas are closer to 1, and viceversa

% Define Open Loop System
L = G * K;

% Get sensitivities
T = feedback(L, eye(2));

step(T)