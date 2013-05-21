function isim_plot(isim_vecs, labels, fn)

labelSize = 20;
c = {rgb('DodgerBlue'),rgb('LimeGreen'),rgb('Crimson'),'magenta',rgb('MediumPurple')};
sym = {'-','-.','--','-','-.','--'};

h = figure('Visible', 'off');
n = length(isim_vecs);
for i=1:n,
    semilogx(isim_vecs{i},sym{i},'color',c{i},'LineWidth',3); hold on;
end
leg = legend(labels,1,'Location','NE');
set(leg,'FontSize',labelSize-2)
set(leg,'box','off')

xlim([0 size(isim_vecs{1},1)]);
grid off

set(gca,'fontsize',20)
xlabel('k','fontsize',labelSize+4);
ylabel('Intersection Similarity','fontsize',labelSize);
ylim([-0.05 1.05])

figpath = 'web/';
save_figure(h,[figpath,'isim-',fn],'big');

