function [] = compute_dpr( data )
% Compute Dynamic PageRanks for a set of graphs
%
% Set options: 
%   - numerical scheme (rk45,rk23,...) 
%   - alpha = (0.5, 0.85, 0.99)
%   - theta = (0.01, 0.1, 0.5, 1, 10), 
%   - scale = (1,2,4,6,8,..., for s = infinity use static_pagerank_infty.m) 
%
% See experiments/wiki_timescales_48h for examples
%
%
% Ryan A. Rossi, Purdue University
% Copyright 2012
%

setup_paths

if nargin == 0,
    data = 'graphs';
end
graphlist = get_graphlist(data);

dbpath = 'data/';
gdata = containers.Map();
for i=1:size(graphlist,1),
    
    info = struct();
    name     = graphlist{i,1};
    info.name = name;
    
    info.output   = graphlist{i,2};
    info.ode_time = graphlist{i,3};
    info.sample   = graphlist{i,4};
    info.method   = graphlist{i,5};
    info.theta    = graphlist{i,6};
    load_graph
    
    t0 = tic;
    opts = struct('scale',info.ode_time, 'sample',info.sample, 'alg', info.method, 'theta',info.theta);
    [X dpr_info] = dynamic_pagerank(A,v,opts);
    info.runtime = toc(t0);
    
    fprintf('finished, saving solutions...');
    save([dbpath,'/',info.output],'X', 'dpr_info','-v7.3');
    
    info.dpr = dpr_info;
    info.dpr
    
    gdata(info.output) = info; %save some extra info
    save([dbpath,'/','stats_',data], 'gdata');
end
