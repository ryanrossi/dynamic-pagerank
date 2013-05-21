% old codes, used to identify sig trends that persist
%% load data and precompute dynamic rank
setup_paths
load data/wiki-24hours.mat
load data/wiki-24h-i4-rk45.mat
d = difference_rank(X(:,4:size(X,2))); [~,rank] = sort(d,'descend');

rep = 5000; dim = 2;
k = [2 3 4 5 10];
verts = [1000 5000 10000 20000 50000];

%% 
for i=1:length(verts),
    for j=1:length(k),
        fn = strcat('clust-i',num2str(verts(i)),'-k',num2str(k(j)));
        tic
        [L,C] = cluster_score_trends(X(:,4:size(X,2)),rank,verts(i),k(j),rep,'',dim,fn,pages);
        toc
        close all
    end
end