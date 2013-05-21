% Examples of testing for Granger "causality" among the dpr time-series
%
% For info on the validity/assumptions of Granger causality:
%  Box, George EP, Gwilym M. Jenkins, and Gregory C. Reinsel. Time 
%  series analysis: forecasting and control. Vol. 734. Wiley, 2011.
%
% The var codes are from:
%  LeSage, James P. "Econometrics toolbox." (2001).
% 


%%
%================================================
% Test earthquake for wiki-24h using rk45, s=4
%================================================
load data/wiki-graph
load data/wiki-pages
load data/wiki-24hours
load data/wiki-24h-i4-rk45


%%
% find the vertex of interest
name = 'Earthquake';
idx = find(strncmp(name,pages,length(name)));
vertex = idx(1);
fprintf('found %s\n',pages{vertex});

%get neighbors
neighbors = find(A(vertex,:) > 0);
ids = [vertex neighbors];
rand('seed',100); X(:,size(X,2)) = []; 

C = gcausality(X, vertex, neighbors);
prt_causality(C,ids,pages);

%% 
name = 'Earthquake';
idx = find(strncmp(name,pages,length(name)));
vertex = idx(1);
fprintf('found %s\n',pages{vertex});

neighbors = find(A(vertex,:) > 0);
ids = [vertex neighbors];
C = gcausality(X, vertex, neighbors,0.001,8);
prt_causality(C,ids,pages);


%%
%========================================================
% Test 'Earthquake' for wiki-48h using rk45, s=4
%========================================================
load data/wiki-graph
load data/wiki-pages
load data/wiki-48hours

%%
name = 'Earthquake';
idx = find(strncmp(name,pages,length(name)));
vertex = idx(1);
fprintf('found %s\n',pages{vertex});

neighbors = find(A(vertex,:) > 0);
ids = [vertex neighbors];
C = gcausality(X, vertex, neighbors);
prt_causality(C,ids,pages);


%%
%================================================
% Test 'PageRank' for wiki-24h using rk45, s=2
%================================================
load data/wiki-24hours
load data/wiki-graph
load data/wiki-pages
load data/wiki-24h-i2-rk45

%%
name = 'PageRank';
idx = find(strncmp(name,pages,length(name)));
vertex = idx(1);
fprintf('found %s\n',pages{vertex});

neighbors = find(A(vertex,:) > 0);
ids = [vertex neighbors];
cutoff = 0.001;

C = gcausality(X, vertex, neighbors, cutoff);
prt_causality(C,ids,pages);

%%
%================================================
% Test 'Actor' for wiki-24h using rk45, s=4
%================================================
load data/wiki-graph
load data/wiki-pages
load data/wiki-24hours
load data/wiki-24h-i4-rk45

%%
name = 'Actor';
idx = find(strncmp(name,pages,length(name)));
vertex = 4081044;
fprintf('%s\n',pages{vertex});

neighbors = find(A(vertex,:) > 0);
ids = [vertex neighbors];
cutoff = 0.001;

C = gcausality(X, vertex, neighbors, cutoff);
prt_causality(C,ids,pages);


%%
%========================================================
% Test 'Australia' for wiki-48h using rk45, s=6, theta=1
%========================================================
load data/wiki-graph
load data/wiki-pages
load data/wiki-48hours
load data/wiki-48h-i6-th10-rk45


%%
name = 'Australia';
idx = find(strncmp(name,pages,length(name)));
vertex = idx(1);
fprintf('found %s\n',pages{vertex});

neighbors = find(A(vertex,:) > 0);
ids = [vertex neighbors];
cutoff = 0.001;

C = gcausality(X, vertex, neighbors, cutoff);
prt_causality(C,ids,pages);

