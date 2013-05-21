function isim = intersection_sim(x, y, k)
%Computes the intersection similarity between two vectors x and y

[~,x_rank] = sort(x,'descend');
[~,y_rank] = sort(y,'descend');

tic
s = 0;
for j=1:k,
    isim_tmp(j) = (length(setdiff(union(x_rank(1:j), y_rank(1:j)), ...
        intersect(x_rank(1:j), y_rank(1:j)))) / (2*j));
    s = s + isim_tmp(j);
    isim(j) = s / j;
end
toc
