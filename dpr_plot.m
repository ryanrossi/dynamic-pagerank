function dpr_plot(X, v, nodes, str, r, pages)
[n tmax] = size(X);
if nargin < 4,
    r = 5;
end
c = ceil(length(nodes) / r);

h = 200;
w = 150;
if r < c,
    height = (h * r)
    width = (w * c) 
    siz = [1 1 width height]  
else
    height = (h * r)
    width = (w * c) 
    siz = [1 1 width height] 
end

set(0,'DefaultAxesColorOrder',[0.8594    0.0781    0.2344;0.1172    0.5625    1.0000])
set(0,'DefaultAxesLineStyleOrder',{'-','--'})

fig = figure('Position',siz,'XVisual',...
    '0x24 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)');
for i=1:length(nodes),
    h = subaxis(r,c,i,'Holdaxis',0, ...
        'SpacingVertical',0.01,'SpacingHorizontal',0.005, ...
        'PaddingLeft',0,'PaddingRight',0,'PaddingTop',.01,'PaddingBottom',0, ...
        'MarginLeft',.004,'MarginRight',.004,'MarginTop',.004,'MarginBottom',.02, ...
        'rows',[],'cols',[]);
    node_id = nodes(i);
    
    tmp = [];
    tmp = [normalize(full(v(node_id,:))); normalize(full(X(node_id,:)))];
    tmp = full(tmp);
    tmp(tmp < 0) = NaN;
    
    plot(tmp','LineWidth',2);
    
    label = pages{node_id};
    label = strrep(label, 'Category:Wikipedia ', '');
    label = strrep(label, 'Category:', '');
    label = strrep(label, 'Portal:', '');
    label = strrep(label, 'Categories', '');
    label = strrep(label, ' ', '');
    label = char(label);
    
    max_len = 10;
    if length(label) < 10,
        max_len = length(label);
    end
    
    min_value = min(min(tmp(tmp > 0)));
    max_value = max(max(tmp));
    
        color = {'\color{blue}','\color{red}','\color{green}','\color{magenta}','\color{cyan}'};
    text(1,min_value,[color{i},num2str(i), ' ',label(1:max_len)],...
        'FontSize',15,'Color','black','FontWeight', 'bold','HorizontalAlignment','left',...
        'VerticalAlignment','Cap')
    
    axis off
    box off
    grid off
    
    xlim([0 tmax])
    ylim([min_value,max_value])
end

set(gcf,'PaperPositionMode','auto')
datafolder = 'web/';
print('-depsc','-tiff','-r300',strcat(datafolder,'/',str))
hold;
close;
