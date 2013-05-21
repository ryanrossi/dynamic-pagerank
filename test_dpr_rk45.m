%%
setup_paths
load('data/example_graph')

tic
opts = struct('alpha', 0.85, 'scale', 4, 'sample', 2, 'alg', 'rk45');
[X dpr_info dpr_sol] = dynamic_pagerank(A,v,opts);
toc


