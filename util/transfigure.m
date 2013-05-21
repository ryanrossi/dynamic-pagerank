function transfigure(f)
% Make a figure have a transparent background
% Todo handle all axes, take input f

set(gca,'Color','none');
set(gcf, 'Color', 'none');
set(gcf,'InvertHardcopy','off');

