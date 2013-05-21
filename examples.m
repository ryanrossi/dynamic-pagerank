% Demo of Dynamic PageRank for different numerical schemes
% timescale s = 4, and sample = 2
%
% For smaller example use:
%   load('test_graph100k')
%
%
% Ryan A. Rossi, Purdue University
% Copyright 2012
%

% setup paths and load data
setup_paths

[A,v] = load_data('wiki-48hours');
%load('test_graph100k')
%load('test_graph1k')



%%
%=======================================
% Dynamic Pagerank Runge-Kutta 4/5 
%=======================================
tic
opts = struct('alpha', 0.85, 'scale', 4, 'sample', 2, 'alg', 'rk45');
[X dpr_info dpr_sol] = dynamic_pagerank(A,v,opts);
toc


%%
%=======================================
% Dynamic Pagerank RK23
%=======================================
tic
opts = struct('alpha', 0.85, 'scale', 4, 'sample', 2, 'alg', 'rk23');
[X dpr_info dpr_sol] = dynamic_pagerank(A,v,opts);
toc


%%
%=======================================
% Dynamic Pagerank Adams (ODE113)
%=======================================
tic
opts = struct('alpha', 0.85, 'scale', 4, 'sample', 2, 'alg', 'adams');
[X dpr_info dpr_sol] = dynamic_pagerank(A,v,opts);
toc


%%
%=======================================
% Dynamic Pagerank RK45, smoothing v 
%=======================================
tic
opts = struct('alpha', 0.85, 'theta', 0.5, 'scale', 4, 'sample', 2, 'alg', 'rk45-smooth');
[X dpr_info dpr_sol] = dynamic_pagerank(A,v,opts);
toc


%%
%=========================================
% Dynamic Pagerank (Power/forward-Euler) 
%=========================================
tic
opts = struct('alpha', 0.85, 'scale', 4, 'sample', 2, 'alg', 'power-euler');
[X dpr_info] = dynamic_pagerank(A,v,opts);
toc




%%
%--------------------------------------------------------
% Computing Dynamic PageRank transient scores
%
% See get_graphlist.m to add/modify data
% Also see: wiki-smoothing-24h.m, twitter_timescales.m
% Should be straightforward to add data
%--------------------------------------------------------


% compute dpr scores for various timescales
run_wiki_timescales_48h
run_twitter_timescales


%%
% compute dpr time-series for preds
compute_dpr('wiki-preds')
compute_dpr('twitter-preds')

%% 
% numerical schemes benchmark for computing dynamic pagerank
ode_methods_plot