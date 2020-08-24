function r = rga_number(G, S)
% RGA_NUMBER   RGA Number
% 
% r=rga_number(G, S) returns the rga number for the pairing S.

r = norm(rga(G) - S,1);
end

