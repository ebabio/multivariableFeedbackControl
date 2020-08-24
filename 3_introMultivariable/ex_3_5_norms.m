%% Exercise 3.5: Matrix norms and Spectral radius

%% Setup workspace

clear
clc

%% Matrices

G1 = [5 4; 3 2];
G2 = [0 100; 0 0];

%% Definition of all norms;

% Forbenious norm: 2-norm of singular values vector
frob = @(X) norm(X, 'fro');

% 2 norm: max singular value
norm2 = @(X) norm(X, 2); % norm(x) returns the same

% 1-norm: max column
normi1 = @(X) norm(X,1);

% inf-norm: max row
normiinf = @(X) norm(X,inf);

% spectral radius: largest eigenvalue
spectralradius = @(X) eigs(X, 1, 'largestabs');

%% Norms of matrices

% G1
frob(G1)
norm2(G1)
normi1(G1)
normiinf(G1)
spectralradius(G1)

% G2
frob(G2)
norm2(G2)
normi1(G2)
normiinf(G2)
spectralradius(G2)