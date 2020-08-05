function sys = zpk_time(t_z, t_p, k)
%%ZPK_TIME Create a Linear system specified by times of Zeros and Poles and Gain
%   T_Z characteristic time for zeros, negative time for RHP zeros
%   T_P characteristic time for poles, negative time for RHP poles
%   K gain

if(nargin<2)
    k = 1;
end

z = -1./ t_z;
p = -1./ t_p;
k = k * prod(t_z) / prod (t_p);

sys = zpk(z, p, k);