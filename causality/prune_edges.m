function Cpruned = prune_edges(C, cutoff)
% prune the verts according to the fprob/cutoff
% Note that edges in C are weighted by their fprob
%
% input:
% ------------------------------------------------------
%  C        granger causality graph
%  cutoff   cutoff value for significant causal edges
%
% Output the pruned causality graph
%
%

% Ryan A. Rossi, Purdue University
% Copyright 2012


Cpruned = C;
for i=1:size(C,2),
    rm = find(C(i,:) > cutoff);
    Cpruned(i,rm) = 0;
    
    rm = find(C(:,i) > cutoff);
    Cpruned(rm,i) = 0;
end
