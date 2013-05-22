function [x flag hist dt dt_rank] = pagerank(A,optionsu)
% PAGERANK Compute the PageRank for a directed graph.
%
% [p flag hist dt] = pagerank(A)
%
%   Compute the pagerank vector p for the directed graph A, with
%   teleportation probability (1-c).  
%
%   flag is 1 if the method converged; hist returns the convergence history
%   and dt is the total time spent solving the system
%
%   The matrix A should have the outlinks represented in the rows.
%
%   This driver can compute PageRank using 4 different algorithms, 
%   the default algorithm is the Arnoldi iteration for PageRank due to
%   Grief and Golub.  Other algorithms include gauss-seidel iterations,
%   power iterations, a linear system formulation, or an approximate
%   PageRank formulation.
%
%   The output p satisfies p = c A'*D^{+} p + c d'*p v + (1-c) v and
%   norm(p,1) = 1.
%
%   The power method solves the eigensystem x = P''^T x.
%   The linear system solves the system (I-cP^T)x = (1-c)v.
%   The dense method uses "\" on I-cP^T which the LU factorization.
%   
%   To specify a different solver for the linear system, use an anonymous
%   function wrapper around one of Matlab's solver calls.  To use GMRES,
%   call pagerank(..., struct('linsolver', ... 
%             @(f,v,tol,its) gmres(f,v,[],tol, its)))
%
%   Note 1: the 'approx' algorithm is the PageRank approximate personalized
%   PageRank algorithm due to Gleich and Polito.  It creates a set of
%   active pages and runs until either norm(p(boundary),1) < options.bp or
%   norm(p(boundary),inf) < options.bp, where the boundary is defined as
%   the set of pages that have a non-zero personalized PageRank but are not
%   in the set of active pages.  As options.bp -> 0, both of these
%   approximations compute the actual personalized PageRank vector.
%
%   Note 2: the 'eval' algorithm evaluates five algorithms to compute the
%   PageRank vector and summarizes the results in a report.  The return
%   from the algorithm are a set of cell arrays where 
%   p = cell(5,1), flag = cell(5,1), hist = cell(5,1), dt = cell(5,1)
%   and each cell contains the result from one algorithm.  
%   p{1} is the vector computed from the 'power' algorithm
%   p{2} is the vector computed from the 'gs' algorithm
%   p{3} is the vector computed from the 'arnoldi' algorithm
%   p{4} is the vector computed from the 'linsys' algorithm with bicgstab
%   p{5} is the vector comptued from the 'linsys' algorithm with gmres
%   the other outputs all match these indices.
%
%   pagerank(A,options) specifies optional parameters
%   options.c: the teleportation coefficient [double | {0.85}]
%   options.tol: the stopping tolerance [double | {1e-7}]
%   options.v: the personalization vector [vector | {uniform: 1/n}]
%   options.maxiter maximum number of iterations [integer | {500}]
%   options.verbose: extra output information [{0} | 1]
%   options.x0: the initial vector [vector | {options.v}]
%   options.alg: force the algorithm type 
%     ['gs' | 'power' | 'linsys' | 'dense' | {'arnoldi'} | ...
%      'approx' | 'eval']
%
%   options.linsys_solver: a function handle for the linear solver used
%     with the linsys option [fh | {@(f,v,tol,its) bicgstab(f,v,tol,its)}]
%   options.arnoldi_k: use a k dimensional arnoldi basis [intger | {8}]
%   options.approx_bp: boundary probability to expand [float | 1e-3]
%   options.approx_boundary: when to expand on the boundary [1 | {inf}]
%   options.approx_subiter: number of subiterations of power iterations
%     [integer | {5}]
%
% Example:
%   load cs-stanford;
%   p = pagerank(A);
%   p = pagerank(A,struct('alg','linsys',... 
%                  'linsys_solver',@(f,v,tol,its) gmres(f,v,[],tol, its)));
%   pagerank(A,struct('alg','eval'));
%
% pagerank.m
% David Gleich
%
%
% 21 February 2006
% -- added approximate PageRank
%
% Revision 1.10
% 28 January 2006
%  -- added different computational modes and timing information
%
% Revision 1.00
% 19 Octoboer 2005
%
%
% The driver does mainly parameter checking, then sends things off to one
% of the computational routines.
% 


[m n] = size(A);

if (m ~= n)
    error('pagerank:invalidParameter', 'the matrix A must be square');
end;    

options = struct('tol', 1e-7, 'maxiter', 500, 'v', ones(n,1)./n, ...
    'c', 0.85, 'verbose', 0, 'alg', 'arnoldi', ...
    'linsys_solver', @(f,v,tol,its) bicgstab(f,v,tol,its), ...
    'arnoldi_k', 8, 'approx_bp', 1e-3, 'approx_boundary', inf,...
    'approx_subiter', 5);

