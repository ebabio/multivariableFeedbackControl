function [out, sys] = over_freq(G, omega, fun)
% OVER_FREQS   Evaluate a Matrix function over a range of frequencies

% evaluate output size to consider multiple dimensions
out_omega0 = fun(freqresp(G, omega(1)));
if(isscalar(out_omega0))
    size_out = 1;
else
    size_out = size(out_omega0);
end
index = cell(size(size_out));
for i=1:length(index)
    index{i} = ':';
end
    
% preallocate memory   
out = NaN([size_out, length(omega)]);


% apply over all frequencies
for i=1:length(omega)
   out(index{:}, i) = fun(freqresp(G, omega(i)));
end

% create frd system
sys = frd(out, omega);
end
