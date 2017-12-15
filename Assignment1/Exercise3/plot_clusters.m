function plot_clusters(Data,Labels,name)
Data = reshape(Data, [600 3]);
colors = ['b','k','r','g','m','y','c'];
figure('name',name)
hold on
for i=1:7
    plot3(Data((Labels ==i),1),Data((Labels ==i),2),Data((Labels ==i),3),'x','color',colors(i))
end
print(name,'-dpng')
end