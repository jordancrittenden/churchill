p = csvread('points.csv');
r = csvread('rects.csv');
xsort = sort(p(:,2));
ysort = sort(p(:,3));
r = sortrows(r, -5);

%% plot shit
scatter(p(1:100:end,2),p(1:100:end,3))
for i = 1:1
    rectangle('Position',[r(i,1),r(i,3),r(i,2)-r(i,1),r(i,4)-r(i,3)],'EdgeColor','r')
end