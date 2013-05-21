

path=fileparts(mfilename('fullpath'));
dbpath = 'data';
load(fullfile(path,dbpath,[name '.mat']));

% if ~exist('X','var'),
%     fprintf('X does not exist, compute it using dynamic_pagerank.m \n');
% end