if (nargin > 1)
    options = merge_structs(optionsu, options);
end;


if (size(options.v) ~= size(A,1))
    error('pagerank:invalidParameter', ...
        'the vector v must have the same size as A');
end;

if (~issparse(A))
    A = sparse(A);
end;


% normalize the matrix
P = normout(A);

[x flag hist dt dt_rank] = pagerank_power(P, options);





% ===================================
% pagerank_power
% ===================================

function [x flag hist dt dt_rank] = pagerank_power(P, options)
% use the power iteration algorithm

if (options.verbose > 0)
   fprintf('power iteration computation...\n');
end;
 

tol = options.tol;
v = options.v;
maxiter = options.maxiter;
c = options.c;

x = v;
if (isfield(options, 'x0'))
    x = options.x0;
end;

[n, t] = size(v);

if (t > 1),
    x = v(:,1);
end

    
hist = zeros(maxiter,1);
delta = 1;
iter = 0;
dt = 0;
while (delta > tol && iter < maxiter)
    
    tic;
    %y =c* spmatvec_transmult(P,x);
    if iscell(P),
        if iter+1 > length(P),
            break;
        end
        y = c*(P{iter+1}'*x)
    else
        y =c*(P'*x);
    end
    w = 1 - norm(y,1);
    
    if t > 1,
        if iter+1 > t,
            display('stopped')
           break; 
        end
        y = y + w*v(:,iter+1);
    else
        y = y + w*v;
    end
    
    dt = dt + toc;
    
    delta = norm(x - y,1);
    
    hist(iter+1) = delta;
    
    tic;
    x = y;
    dt_rank(:,iter+1) = y;
    dt = dt + toc;
    
    if (options.verbose > 0)
        fprintf('iter=%d; delta=%f\n', iter, delta);
    end;
    
    iter = iter + 1;
end;

% resize hist
hist = hist(1:iter);

flag = 0;

if (delta > tol && iter == maxiter)
    warning('pagerank:didNotConverge', ...
        'The PageRank algorithm did not converge after %i iterations', ...
        maxiter);
    flag = 1;
end;

    

function S = merge_structs(A, B)
% MERGE_STRUCTS Merge two structures.
%
% S = merge_structs(A, B) makes the structure S have all the fields from A
% and B.  Conflicts are resolved by using the value in A.
%

%
% merge_structs.m
% David Gleich
%
% Revision 1.00
% 19 Octoboer 2005
%

S = A;

fn = fieldnames(B);

for ii = 1:length(fn)
    if (~isfield(A, fn{ii}))
        S.(fn{ii}) = B.(fn{ii});
    end;
end;

function P = normout(A)
% NORMOUT Normalize the outdegrees of the matrix A.  
%
% P = normout(A)
%
%   P has the same non-zero structure as A, but is normalized such that the
%   sum of each row is 1, assuming that A has non-negative entries. 
%

%
% normout.m
% David Gleich
%
% Revision 1.00
% 19 Octoboer 2005
%

% compute the row-sums/degrees
d = full(sum(A,2));

% invert the non-zeros in the data
id = invzero(d);

% scale the rows of the matrix
P = diag(sparse(id))*A;

function v = invzero(v)
% INVZERO Compute the inverse elements of a vector with zero entries.
%
% iv = invzero(v) 
%
%   iv is 1./v except where v = 0, in which case it is 0.
%

%
% invzero.m
% David Gleich
%
% Revision 1.00
% 19 Octoboer 2005
%

% sparse input are easy to handle
if (issparse(v))
    [m n] = size(v);
    [i j val] = find(v);
    val = 1./val;
    v = sparse(i,j,val,m,n);
    return;
end;

% so are dense input
 
% compute the 0 mask
zm = abs(v) > eps(1);

% invert all non-zeros
v(zm) = 1./v(zm);

function dmask = dangling(A)
% DANGLING  Compute the indicator vector for dangling links for webgraph A
% 
%  d = dangling(A)
%

d = full(sum(A,2));
dmask = d == 0;

function [k,sizes]=components(A)

% based on components.m from (MESHPART Toolkit)
% which had 
% John Gilbert, Xerox PARC, 8 June 1992.
% Copyright (c) 1990-1996 by Xerox Corporation.  All rights reserved.
% HELP COPYRIGHT for complete copyright and licensing notice

[p,p,r,r] = dmperm(A|speye(size(A)));
sizes = diff(r);
k = length(sizes);