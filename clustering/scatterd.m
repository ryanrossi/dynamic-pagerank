function scatterd(X, lbl)
[d,n] = size(X);
if nargin == 1, lbl = ones(n,1); end;

color = 'brgmcyk'; m = length(color); c = max(lbl);
sym = ['d', 'o', '^', 's', 'd', '*', '+', '<', '>', 'h',]; w = 1;
figure(gcf); clf; hold on;
switch d
    case 2
        view(2);
        for i = 1:c,
            idc = lbl == i;
            scatter(X(1,idc),X(2,idc),48,sym(i*w),color(mod(i-1,m)+1),'filled');
        end
    case 3
        view(3);
        for i = 1:c,
            idc = lbl == i;
            scatter3(X(1,idc),X(2,idc),X(3,idc),36,sym(i*w),color(mod(i-1,m)+1),'filled');
        end
end
axis equal
grid off; hold off;
