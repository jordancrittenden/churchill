p = csvread('points.csv');
r = csvread('rects.csv');

%% calculate shit
xsort = sort(p(:,2));
ysort = sort(p(:,3));
r = sortrows(r, -5);
area = (xsort(9999999)-xsort(2))*(ysort(9999999)-ysort(2));
rareas = ((r(:,2)-r(:,1)).*(r(:,4)-r(:,3))) / area;
r = [r rareas];
xmin = xsort(2);
xmax = xsort(end-1);
ymin = ysort(2);
ymax = ysort(end-1);
divs = 50;

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