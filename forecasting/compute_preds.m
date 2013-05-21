function pdata = compute_preds(data,fn,select)
% Compute preds using Dynamic PageRank for a set of graphs
%
% flexible: - theta,
%           - timescale
%           - alpha
%           - choose norm/detrend/deseason/etc..
%           - dpr can leverage additional samples
%
% Note: should only run this code with 1 timescale at a time
% To run multiple timescales, create seperate process
%

setup_paths

if nargin == 0, data = 'graphs'; end;
if nargin < 2, 
    fn = ''; 
end
idx = 50000; str = '';
graphlist = get_graphlist(data);

name = graphlist{1,1};
load_graph

fprintf('computing x_infty \n');
tic; x_infty = static_pagerank_infty(A,normcols(v));
fprintf('s=infty took % sec to compute \n', toc);

s = graphlist{1,3};
if nargin < 3,
    if size(graphlist,2) >= 10, select = graphlist{1,10};
    else select = 'diff';
    end
end

tic
fprintf('computing rank and loading pageviews');
db_path = 'data/';
if strcmp(name,'twitter'),
    load([db_path,'twitter-i',num2str(s),'-rk45.mat']);
elseif strcmp(name,'wiki-24hours'),
    load([db_path,'wiki-24h-i',num2str(s),'-rk45.mat']);
    load([db_path,'wiki-p24.mat']); %if wiki, use p as v
elseif strcmp(name,'wiki-48hours'),
    load([db_path,'wiki-48h-i',num2str(s),'-rk45.mat']);
    load([db_path,'wiki-p48.mat']);
end
toc

tic
if strcmp('diff',select),
    fprintf('diff \n');
    d = difference_rank(X); %from unsmoothed global
    [~,rank] = sort(d,'descend');
elseif strcmp('first',select),
    rank = 1:size(X,1);
elseif strcmp('rand',select),
    rand = randperm(size(A,2));
    rank = rand; 
else
    pr = pagerank(A);
    [~,rank] = sort(pr, 'descend'); 
end
toc

m        = graphlist{1,7}; 
blocks   = graphlist{1,8};
n = (m*blocks)+m;

if nargin > 1,
   str = fn;
end

v_st = v(rank(idx:(idx+1)+n),:);
v_ns = v(rank(1:n),:);
    
preds = {'stationary','non-stationary'};
results_path = 'forecasting/';
mkdir(results_path)
pdata = containers.Map();
for i=1:size(graphlist,1),
    
    clear vs ps vs_norm ps_norm X_norm avg_smape avg_smape_pnorm avg_smape_vnorm smape smape_pnorm smape_vnorm
    clear avg_smape_ns avg_smape_st
    
    %data info
    info = struct();
    info.name     = graphlist{i,1};
    info.input    = graphlist{i,2};
    info.ode_time = graphlist{i,3};
    info.sample   = graphlist{i,4};
    info.method   = graphlist{i,5};
    info.theta    = graphlist{i,6};
    
    %pred param values
    if size(graphlist,2) >= 10,
        info.m        = graphlist{i,7};
        info.blocks   = graphlist{i,8};
        info.norm     = graphlist{i,9};
        info.select   = graphlist{i,10};
    else
        info.m = 10;
        info.blocks = 1000;
        info.norm = 'default';
        info.select = 'diff';
    end
    
    fprintf('computing preds using %s data \n', info.input);
    
    tic
    load(['data','/',info.input,'.mat'])
    toc
    
    tic
    if mod(size(X,2),2) == 1,
        X(:,1) = []; 
    end
    
    tmax = size(X,2);
    tv_max = size(v,2);
    if tmax > tv_max,
        fprintf('tmax=%d \n',tmax);
        tgrid = 1 : 2 : tmax;
        X = X(:,tgrid);
    end
    toc
    
    % get verts for prediction (reduce size of computations)
    % todo: use all for preds
    X_ns = X(rank(1:n),:);
    X_st = X(rank(idx:(idx+1)+n),:);
    
    
    dv = info.ode_time;                %relationship between dy_sys time and app time
    tv_max = size(v_ns,2);             
    tmax = dv * tv_max;                
    tgrid = 1 : dv : tmax;
    
    tic
    ode_smoother = @(t,y) info.theta*(v_ns(:,ceil((t+eps)/dv))-y); 
    vsol_ns = ode45(ode_smoother, [eps(1),tmax], v_ns(:,1));
    vs_ns = deval(vsol_ns,tgrid);
    toc
    
    tic
    ode_smoother = @(t,y) info.theta*(v_st(:,ceil((t+eps)/dv))-y); 
    vsol_st = ode45(ode_smoother, [eps(1),tmax], v_st(:,1));
    vs_st = deval(vsol_st,tgrid);
    toc
    
    
    size(vs_st)
    size(X_st)
    assert(size(vs_st,2) == size(X_st,2))
    assert(size(vs_ns,2) == size(X_ns,2))
    
    t0 = tic;
    fprintf('starting preds \n');
    for b=1:info.blocks,
        if b == 1,
            nstart = 1;
            nfor = info.m;
        else
            nstart = nstart + info.m;
            nfor = nfor + info.m;
        end
        avg_smape_ns(b,:) = models( X_ns(nstart:nfor,:),vs_ns(nstart:nfor,:), info.m, v_ns(nstart:nfor,:) );
        avg_smape_st(b,:) = models( X_st(nstart:nfor,:),vs_st(nstart:nfor,:), info.m, v_st(nstart:nfor,:) );
    end
    
    
    smape_ns(1,:) = sum(avg_smape_ns) / info.blocks;
    smape_st(1,:) = sum(avg_smape_st) / info.blocks;
    fprintf('\n        \t DPR Model \t Base Model \n');
    fprintf('SMAPE_NS = \t %0.3f \t\t %0.3f  \n', smape_ns);
    fprintf('SMAPE_ST = \t %0.3f \t\t %0.3f  \n', smape_st);
    info.smape_ns   = smape_ns;
    info.smape_st   = smape_st;
    info.runtime = toc(t0)
    fprintf('finished, saving solutions...');
    info
    
    pdata(info.input) = info;
    save([results_path,data,'-i',num2str(info.ode_time),str,'-preds'], 'pdata');
