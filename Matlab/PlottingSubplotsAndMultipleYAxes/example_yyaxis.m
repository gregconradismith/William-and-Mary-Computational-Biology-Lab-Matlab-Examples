% Plotting data twice using multiple y axes
% https://www.mathworks.com/help/matlab/creating_plots/plotting-with-two-y-axes.html

n = 50;

x = 1:n;
y{1} = -0.1+rand(n,1);
y{2} = 10*(-0.1+rand(n,1));

str_size = {'small data example','big data example'}; 

for s=1:2

figure
yyaxis left 
plot(x,y{s},'o-')
ylim([-10 20 ])

yyaxis right 
plot(x,y{s},'o-')
ylim([-1 2])
ylabel('10X','Rotation',0)
grid on
line([0 n],[0 0],'Color','k','LineWidth',2,'LineStyle',':')

sgtitle(['yyaxis  ',str_size{s}])

print(['figure_yyaxis_' str_size{s} '.png'],'-dpng')
end