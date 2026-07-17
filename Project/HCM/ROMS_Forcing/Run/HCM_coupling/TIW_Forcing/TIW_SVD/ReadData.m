clear;clc
% cd('E:\FileStorage\Matlab\TIW\TIW_SVD');
% load('E:\Tools\colormap\NoWhiteColormap.mat')
fid = fopen('tau_svd_tiw.96','r','b');
icm_svd  = fread(fid,'int32');
fclose(fid);
icm_svd = icm_svd(2:end-1);

m1   = 4383;
ist1 = icm_svd(1:m1);
ist2 = icm_svd(m1+1:m1*2);

fid     = fopen('tau_svd_tiw.96','r','b');
icm_svd = fread(fid,'float32');
fclose(fid);
icm_svd = icm_svd(2:end-1);

arr  = icm_svd(m1*2+1:m1*2+m1*20*2);
arr  = reshape(arr,m1,20,2);
brr  = icm_svd(m1*2+m1*20*2+1:m1*2+m1*20*2+m1*20*2);
brr  = reshape(brr,m1,20,2);
stdv = icm_svd(m1*2+m1*20*2+m1*20*2+1:m1*2+m1*20*2+m1*20*2+20*2);
stdv = reshape(stdv,20,2);
sd   = icm_svd(m1*2+m1*20*2+m1*20*2+20*2+1);
ud   = icm_svd(m1*2+m1*20*2+m1*20*2+20*2+2:end);

lon_icm=124:2:332;
lat_icm=[-31 -28 -25 -22 -19. -16. -13.75 -12.25 -11.25 -10.5 ...
    -10. -9.5 -9. -8.5 -8. -7.5 -7. -6.5 -6. -5.5 -5. -4.5 ...
    -4. -3.5 -3. -2.5 -2. -1.5  -1. -0.5  0. 0.5 1. 1.5 ...
    2. 2.5 3. 3.5 4. 4.5 5. 5.5 6. 6.5 7. ...
    7.5 8. 8.5 9. 9.5 10. 10.5 11.25 12.25 ...
    13.75 16. 19. 22 25 28 31];
mask = zeros(length(lon_icm), length(lat_icm));
mask(ist1) = 1;

