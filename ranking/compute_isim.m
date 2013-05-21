function compute_isim(data)
% isim experiments
%
% Examples:
%   compute_isim('wiki')
%   compute_isim('twitter')
%
% Ryan A. Rossi, Purdue University
% Copyright 2012
%


setup_paths

if strcmp(data,'wiki'),
    wiki_timescales_48h %use to get initial data, other fields ignored
elseif strcmp(data,'twitter')
    dpr_timescales_twitter
end

db_path = 'data/';
for i=1:2, %since ts2 is at loc 2
    name = graphlist{i,1};
    load_graph
    
    x_name = graphlist{i,2};
    scale = graphlist{i,3}
    
    load([db_path,x_name]);
    
    [d var c] = dynamic_ranks(X);
    indeg = indeg_rank(A);
    
    [v_d v_var v_c v_avg] = dynamic_ranks(v);
    [ pr_uniform pr_avg ] = static_pagerank(A,v_avg);
    
    
    eval = {v_avg, pr_avg, pr_uniform, indeg};
    
    plot_lbl = {'Avg Pageviews', 'PageRank (Avg Pageviews)', 'PageRank (Uniform)', 'In-degree'};
    filenames = {'avg_pageviews', 'pr_avg_pageviews', 'pr_uniform','indegree'};
    rank_labels = {'Difference Rank', 'Cumulative Rank', 'Variance Rank'};
    
    for j=1:length(plot_lbl),
        fprintf('computing intersection similarity for %s \n', plot_lbl{j});
        
        tic
        is_d = isim(d,eval{j});
        is_c = isim(c,eval{j});
        is_var = isim(var,eval{j});
        toc
        
        %title_str = ['timescale = ', num2str(scale)];
        var_fn{i,j} = [db_path,'isim-',name,'-',num2str(i),num2str(j),'-',num2str(scale),'.mat'];
        save(var_fn{i,j},'is_d','is_c','is_var');
        
        fn = [x_name,'-','ts',num2str(scale),'-',filenames{j}]
        isim_plot({is_d,is_c,is_var}, rank_labels, fn);
    end
    
end

save([db_path,'isim-filenames',name,'.mat'],'var_fn');

