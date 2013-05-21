%% a few dpr ranking examples and plots
% see dynamic_ranks.m or compute_isim.m for more examples
%
% Ryan A. Rossi, Purdue University
% Copyright 2012
%

% load page labels first
load data/wiki-pages

%%
%=================================================
% top vertices of wiki-24h using rk45 w/ s=1
%=================================================
load data/wiki-24hours
load data/wiki-24h-i1-rk45
n = 100; r = 10; Xdis = discretize(X,v);
d = difference_rank(Xdis);
[~,d_rank] = sort(d,'descend');
dpr_timeseries(Xdis, v, d_rank(1:n),'wiki-24h-s1-d100', r, pages)



%%
%=================================================
% top vertices of wiki-24h using rk45 w/ s=4
%=================================================
load data/wiki-24hours
load data/wiki-24h-i4-rk45
n = 100; r = 10; Xdis = discretize(X,v);
d = difference_rank(Xdis);
[~,d_rank] = sort(d,'descend');
dpr_timeseries(Xdis, v, d_rank(1:n),'wiki-24h-s4-d100', r, pages)



%%
%======================================================
% top vertices of wiki-48h using rk45 w/ s=6, theta=1
%======================================================
load data/wiki-48hours
load data/wiki-48h-i6-th10-rk45
n = 100; r = 10; Xdis = discretize(X,v);
d = difference_rank(Xdis);
[~,d_rank] = sort(d,'descend');
dpr_timeseries(Xdis, v, d_rank(1:n),'wiki-48h-s6-d100', r, pages)
