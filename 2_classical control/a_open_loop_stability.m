%% Setup Workspace

clear
clc

% Add Library
addpath(fullfile(pwd, 'lib'));

%% Define System

% A stabl system with a RHP zero, from Skogestad, section 2.3
G = zpk_time(-2, [5, 10], 3);

%% Show properties

% Get Zeros and Poles
[z, p, k] = zpkdata_siso(G)

% Plot the pole/zeros
figure(1)
pzmap(G)

% Bode Plot
figure(2)
bodeplot(G)

% Nyquist Diagram
figure(3)
nyquist(G)
