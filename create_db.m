% read the dynamic teleportation vectors
% 
% input:     path to '.counts' files
% output:    files - list of filenames corresponding to the counts
%                v - teleportation vectors corresponding to counts
%



%===========================================================
% Wikipedia 24 hours, from March 6
%===========================================================
setup_paths
load data/wiki-graph.mat
load data/wiki-pages.mat

% paths to the .counts files from extract/parsing scripts
datapath = 'data/pageviews/24hours/';

files = find_files(datapath);
tmax = length(files);
fprintf('detected %d time points \n',tmax);

for t=1:tmax,
    fprintf('t=%d \n',t);
    path = strcat(files{t});
    p(:,t) = dlmread(path);
    p = sparse(p);
end

clear idx m n t suffix path n_time n_nodes fullPath fid ans

path = 'data/';
save([path,'wiki-p',num2str(tmax)],'p');

v = normcols(p);
clear p
save([path,'wiki-v',num2str(tmax)],'v');
save([path,'wiki-pages'],'pages');
save([path,'wiki-graph'],'A');

fprintf('finished, saving graph and evolving teleportation vectors \n')
save([path,'wiki-',num2str(tmax),'hours']);



%===========================================================
% Wikipedia 48 hours, from March 6 through March 7 2009
%===========================================================
setup_paths
load data/wiki-graph.mat
load data/wiki-pages.mat
display('finished loading dataset...');

% paths to the .counts files from extract/parsing scripts
datapath = 'data/pageviews/48hours/';

files = find_files(datapath);
tmax = length(files);
fprintf('detected %d time points \n',tmax);

for t=1:tmax,
    fprintf('t=%d \n',t);
    path = strcat(datapath, files{t});
    p(:,t) = dlmread(path);
    p = sparse(p);
end

clear idx m n t suffix path n_time n_nodes fullPath fid ans
path = 'data/';
save([path,'wiki-p48'],'p');

v = normcols(p);
clear p
save([path,'wiki-v48'],'v');
save([path,'wiki-pages'],'pages');
save([path,'wiki-graph'],'A');

fprintf('finished, saving graph and evolving teleportation vectors \n')
save([path,'wiki-48hours']);

