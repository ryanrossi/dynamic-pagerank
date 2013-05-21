function [d, rel] = difference_rank(X)
% difference rank for Dynamic PageRank
%
% Only considers vertices from t=3,...,tmax only. Avoids ranking 
% vertices high that significantly change from the initial x(0)
%

% Ryan A. Rossi, Purdue University
% Copyright 2012


tmax = size(X,2); 
min_val = min(X(:,3:tmax)')';
max_val = max(X(:,3:tmax)')';


d = max_val - min_val;
rel = (max_val - min_val) ./ min_val;
