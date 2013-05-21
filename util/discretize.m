function Xs = discretize( X, v, s )

if nargin < 3,
    tx_max = size(X,2);
    tv_max = size(v,2);
    s = tx_max / tv_max;
    if s ~= floor(s),
       X(:,1) = []; 
    end
    s = floor(s);
    fprintf('s == %d', s);
end
Xs = X(:,s:s:tx_max);

assert(size(Xs,2) == tv_max);


