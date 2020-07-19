%% Setup Workspace

clear
clc

% Add Library
addpath(fullfile(pwd, 'lib'));

%% Define System

sys = zpk_time(-2, [5, 10], 3);


%% Show properties

[z, p, k] = zpkdata_siso(sys)

figure(1)
pzmap(sys)

figure(2)
bodeplot(sys)

figure(3)
nyquist(sys)
