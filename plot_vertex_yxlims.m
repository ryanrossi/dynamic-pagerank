%load('data/example_smoothing_data')


%% setup plot
% 
figpath = 'web/'
mkdir(figpath);
fn = 'vertex';
labelSize = 22;

ts = [1 2 6];
theta = [0.1 1 10];
alpha = [0.5 0.85 0.99];
ratio = [0.5 1 3];

label_plots = [1 4 7 10];
lb_ts = [1 2 3]
lb_big = [1 3 5];

n_verts = 15;
sym = {'-','--','-.','-.'};
tmax = 24;

%% make smaller graph
pr = pagerank(A);
[~,rank] = sort(pr,'descend');
verts = rank(1:2000);
A_sm = A(verts,verts);
v_sm = v(verts,:);
v_sm = normcols(v_sm);

%% make step function

for t=1:tmax,
    opts = struct('v',v_sm(:,t));
    pr_static(:,t) = pagerank(A_sm,opts);
end
[~,rank] = sort(pr_static(:,1),'descend');
vertex = rank(1);
lw = 2;
af = 18;

%% 
colors = {rgb('Crimson'), rgb('DodgerBlue'), rgb('LimeGreen'), 'magenta', rgb('SlateGray')}
clear ts_lbl dt tgrid X dpr_info dpr_sol h s xx yy 
h = figure('Visible', 'off');

for i=1:length(ts)
    opts = struct('scale',ts(i), 'sample',ratio(i), 'alg', 'rk45');
    [X dpr_info dpr_sol] = dynamic_pagerank(A_sm,v_sm,opts);
    
    size(X)
    tgrid = 0 : 0.5 : 24;
    plot(tgrid,X(vertex,:),sym{i},'Color',colors{i}, 'LineWidth',lw); hold on;
    ts_lbl{i} = ['s = ',num2str(ts(i))];
end

leg = legend(ts_lbl,'Location','NorthOutside','Orientation','Horizontal');
set(leg,'FontSize',labelSize);
set(leg,'Box','off')

fprintf('hi\n\n');
s = 1 : 1 : 24;
[xx yy] = stairs(s,pr_static(vertex,:));
size(xx)
size(yy)
plot(xx,yy,'Color',colors{5},'LineWidth',lw); hold on;

axis on; box off; grid off;
xlim([0 20])
ylim([.01 0.014])
set(gca,'YTickLabel',{});
set(gca,'XTickLabel',{});
save_fig(h,[figpath,fn,'-',num2str(vertex),'-','ts'],'medium-ls');



clear ts_lbl dt tgrid X dpr_info dpr_sol h s xx yy 
h = figure('Visible', 'off');

for i=1:length(theta)
    opts = struct('scale',2, 'sample',1, 'alg', 'rk45-smooth', 'theta',theta(i));
    [X dpr_info dpr_sol] = dynamic_pagerank(A_sm,v_sm,opts);
    
    tgrid = 0 : 0.5 : 24;
    plot(tgrid,X(vertex,:),sym{i},'Color',colors{i}, 'LineWidth',lw); hold on;
    ts_lbl{i} = ['\theta = ',num2str(theta(i))];
end

hold on;
leg = legend(ts_lbl,'Orientation','Horizontal','Location','NorthOutside');
set(leg,'FontSize',labelSize);
set(leg,'Box','off')


axis on; box off; grid off;
xlim([0 20])
ylim([.01 0.014])
set(gca,'YTickLabel',{});
set(gca,'XTickLabel',{});
set(gca,'FontSize',af)
hold off;
save_fig(h,[figpath,fn,'-',num2str(vertex),'-','theta'],'medium-ls');



clear ts_lbl dt tgrid X dpr_info dpr_sol h s xx yy 
h = figure('Visible', 'off');

colors = {rgb('LimeGreen'),rgb('Crimson'),rgb('DodgerBlue')};
for i=1:length(alpha)
    opts = struct('alpha',alpha(i),'scale',2, 'sample',1, 'alg', 'rk45');
    [X dpr_info dpr_sol] = dynamic_pagerank(A_sm,v_sm,opts);
    
    size(X)
    tgrid = 0 : 0.5 : 24;
    plot(tgrid,X(vertex,:),sym{i},'Color',colors{i}, 'LineWidth',lw); hold on;
    ts_lbl{i} = ['\alpha = ',num2str(alpha(i))];
end

axis on; box off; grid off;
set(gca,'FontSize',af)

if vertex == 1226,
        leg = legend(ts_lbl,'Orientation','Horizontal','Location','NorthOutside');
    set(leg,'fontsize',labelSize);
    set(leg,'box','off')
else
    
    leg = legend(ts_lbl,'Orientation','Horizontal','Location','NorthOutside');
    set(leg,'fontsize',labelSize);
    set(leg,'box','off')
end

xlim([0 20])
ylim([.01 0.014])
set(gca,'YTickLabel',{});
set(gca,'XTickLabel',{});
set(gca,'FontSize',af)
save_fig(h,[figpath,fn,'-',num2str(vertex),'-','alpha'],'medium-ls');
