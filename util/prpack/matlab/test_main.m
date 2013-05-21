function test_main

tol = 1e-10;
alpha = 0.85;

A = readSMAT('../data/jazz.smat');
P = normout(A);
n = size(P,1);
x = (speye(n) - alpha * P')\ones(n,1);
x = x./sum(x);

y = pagerank(A);
dxy = norm(x-y,1);
assert(dxy < 2*tol);


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
id = spfun(@(x) 1./x, d);

% scale the rows of the matrix
P = diag(sparse(id))*A;


function A = readSMAT(filename)
% readSMAT reads an indexed sparse matrix representation of a matrix
% and creates a MATLAB sparse matrix.
%
%   A = readSMAT(filename)
%   filename - the name of the SMAT file
%   A - the MATLAB sparse matrix
%

% David Gleich
% Copyright, Stanford University, 2005-2010

if (~exist(filename,'file'))
    error('readSMAT:fileNotFound', 'Unable to read file %s', filename);
end

s = load(filename,'-ascii');
m = s(1,1);
n = s(1,2);

ind_i = s(2:length(s),1)+1;
ind_j = s(2:length(s),2)+1;
val = s(2:length(s),3);
A = sparse(ind_i,ind_j,val, m, n);
