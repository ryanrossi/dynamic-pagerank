function var = variance_rank(X)
% compute variance rank for Dynamic PageRank
%
% Ryan A. Rossi, Purdue University
% Copyright 2012
%

tmax = size(X,2);
X_m = mean(X')';
X_mean = repmat(X_m,1,tmax);

var = (sum((abs(X - X_mean))' ) / tmax)';
