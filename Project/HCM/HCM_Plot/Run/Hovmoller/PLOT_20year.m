clear
clc
close all

Run_dir = ['../../'];
addpath(Run_dir)
start

Data_dir  = [pwd,'/Result'];
Case_name = 'SPIN_HCM';
fileN     = [Data_dir,'/',Case_name,'.mat'];
clim      = [-2 2];

month = load_data(fileN,'month');
year  = month/12;
x     = load_data(fileN,'x');
SSTA  = load_data(fileN,'SSTA');
[X,T] = meshgrid(x,year);

plot_loc_x  = 60;
plot_loc_y  = 60;
view_l      = 400;
view_h      = 600;
hFig = figure;
set(hFig, 'Position', [plot_loc_x plot_loc_y view_l view_h]);

[~,h]=contourf(X,T,SSTA,50);

h.LevelStep=0.5;
h.LineStyle='none';

cmp_b2r=ncl_colormap('NCV_blu_red',21);
colormap(hFig,cmp_b2r)
caxis(clim)
c=colorbar;
c.Location='southoutside';
% c.Position(3) = 0.5*c.Position(3); % 更改颜色栏的厚度
% c.Label.String = 'Sea Surface Temperature Anomaly [\circC]';
c.Label.String = '\circC';
c.Label.FontName = 'Arial';
c.Label.FontSize = 10;
% c.Label.FontWeight = 'bold';
% c.Label.Position=pos+[0 2 0]；% 更换
% colorbar('off')

ax=gca;
ax.XTick = 120:30:280;
latstr={'120°E','150°','180°','150°','120°','90°W','60°W'};
ax.XTickLabel=latstr;
ax.YTick = 0:20;

% 将 y 轴刻度标签设置回默认标签
% yticks('auto')
% yticklabels('auto')
ylim([0 20])
xlim([120 280])
xlabel('Longitude','FontSize',12,'FontWeight','bold','FontName','Arial')
ylabel('Model year','FontSize',12,'FontWeight','bold','FontName','Arial')
% xlabel('Longitude','FontSize',12,'FontName','Arial')
% ylabel('Model Years','FontSize',12,'FontName','Arial')

hold on
xline(180,'--');%在 x = 180 处创建一条垂直线
t=title('Sea Surface Temperature Anomaly');
t.FontSize = 12;
t.FontName = 'Arial';
