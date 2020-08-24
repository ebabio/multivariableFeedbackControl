function [Linf, pairing] = rga_inf(G, tol)
% RGA   Relative Gain Array applied recursively to the desired tolerance
% from the unity norm
%
% Linf returns the recursion of rga(..rga(G)) to the desired tolerance

if(nargin<2)
    tol = 1e-3;
end

% compute the rga matrix limit
Linf = rga(G);
while(norm(Linf, 2) - 1 > tol)
    Linf = rga(Linf);
end

% pairing matrix
if(nargout>1)
    pairing = round(real(Linf));
end
end

