%% Init Control Libs

function init_libs(path_position)
%% Setup workspace
% check where to add to path
if(nargin == 0)
    path_position = '-begin';
end

% init library
filepath = fileparts(mfilename('fullpath'));
addpath(filepath, path_position);

%% Add dependent libraries to path
% get all files in subfolders
all_files = dir(fullfile(filepath, '**'));

% search for init library files: init_*.m
for i=1:length(all_files)
    if(strcmp(filepath, all_files(i).folder))
        % skip init files in the same folder, skip itself
        continue
    end
    
    % check for matches
    regexpMatch = @(index) ~isempty(index); % match if index is not empty
    init_match = regexpMatch(regexp(all_files(i).name, '(^(init_).+(\.m)$)', 'once'));
    [~, function_name] = fileparts(all_files(i).name);
    
    if(init_match)
        % run the init file
        remote_feval(all_files(i).folder, function_name, path_position);
    end
end

end
