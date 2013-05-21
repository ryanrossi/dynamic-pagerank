function xnorm = normalize(x)

if sum(x) > 0,
    xnorm = (x - min(x(x>0))) / (max(x) - min(x(x>0)));
else
    fprintf('error: negative... not normalizing \n');
    xnorm = x;
end
