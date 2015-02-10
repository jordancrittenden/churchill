clear;
format long g;
p = csvread('points.csv');
q = csvread('rects.csv'); % rect.lx, rect.hx, rect.ly, rect.hy, nx, ny, w, h, maxtests, gridchecks, rangechecks, binarychecks

%% calculate shit
r = q;
r(r == -1) = 10000000;
xsort = sort(p(:,2));
ysort = sort(p(:,3));
area = (xsort(9999999)-xsort(2))*(ysort(9999999)-ysort(2));
% rareas = ((r(:,2)-r(:,1)).*(r(:,4)-r(:,3))) / area;
% bareas = r(:,7).*r(:,8);
% rbest = zeros(length(r),1);
% rbest(find(and(r(:,10) < r(:,11), r(:,10) < r(:,12)))) = 1;
% rbest(find(and(r(:,11) < r(:,10), r(:,11) < r(:,12)))) = 2;
% r = [r rareas bareas rbest];
xmin = xsort(2);
xmax = xsort(end-1);
ymin = ysort(2);
ymax = ysort(end-1);
divs = 50;
r = sortrows(r, -5);

%% plot shit
scatter(p(2:100:end,2),p(1:100:end,3),'.')
for i = 1:15
    rectangle('Position',[r(i,1),r(i,3),r(i,2)-r(i,1),r(i,4)-r(i,3)],'EdgeColor','r')
end
for x = xmin:(xmax-xmin)/divs:xmax
    line([x x], [ymin ymax], 'Color', 'g')
end
for y = ymin:(ymax-ymin)/divs:ymax
    line([xmin xmax], [y y], 'Color', 'g')
end
totalchecks = sum(r(:,5));