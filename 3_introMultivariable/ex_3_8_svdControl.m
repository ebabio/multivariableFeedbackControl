%% Ex 3.8: An SVD controller

% This is exercise 3.8 following the pdf, not the paper book which is
% different for this case.

%% Setup Workspace

clear
close all
clc

% Add Library
lib_path = fullfile(fileparts(mfilename('fullpath')), '..', '0_lib');
remote_feval(lib_path, 'init_libs');

%% System definition

% Nominal Transfer function
s = tf('s');
G = 1 / (75*s + 1) * ...
    [87.8, -86.4; 108.2, -109.6];

% System Input Uncertainty
eps1 = 0.2;
eps2 = -0.2;
D = diag([eps1, eps2]);

%% Define an Inverse Controller

% this is a typical example of a nominal performance, but not robust to
% uncertainties. Observe the effect of the uncertainties!

% This term aims for a 1/s to use in plant inversion. The integrator is
% not pure to prevent numeric noise from placing poles in the RHP
invS = 1/(s+1e-3);

k1 = 0.7;
Ki = minreal(k1 *invS / G); % very approximately integral

%% Define an SVD controller

% Obtain the SVD bases
% We note they will be constant for all frequencies, so we obtain them for dc
[U, S, V] = svd( dcgain(G) );

% Controller parameters, given in the exercise text
% option (a)
c1 = 0.005 * 60; %expressed in secs in the book
c2 = 0.005 * 60;
% option (b)
c1 = 0.005 * 60;
c2 = 0.05 *60;
% option (c) % note this leads to same controller as Ki
c1 = k1 / S(1,1);
c2 = k1 / S(2,2);

% SVD Controller
% 
Ks = (75*s + 1) * invS * diag([c1, c2]);

Ksvd = V * Ks * U';

%% Analyze controller

% choose controller
K = Ksvd;

% condition number of the controller
condition_number = cond(dcgain(K));
fprintf('Condition number of K: %.1f\n', condition_number);

% Close the loop on the nominal system
L_nominal = G * K;
T_nominal = feedback(L_nominal, eye(2));

% Close the loop on the perturbed system
L_uncertain = G * (eye(2) + D) * K;
T_uncertain = feedback(L_uncertain, eye(2));

% channel to channel SISO margins
fprintf('\nChannel to Channel margins:\n') 
for i=1:size(G,2)
[gm(i,1), pm(i,1)] = margin(T_nominal(i,i));
fprintf('\t%i to %i: gm %.0f, pm %.1f\n', i, i, gm(i), pm(i));
end


% Apply a step
figure(1)
step(T_nominal, T_uncertain, 30)

