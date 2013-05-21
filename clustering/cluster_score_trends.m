function [L,C,verts,color] = cluster_score_trends(X,idx,n,k,rep,df,dim,fn,pages)
% Group vertices according to their transient dynamic pagerank scores
%
%  - computes the significant dpr trends and
%  - identifies the common time-series
%  - finds vertices with similar dynamic behavior
%
%  Objective rank func can be changed easily, simply replace idx with
%  a new rank measure.
%
% Options:
% ---------------------------------------------------------------------
%   X       time-series of Dynamic PageRank scores
%   idx     difference rank or any other dynamic ranking measure
%   n       num verts to use in the clustering
%   k       trends/time-series patterns, can also learn this parameter
%   rep     num repeated clusterings for min distance computation
%   dim     dims=(2,3), also determines the projection of data via SVD
%   fn      name used for the plots
%   pages   labels for the vertices
%
% todo: add ranking and normalization/preprocessing options
%
%
% Ryan A. Rossi, Purdue University
% Copyright 2012
%

if nargin < 8, fn = ''; end;
if nargin < 7, dim = 2; end;
warning off

%Xn = normalize_ts(X(idx(1:n),:));
Xn = normrows(X(idx(1:n),:));
[L,C,~,D] = kmeans(Xn,k,'Replicates',rep,'start','uniform');
%[U,S,V] = svds(Xn,k);


labelName = 'Dynamic PageRank'; path = 'web/'; tag = '';
for i=1:k, labels{i} = strcat('Temporal Pattern ', int2str(i)); end

labelSize = 16;
color{1} = rgb('DodgerBlue'); color{2} = rgb('Crimson'); color{3} = rgb('LimeGreen');
color{4} = rgb('MediumPurple'); color{5} = rgb('HotPink'); color{6} = 'y'; color{7} = 'k';

m = length(color); siz = [1 1 900 400];
fig = figure('Position',siz,'XVisual','0x24 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)');
set(gcf,'DefaultAxesColorOrder',[rgb('DodgerBlue');rgb('Crimson');rgb('LimeGreen');rgb('MediumPurple');rgb('DeepPink');rgb('yellow');]);
C = normalize_ts(C')'; %adjust centers for comparison/vis
plot(C','LineWidth',3);
grid off; box off; 
legend(labels,'Location','NE');
xlabel('time','FontSize',labelSize);
ylabel(labelName,'FontSize',labelSize);
set(gca,'XTick',[0:5:size(Xn,2)]);
xlim([1 size(Xn,2)]);
ylim([0 max(max(C'))+0.04]);
set(gca, 'Position', get(gca, 'OuterPosition') - get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
set(gcf,'PaperPositionMode','auto');
print(fig,'-depsc','-tiff','-r300',strcat(path,'/',fn,'-dpr-centers',int2str(k),'.eps'));


m = 20; nset = {};
for i=1:k,
    cluster_idx = find(L == i);
    ncl = length(cluster_idx)
    [val_dist idx_dist] = sort(D(cluster_idx,i),'ascend'); 
    node_idx = cluster_idx;
    
    if length(node_idx) > 100,
        node_idx = cluster_idx(idx_dist(1:100)); %min dist to centroid
    end
    
    if ncl < m, nset{i} = node_idx(1:ncl);
    else nset{i} = node_idx(1:m); end; 
end


if k == 4,
    color_assign(1:m) = 1;
    color_assign(m+1:m*2) = 2;
    color_assign((m*2)+1:m*3) = 3;
    color_assign((m*3)+1:m*4) = 4;
    verts = [idx(nset{1})' idx(nset{2})' idx(nset{3})' idx(nset{4})'];
elseif k == 5,
    color_assign(1:m) = 1;
    color_assign(m+1:m*2) = 2;
    color_assign((m*2)+1:m*3) = 3;
    color_assign((m*3)+1:m*4) = 4;
    color_assign((m*4)+1:m*5) = 5;
    verts = [idx(nset{1})' idx(nset{2})' idx(nset{3})' idx(nset{4})' idx(nset{5})'];
end
dpr_score_plot(X, verts, [fn,'-dpr-trends'], 10, pages,color_assign)

warning on