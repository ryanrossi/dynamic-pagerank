function [Cg, cpages, map] = get_causality_graph(C,verts,pages,fn)
% induce the directed causality graph 
% then output it in graphml format for visualization
%
% Ryan A. Rossi, Purdue University
% Copyright 2012


% first remove all vertices with zero degree
%s = find(sum(C(verts,:)) > 0);

% then induce the graph using that set
n = length(verts);
map = 1:n; 
Cg = C(verts,verts);
assert(size(Cg,1) == n);
assert(nnz(Cg) == nnz(C));

c_sum = sum(C(verts,verts));
cg_sum = sum(Cg);
assert(all(c_sum==cg_sum));

for i=1:n,
   cpages{i} = pages{verts(i)};
end

fprintf('writing graphml file to %s \n', fn);
export2graphml(Cg,cpages,fn);

