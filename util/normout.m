function P = normout(A)
% NORMOUT Normalize the outdegrees of the matrix A.  
%
%   P has the same non-zero structure as A, but is normalized such that the
%   sum of each row is 1, assuming that A has non-negative entries. 

% compute the row-sums/degrees
d = full(sum(A,2));

% invert the non-zeros in the data
id = invzero(d);

% scale the rows of the matrix
P = diag(sparse(id))*A;

function v = invzero(v)
% sparse input are easy to handle
if (issparse(v))
    [m n] = size(v);
    [i j val] = find(v);
    val = 1./val;
    v = sparse(i,j,val,m,n);
    return;
end;

% compute the 0 mask
zm = abs(v) > eps(1);

% invert all non-zeros
v(zm) = 1./v(zm);