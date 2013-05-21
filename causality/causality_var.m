function [C, Cpruned, verts_all, vert_dict] = causality_var(X, A, verts, cutoff, max_neighs, lag)
% test for Granger "causality" among a collection of vertices
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
%    series analysis: forecasting and control. Vol. 734. Wiley, 2011.
%  Granger, C. (1969), "Investigating Causal Relations by Econometric 
%    Models and Cross-spectral Methods". Econometrica 37 (3): 424?438
%

% Ryan A. Rossi, Purdue University
% Copyright 2012
%

if nargin < 4,
   cutoff = 0.01;
end
if nargin < 5,
   max_neighs = 100; 
end
if nargin < 6,
   lag = 2; 
end

n = length(verts);

m = size(A,1);
C = sparse(m,m);

vert_dict = {}
verts_all = verts;
for i=1:n
    N = union(find(A(verts(i),:) > 0), find(A(:,verts(i)) > 0));
    if length(N) > max_neighs,
        rnd = randperm(length(N));
        N = rnd(1:max_neighs);
    end
    vert_dict{i} = N;
    verts_all = union(verts_all, N);
    
    for j=1:length(N),
        xx = normrows(X(verts(i),:)); %ensure
        yy = normrows(X(N(j),:));
        Y = full([xx' yy']);
        results = vare(Y,lag);
        C(verts(i),N(j)) = results(1).fprob(2);
        C(N(j),verts(i)) = results(2).fprob(1);
    end
end

%prune the verts according to the fprob/cutoff
Cpruned = C;
for i=1:length(verts_all),
    rm = find(C(verts_all(i),:) > cutoff);
    Cpruned(verts_all(i),rm) = 0;
    
    rm = find(C(:,verts_all(i)) > cutoff);
    Cpruned(rm,verts_all(i)) = 0;
end


