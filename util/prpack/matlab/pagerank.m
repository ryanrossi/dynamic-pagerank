function [x, stats] = pagerank(A, varargin)
%PAGERANK Compute the PageRank vector of a graph
%
%   PAGERANK(A) computes the PageRank of a sparse matrix A 
%   whose non-zero entries indicate edges.  (The values in A are
%   ignored.) 
%
%   Formally, this call corresponds to solving the following linear system:
%     n=size(A,1); (speye(n)-alpha*A'*spfun(@(x)1./x,diag(sum(A,2))))\ones(n,1)
%   where alpha = 0.85 and where the solution is renormalized to sum to a 
%   probability vector.  
%   
%   PAGERANK(A, alpha) computes PageRank for any value of 0 <= alpha <= 1.
%
%   [x,stats] = PAGERANK(A, alpha, 
%   Inputs:
%       A = a sparse matrix whose non-zero entries indicate edges 
%           (all entry values are ignored)
%       alpha  = alpha value
%       tol    = tolerance allowed for error
%       u      = u vector
%       v      = v vector
%       method = [optional] method to use to compute PageRank

fprintf('inside correct pagerank :) \n');

prs = pagerank_solver(A);
[x, stats] = prs.solve(varargin{:});
