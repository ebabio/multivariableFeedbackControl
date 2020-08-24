function L = rga(G)
% RGA   Relative Gain Array
% 
% L returns the Relative Gain Array, L based on the gain matrix, G.

% compute the rga matrix
L = G .* pinv(G).';

