function replot_isim()

for i=1:2, %since ts2 is at loc 2
    name = graphlist{i,1};
    
    x_name = graphlist{i,2};
    scale = graphlist{i,3}
    
    plot_lbl = {'Avg Pageviews', 'PageRank (Avg Pageviews)', 'PageRank (Uniform)', 'In-degree'};
    filenames = {'avg_pageviews', 'pr_avg_pageviews', 'pr_uniform','indegree'};
    rank_labels = {'Difference Rank', 'Cumulative Rank', 'Variance Rank'};
    
    for j=1:length(plot_lbl),
        load(var_fn{i,j});
        
        fn = [name,'-','ts',num2str(scale),'-f','-',filenames{j}]
        isim_plot({is_d,is_c,is_var}, rank_labels, fn);
    end
    
end
