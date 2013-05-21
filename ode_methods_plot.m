% compute dynamic pagerank w/ numerical schemes, then plot
% vertex with largest diff rank, for all schemes.
%
% Ryan A. Rossi, Purdue University
% Copyright 2012
%

clear all
setup_paths

name = 'test_graph1k';
load_graph
v = normcols(v);

path = 'web/'; str = 'ode_methods_';
colors = plot_colors();


%% basic example and plot
%

methods = {'forward-Euler', 'Adams (ode113)', 'RK23', 'RK45', 'Richardson iter'};
ts = [1 2 4 8];
ratio = ts/4;

%static pr vert
x = pagerank(A);
[~,r] = sort(x,'descend');
w = r(1);

%diff rank vert
d = difference_rank(v);
[~,d_rank] = sort(d,'descend');
u = d_rank(1:3);

%min-max vert
[val,time] = min(max(v));
y = find(v(:,time) == val);


for i=1:length(ts),
    clear opts dpr_sol X tgrid dpr_sol_rk45 dpr_info_rk45 dpr_sol_rk23 dpr_info_rk23
    clear dpr_sol_euler dpr_info_euler X_rk45 X_rk23 X_rk45s X_rk23s X_adams X_ads
    
    opts = struct('scale',ts(i), 'sample',ratio(i), 'alg', 'rk45');
    [X_rk45 dpr_info_rk45 dpr_sol_rk45] = dynamic_pagerank(A,v,opts);
    
    opts = struct('scale',ts(i), 'sample',ratio(i), 'alg', 'rk23');
    [X_rk23 dpr_info_rk23 dpr_sol_rk23] = dynamic_pagerank(A,v,opts);
    
    opts = struct('scale',ts(i), 'sample',ratio(i), 'alg', 'adams');
    [X_adams dpr_info_adams dpr_sol_adams] = dynamic_pagerank(A,v,opts);
    
    opts = struct('scale',ts(i), 'sample',ratio(i), 'alg', 'rk45-smooth');
    [X_rk45s dpr_info_rk45s dpr_sol_rk45s] = dynamic_pagerank(A,v,opts);
    
    opts = struct('scale',ts(i), 'sample',ratio(i), 'alg', 'rk23-smooth');
    [X_rk23s dpr_info_rk23s dpr_sol_rk23s] = dynamic_pagerank(A,v,opts);
    
    opts = struct('scale',ts(i), 'sample',ratio(i), 'alg', 'adams-smooth');
    [X_ads dpr_info_ads dpr_sol_ads] = dynamic_pagerank(A,v,opts);
    
    
    
    for k=1:3,
        
        X = [X_rk45(u(k),:); X_rk23(u(k),:); X_adams(u(k),:); X_rk45s(u(k),:); X_rk23s(u(k),:); X_ads(u(k),:)];
        verts = 1:size(X,1);
        dpr_verts_plot(X,verts,[path,str,'diff',num2str(k),'_s',num2str(ts(i))]);
    end
    
    X = [X_rk45(w,:); X_rk23(w,:); X_adams(w,:); X_rk45s(w,:); X_rk23s(w,:); X_ads(w,:)];
    verts = 1:size(X,1);
    dpr_verts_plot(X,verts,[path,str,'pr_s',num2str(ts(i))]);
    
    X = [X_rk45(y,:); X_rk23(y,:); X_adams(y,:); X_rk45s(y,:); X_rk23s(y,:); X_ads(y,:)];
    verts = 1:size(X,1);
    dpr_verts_plot(X,verts,[path,str,'minmax_s',num2str(ts(i))]);
    
end





    %     dt = dpr_info_rk45.sample;
    %     tgrid = eps(1) : dt : dpr_info_rk45.tmax;
    %     X_rk45 = deval(dpr_sol_rk45,tgrid);
    %     X_rk23 = deval(dpr_sol_rk23,tgrid);
    %     X_adams = deval(dpr_sol_adams,tgrid);
    %     X_rk45s = deval(dpr_sol_rk45s,tgrid);
    %     X_rk23s = deval(dpr_sol_rk23s,tgrid);
    %     X_ads = deval(dpr_sol_ads,tgrid);


%     opts = struct('scale',ts(i), 'sample',ts(i)/ratio, 'alg', 'euler','h',0.001);
%     [X_euler dpr_info_euler dpr_sol_euler] = dynamic_pagerank(A,v,opts);

%     opts = struct('scale',ts(i), 'sample',ratio(i), 'alg', 'power-euler','h',0.001);
%     [X_power dpr_info_power] = dynamic_pagerank(A,v,opts);
