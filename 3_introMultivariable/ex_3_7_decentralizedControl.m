%% Ex 3.7: A decentralized control

%% Setup Workspace

clear
close all
clc

% Add Library
lib_path = fullfile(fileparts(mfilename('fullpath')), '..', '0_lib');
remote_feval(lib_path, 'init_libs');

%% System definition

% tunable parameter
theta = 5;

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