function Xnorm = normalize_ts(X)

n = size(X,1);
Xnorm = (X - repmat(min(X),n,1)) ./ repmat(max(X) - min(X),n,1);



