function dpr_verts_plot(X,verts,fn)

colors = plot_colors(13);
h = figure();

for i=1:length(verts),
    plot(1:size(X,2),X(verts(i),:),'Color',colors{i}, 'LineWidth',1.1); hold on;
end

axis on; box off; grid off;
ylabel('Dynamic PageRank', 'FontSize', 16);
xlabel('time', 'FontSize', 16);

xlim([1 size(X,2)]);
ylim([0 max(max(X(verts,:)))]);

save_figure(h,fn,'medium-ls');

