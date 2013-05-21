% examples of clustering transient score trends
%


%%
% timescale = 4, wiki-24hours
%
load data/wiki-24hours.mat
load data/wiki-24h-i4-rk45.mat
d = difference_rank(X(:,4:size(X,2))); [~,rank] = sort(d,'descend');

n = 4000; dim = 2; k = 5; rep = 5000; fn = 'clust-s4-4k';
[L,C] = cluster_score_trends(X(:,4:size(X,2)),rank,n,k,rep,'',dim,fn,pages);

n = 5000; dim = 2; k = 5; rep = 5000; fn = 'clust-s4-5k';
[L,C] = cluster_score_trends(X(:,4:size(X,2)),rank,n,k,rep,'',dim,fn,pages);


% vis top 100 nodes for ref
n = 100; r = 10; Xdis = discretize(X,v); 
d = difference_rank(Xdis); [~,d_rank] = sort(d,'descend');
dpr_timeseries(Xdis, v, d_rank(1:n),'wiki-ts4-d-100-1000', r, pages)



%%
% timescale = 1, wiki-24hours
%
load data/wiki-24hours.mat
load data/wiki-24h-i1-rk45.mat
d = difference_rank(X); [~,rank] = sort(d,'descend');

n = 5000; dim = 2; k = 5; rep = 2000; fn = 'clustering-ts1-24h-';
[L,C] = cluster_score_trends(X,rank,n,k,rep,'',dim,fn,pages);


n = 100; r = 10; Xdis = discretize(X,v);
d = difference_rank(Xdis); [~,d_rank] = sort(d,'descend');
dpr_timeseries(Xdis, v, d_rank(1:n),'wiki-ts1-d-100', r, pages)



%%
% timescale = 2, wiki-24hours
%
load data/wiki-24hours.mat
load data/wiki-24h-i2-rk45.mat
d = difference_rank(X); [~,rank] = sort(d,'descend');

n = 5000; dim = 2; k = 5; rep = 2000; fn = 'clustering-ts2-24h';
[L,C] = cluster_score_trends( X, rank, n,k,rep,'',dim,fn,pages );


n = 100; r = 10; Xdis = discretize(X,v);
d = difference_rank(Xdis); [~,d_rank] = sort(d,'descend');
dpr_timeseries(Xdis, v, d_rank(1:n),'wiki-ts2-d-100', r, pages)




%%
% timescale = 6, wiki-24hours
%
load data/wiki-24hours.mat
load data/wiki-24h-i6-rk45.mat
d = difference_rank(X); [~,rank] = sort(d,'descend');

n = 5000; dim = 2; k = 5; rep = 2000; fn = 'clustering-ts6-24h';
[L,C] = cluster_score_trends( X, rank, n,k,rep,'',dim,fn,pages );

n = 100; r = 10; Xdis = discretize(X,v); 
d = difference_rank(Xdis); [~,d_rank] = sort(d,'descend');
dpr_timeseries(Xdis, v, d_rank(1:n),'wiki-ts6-d-100', r, pages)




%%
% timescale = 8, wiki-24hours
%
load data/wiki-24hours.mat
load data/wiki-24h-i8-rk45.mat
d = difference_rank(X); [~,rank] = sort(d,'descend');

n = 5000; dim = 2; k = 5; rep = 2000; fn = 'clustering-ts8-24h';
[L,C] = cluster_score_trends( X, rank, n,k,rep,'',dim,fn,pages );


n = 100; r = 10; Xdis = discretize(X,v); 
d = difference_rank(Xdis); [~,d_rank] = sort(d,'descend');
dpr_timeseries(Xdis, v, d_rank(1:n),'wiki-ts8-d-100', r, pages)



%%
% timescale = 4, wiki-24hours
%
load data/wiki-24hours.mat
load data/wiki-24h-i4-rk45.mat
d = difference_rank(X(:,4:size(X,2))); [~,rank] = sort(d,'descend');

n = 50000; dim = 2; k = 5; rep = 2000; fn = 'clustering-ts4-24h-50k';
[L,C] = cluster_score_trends(X(:,4:size(X,2)),rank,n,k,rep,'',dim,fn,pages);