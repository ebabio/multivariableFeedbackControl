function remote_feval(path, function_name, args)
%REMOTEFEVAL : run remote function given the function path without
% modifying the current path

origin_folder = pwd;
cd(path);
if(nargin <= 2)
    feval(function_name)
else
    feval(function_name, args);
end
cd(origin_folder);

end