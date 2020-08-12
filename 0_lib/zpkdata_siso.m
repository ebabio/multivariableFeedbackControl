function [z,p,k] = zpkdata_siso(sys)
%%ZPKDATA_SISO Get Zero, Pole, Gain data for a SISO system.
%   Returns the zpk data in array form instead of cell form

[z_cell, p_cell, k]  =zpkdata(sys);

z = z_cell{:};
p = p_cell{:};

end