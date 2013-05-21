%% setup 
clear all
path = 'web/'; str = 'wiki_basic_example';
if ~exist('p','var'),
    load data/wiki-p24
end
if ~exist('A','var'),
    load data/wiki-graph
end

n = 1000; n_plot_verts = 1000; n_verts = 15;

rand('seed',100);
randverts = randperm(size(A,2)); r = randverts(1:n);

v_sm = normcols(p(r,:));
A_sm = A(r,r);

rv = randperm(n);
verts = rv(1:n_verts);

% basic example
opts = struct('scale',4, 'sample',4, 'alg', 'rk45');
[X dpr_info dpr_sol] = dynamic_pagerank(A_sm,v_sm,opts);

dt = 0.05;
tgrid = eps(1) : dt : dpr_info.tmax;
X = deval(dpr_sol,tgrid);

dpr_verts_plot(X,verts,[path,str]);

