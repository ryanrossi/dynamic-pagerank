function [ pr_uniform, pr_avg ] = static_pagerank(A,v)
% compute two variants of static pagerank:
%   - uniform teleportation
%   - average teleportation time-series
%
% Ryan A. Rossi, Purdue University
% Copyright 2012
%

opts = struct('v', v);
pr_avg = pagerank(A,opts);

pr_uniform = pagerank(A);
