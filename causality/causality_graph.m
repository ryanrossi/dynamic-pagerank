% compute causality graph, weight edges by f-prob
% examples below only compute a subgraph for analysis/visualization
%

d = difference_rank(X);
[d_val,d_rank] = sort(d,'descend');


%%
%===============================================
% top 50 verts from diff rank (and neighbors)
%===============================================
verts = d_rank(70:90); %70-80 works

cutoff = 0.001; %strict
max_neigh = 100; %limit any one vertex...

[ C, Cpruned, verts_all, vert_dict ] = causality_var(X,A,verts,cutoff,max_neigh);

fprintf('%d vertices \n',length(verts_all));
fprintf('%d edges in C, %d edges after pruning \n', nnz(C), nnz(Cpruned));

fn = ['causality_diff','.graphml'];
[ Cg, cpages, map ] = get_causality_graph(Cpruned,verts_all,vert_dict,pages,fn);


%%
%===============================================
% top 100 verts from diff rank (and neighbors)
%===============================================
n = 50;
verts = d_rank(1:n);

cutoff = 0.01; %strict so less links, more meaningful...
max_neigh = 100; %limit any one vertex...

[ C, Cpruned, verts_all, vert_dict ] = causality_var(X,A,verts,cutoff,max_neigh);

fprintf('%d vertices \n',length(verts_all));
fprintf('%d edges in C, %d edges after pruning \n', nnz(C), nnz(Cpruned));

fn = ['causality_diff','.graphml'];
[ Cg, cpages, map ] = get_causality_graph(Cpruned,verts_all,vert_dict,pages,fn);


%%
%===============================================
% top 100 verts from pagerank (and neighbors)
%===============================================
pr = pagerank(A);
[~,r] = sort(pr,'descend');

n = 100;
verts = r(1:n);

cutoff = 0.001; %strict 
max_neigh = 100; %limit any one vertex...

[ C_pr, Cpruned_pr, verts_all_pr, vert_dict_pr ] = causality_var(X,A,verts,cutoff,max_neigh);

fprintf('%d vertices \n',length(verts_all_pr));
fprintf('%d edges in C, %d edges after pruning \n', nnz(C_pr), nnz(Cpruned_pr));



