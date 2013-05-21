function save_figure(h, fn, sz)

if nargin < 3,
   sz = 'medium'; 
end

%setupfigs
%set(gca, 'Position', get(gca, 'OuterPosition') - get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);



box off;
%greygrid;
%transfigure;
set_figure_size(h,sz)

%set(gca, 'Position', get(gca, 'OuterPosition') - get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
%set(gcf,'PaperPositionMode','auto')
print('-depsc','-tiff','-r300',[fn, '.eps'])