end


for i=1:3,%size(graphlist,1),
    
    clear vs ps vs_norm ps_norm X_norm avg_smape avg_smape_pnorm avg_smape_vnorm smape smape_pnorm smape_vnorm

    %data info
    info = struct();
    info.name     = [graphlist{i,1}];
    info.input    = ['x_infty_',graphlist{i,2}];
    info.ode_time = graphlist{i,3};
    info.sample   = graphlist{i,4};
    info.method   = 'infty';
    info.theta    = graphlist{i,6};
    
    %pred param values
    if size(graphlist,2) >= 10,
        info.m        = graphlist{i,7};
        info.blocks   = graphlist{i,8};
        info.norm     = graphlist{i,9};
        info.select   = graphlist{i,10};
    else
        info.m = 10;
        info.blocks = 1000;
        info.norm = 'default';
        info.select = 'diff';
    end
    
    fprintf('computing preds using %s data \n', info.input);
    % get verts for prediction (reduce size of computations)
    % todo: use all for preds
    x_infty_ns = x_infty(rank(1:n),:);
    x_infty_st = x_infty(rank(idx:(idx+1)+n),:);
    
    
    tmax = size(X,2);
    dv = 20;                           %relationship between dy_sys time and app time
    tv_max = size(v_ns,2);             
    tmax = dv * tv_max;               
    tgrid = 1 : dv : tmax;
    
    tic
    ode_smoother = @(t,y) info.theta*(v_ns(:,ceil((t+eps)/dv))-y); %exp smoothing operator
    vsol = ode45(ode_smoother, [eps(1),tmax], v_ns(:,1));
    vs_ns = deval(vsol,tgrid);
    toc
    
    tic
    ode_smoother = @(t,y) info.theta*(v_st(:,ceil((t+eps)/dv))-y); 
    vsol = ode45(ode_smoother, [eps(1),tmax], v_st(:,1));
    vs_st = deval(vsol,tgrid);
    toc
    
    tic
    fprintf('smoothing x_infty_ns... \n');
    ode_smoother = @(t,y) info.theta*(x_infty_ns(:,ceil((t+eps)/dv))-y); 
    xinfty_ns_sol = ode45(ode_smoother, [eps(1),tmax], x_infty_ns(:,1));
    xinfty_s_ns = deval(xinfty_ns_sol,tgrid);
    toc
    
    tic
    fprintf('smoothing x_infty_st... \n');
    ode_smoother = @(t,y) info.theta*(x_infty_st(:,ceil((t+eps)/dv))-y); 
    xinfty_st_sol = ode45(ode_smoother, [eps(1),tmax], x_infty_st(:,1));
    xinfty_s_st = deval(xinfty_st_sol,tgrid);
    toc
    
    
    t0 = tic;
    fprintf('starting preds \n');
    for b=1:info.blocks,
        if b == 1,
            nstart = 1;
            nfor = info.m;
        else
            nstart = nstart + info.m;
            nfor = nfor + info.m;
        end
        
        tic
        avg_smape_ns(b,:) = models( xinfty_s_ns(nstart:nfor,:),vs_ns(nstart:nfor,:), info.m, v_ns(nstart:nfor,:) )
        toc
        
        tic
        avg_smape_st(b,:) = models( xinfty_s_st(nstart:nfor,:),vs_st(nstart:nfor,:), info.m, v_st(nstart:nfor,:) )
        toc
  
    end
    
    
    smape_ns(1,:) = sum(avg_smape_ns) / info.blocks;
    smape_st(1,:) = sum(avg_smape_st) / info.blocks;
    fprintf('\n        \t DPR Model \t Base Model \n');
    fprintf('SMAPE_NS = \t %0.3f \t\t %0.3f  \n', smape_ns);
    fprintf('SMAPE_ST = \t %0.3f \t\t %0.3f  \n', smape_st);
    info.smape_ns   = smape_ns;
    info.smape_st   = smape_st;
    info.runtime = toc(t0);
    fprintf('finished, saving solutions...');
    info.ode_time = 8; %for s=infty, '8' used only as indicator for print_preds_table.m
    info
    
    pdata(info.input) = info;
    save([results_path,data,'-i',num2str(info.ode_time),str,'-preds'], 'pdata');
    
end