function top = rectn(d, r)

top = d(find(and(and(d(:,2)>=r(1),d(:,2)<=r(2)),and(d(:,3)>=r(3),d(:,3)<=r(4)))),:);
top = top(1:20,:);

end

