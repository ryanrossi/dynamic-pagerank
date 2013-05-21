function [avg_smape error] = smape(y, yhat)
[n tmax] = size(y);

error = sum((abs(y - yhat) ./ ...
    ((y + yhat)/2))')' / tmax;
error = abs(error); error(error > 2) = 2; error(isnan(error)) = 2;

%average smape over all verts
avg_smape = abs(sum(error) / n);

