function [d var c avg] = dynamic_ranks(X)
% Ranking measures for Dynamic PageRank time-series: 
%    - difference ranking, 
%    - variance rank,
%    - average,
%    - cumulative
%
% Ryan Rossi (rrossi@purdue.edu)
% Copyright 2012, Purdue University
% 

d = difference_rank(X);
var = variance_rank(X);

c = sum(X')';

tmax = size(X,2);
avg = c/tmax;



