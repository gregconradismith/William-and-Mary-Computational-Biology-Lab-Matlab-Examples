% Plotting data twice using subplots

n = 50;

x = 1:n;
y{1} = rand(n,1);
y{2} = 10*rand(n,1);

str_size = {'small data example','big data example'}; 

for s=1:2

figure
subplot(2,1,1)
plot(x,y{s},'o-')
ylim([-1 10 ])
grid on
line([0 n],[1 1],'Color','k','LineWidth',2,'LineStyle',':')

subplot(2,1,2)
plot(x,y{s},'o-')
ylim([-1 1])
grid on
line([0 n],[1 1],'Color','k','LineWidth',2,'LineStyle',':')

sgtitle(['subplots  ', str_size{s}])

print(['figure_subplot_' str_size{s} '.png'],'-dpng')
end