function add_border(xy,bkgcolor)
% add points to get 
xymin = min(xy);
xymax = max(xy);
xysize = xymax-xymin;
xy1 = xymin-0.05*xysize;
xy2 = xymax+0.05*xysize;
h = plot(xy1(1),xy1(2),'.'); set(h,'Color',bkgcolor);
h = plot(xy2(1),xy2(2),'.'); set(h,'Color',bkgcolor);