function [A,v] = load_data(graphname)

path=fileparts(mfilename('fullpath'));
dbpath = 'data';
load(fullfile(path,dbpath,[graphname '.mat']));

