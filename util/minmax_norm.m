function xnorm = minmax_norm(x)
% scale values of x between [0,1]
% if x is a matrix, scale each vector

n = size(x,1);
if n < 2,
    if sum(x) > 0,
        xnorm = (x - min(x(x>0))) / (max(x) - min(x(x>0)));
    else
        fprintf('error: negative values \n');
        xnorm = x;
    end
else
    x = x';
    n = size(x,1);
    xnorm = (x - repmat(min(x),n,1)) ./ repmat(max(x) - min(x),n,1);
    xnorm = xnorm';
end