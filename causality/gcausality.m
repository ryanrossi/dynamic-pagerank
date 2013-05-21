function C = gcausality(X, vertex, neighs, cutoff, nlag)
% test for Granger "causality" for a given vertex
% 
% inputs:
% -----------------
%  X         collection of time-series from dynamic pagerank
%  vertex    vertex to test for Granger causality among neighbors
%  neighs    neighbors of the vertex (actual edges in G)
%  cutoff    cutoff value for determining significance
%  nlag      lags to use in model, can also be computed using AIC, 
%
% For additional info on the validity/assumptions, see:
%  Box, George EP, Gwilym M. Jenkins, and Gregory C. Reinsel. Time 
%  series analysis: forecasting and control. Vol. 734. Wiley, 2011.
%
% The var codes are from:
% LeSage, James P. "Econometrics toolbox." (2001).
%

% Ryan A. Rossi, Purdue University
% Copyright 2012
%

if nargin < 4,
    cutoff = 0.001;
end

if nargin < 5,
    nlag = 4;
end

tic; n = length(neighs); warning off;
for i=1:n,
    if vertex ~= neighs(i),
        fprintf('computing Granger causality for %d --> %d \n',1, i+1 );
        
        Y = full([X(vertex,:)' X(neighs(i),:)']);
        results = vare(Y,nlag);
        
        C(1,i+1) = results(1).fprob(2);
        C(i+1,1) = results(2).fprob(1);
    end
end
% prune insignificant edges based on fprob/cutoff
C = prune_edges(C,cutoff);
toc; warning on;