function files = find_files(varargin)
% FIND_FILES Perform a recursive directory search
%
% files = find_files('data') Find all the files in the data directory.
% files = find_files('data','.txt.gz') Find all the files in the 
% data directory with extension *.txt.gz
% 

if length(varargin) < 1
    curdir = '.';
else
    curdir = varargin{1};
    if length(varargin) > 1
        exts = varargin(2:end);
    else
        exts = {}; % all extensions
    end
end
% we are searching curdir recursively for files with an extension matching
% that in the list of extensions
filesstruct = dir(curdir);
files = {};
mydirfiles = {};
for fi=1:length(filesstruct)
    f = filesstruct(fi);
    if strcmp(f.name,'.') || strcmp(f.name,'..')
        continue
    elseif f.isdir
        % recurse
        dirfiles = find_files(fullfile(curdir,f.name),exts{:});
        files = [files; dirfiles]; % append the list of files
    else
        % it's a regular file, see if it matches the extension list
        % TODO escape periods in the name list
        if isempty(exts)
            mydirfiles{end+1} = fullfile(curdir,f.name);
        else
            for exti=1:length(exts)
                if ~isempty(regexp(f.name,[exts{exti} '$'], 'once'))
                    % it's a match!
                    mydirfiles{end+1} = fullfile(curdir,f.name);
                    break;
                end
            end
        end
    end
end
files = [files;mydirfiles'];