figure;
pcolor(lon_icm, lat_icm, mask');
shading flat;

%%
L = nan(105*61,20,2);
R = nan(105*61,20,2);
for i = 1:20
    for j = 1:2
        L(ist1,i,j) = arr(:,i,j);
        R(ist2,i,j) = brr(:,i,j);
    end
end
L = reshape(L,105,61,20,2);
R = reshape(R,105,61,20,2);
%%
figure('Position',[0.4416,0.1176,1.4583,0.8863]*1e3)
t = tiledlayout(3,2);
title(t, 'TIW SVD Modes', 'FontWeight', 'bold', 'FontSize', 14);
subTitles1 = {'SST'' Mode1', 'SST'' Mode2', 'SST'' Mode3'};
subTitles2 = {'Taux'' Mode1', 'Taux'' Mode2', 'Taux'' Mode3'};
for i = 1:3
    nexttile
    m_proj('miller','lon',[124 280],'lat',[-31 31]);
    m_contourf(lon_icm,lat_icm,L(:,:,i,1)',128,'linestyle','none');
    hold on
    m_plot(lon_icm,zeros(size(lon_icm)),'k--','linewidth',0.8);
    m_plot(180.*ones(size(lat_icm)),lat_icm,'k--','linewidth',0.8);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid('Ytick',[-30:10:30],'fontsize',12,'FontName','Cambria','TickDir', 'out');
    colorbar
    colormap(C2)
    caxis([-2,2])
    title(subTitles1{i},'FontWeight','bold','FontSize',12);

    nexttile
    m_proj('miller','lon',[124 280],'lat',[-31 31]);
    m_contourf(lon_icm,lat_icm,R(:,:,i,1)',128,'linestyle','none');
    hold on
    m_plot(lon_icm,zeros(size(lon_icm)),'k--','linewidth',0.8);
    m_plot(180.*ones(size(lat_icm)),lat_icm,'k--','linewidth',0.8);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid('Ytick',[-30:10:30],'fontsize',12,'FontName','Cambria','TickDir', 'out');
    colorbar
    colormap(C2)
    caxis([-0.3,0.3])
    title(subTitles2{i},'FontWeight','bold','FontSize',12);
end
%%
figure('Position',[0.4416,0.1176,1.4583,0.8863]*1e3)
t = tiledlayout(3,2);
title(t, 'TIW SVD Modes', 'FontWeight', 'bold', 'FontSize', 14);
subTitles1 = {'SST'' Mode1', 'SST'' Mode2', 'SST'' Mode3'};
subTitles2 = {'Tauy'' Mode1', 'Tauy'' Mode2', 'Tauy'' Mode3'};
for i = 1:3
    nexttile
    m_proj('miller','lon',[124 280],'lat',[-31 31]);
    m_contourf(lon_icm,lat_icm,L(:,:,i,2)',128,'linestyle','none');
    hold on
    m_plot(lon_icm,zeros(size(lon_icm)),'k--','linewidth',0.8);
    m_plot(180.*ones(size(lat_icm)),lat_icm,'k--','linewidth',0.8);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid('Ytick',[-30:10:30],'fontsize',12,'FontName','Cambria','TickDir', 'out');
    colorbar
    colormap(C2)
    caxis([-2,2])
    title(subTitles1{i},'FontWeight','bold','FontSize',12);

    nexttile
    m_proj('miller','lon',[124 280],'lat',[-31 31]);
    m_contourf(lon_icm,lat_icm,R(:,:,i,2)',128,'linestyle','none');
    hold on
    m_plot(lon_icm,zeros(size(lon_icm)),'k--','linewidth',0.8);
    m_plot(180.*ones(size(lat_icm)),lat_icm,'k--','linewidth',0.8);
    m_coast('patch',[.7 .7 .7],'edgecolor','none');
    m_grid('Ytick',[-30:10:30],'fontsize',12,'FontName','Cambria','TickDir', 'out');
    colorbar
    colormap(C2)
    caxis([-0.3,0.3])
    title(subTitles2{i},'FontWeight','bold','FontSize',12);
end
%% Save
% 定义文件名
SavePath = 'E:\FileStorage\Matlab\TIW\TIW_SVD\Result\';
filename = [SavePath,'TIWSVD.nc']; 

% 创建NetCDF变量
nccreate(filename, 'L', 'Dimensions', {'dim1', m1, 'dim2', 20, 'dim3', 2}, 'Datatype', 'double');
nccreate(filename, 'R', 'Dimensions', {'dim1', m1, 'dim2', 20, 'dim3', 2}, 'Datatype', 'double');
nccreate(filename, 'U', 'Dimensions', {'dim4', 20, 'dim3', 2}, 'Datatype', 'double');
nccreate(filename, 'SSTstd', 'Dimensions', {'dim5', 1}, 'Datatype', 'double');
nccreate(filename, 'Taustd', 'Dimensions', {'dim6', size(ud, 1)}, 'Datatype', 'double');

% 写入数据到NetCDF文件
ncwrite(filename, 'L', arr);
ncwrite(filename, 'R', brr);
ncwrite(filename, 'U', stdv);
ncwrite(filename, 'SSTstd', sd);
ncwrite(filename, 'Taustd', ud);

% 为变量添加备注
ncwriteatt(filename, 'L', 'description', 'Left Field');
ncwriteatt(filename, 'R', 'description', 'Right Field');
ncwriteatt(filename, 'U', 'description', 'ststd');
ncwriteatt(filename, 'SSTstd', 'description', 'Standard Deviation of SST');
ncwriteatt(filename, 'Taustd', 'description', 'Standard Deviation of Tau');
