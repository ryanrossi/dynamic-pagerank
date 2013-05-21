function x_infty = static_pagerank_infty(A, v)
% timescale = infty
%
% used in preds, see compute_preds.m and
%     for plots in plot_vertex_paper.m
%
% If computations take too long, compile 
% prpack codes, and use this faster pagerank routine
% Authors: David Kurokawa, David Gleich, Chen Greif
% See https://github.com/DavidKurokawa/prpack 
%
%
% Ryan A. Rossi, Purdue University
% Copyright 2012

tmax = size(v,2);
for t=1:tmax,
    fprintf('computing t=%d\n',t);
    opts = struct('v',v(:,t));
    x_infty(:,t) = pagerank(A,opts);
end

save data/x_infty

