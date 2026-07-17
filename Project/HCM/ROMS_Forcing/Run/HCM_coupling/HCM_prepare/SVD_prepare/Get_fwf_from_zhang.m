% SVD singular value and vector
clear all
fid = fopen('fort.243','r','b');
data = fread(fid,'float32');
fclose(fid);
data = data(2:end-1);
clear fid

% eign = data(1:4425*20*2);
% eign = reshape(eign,[4425 20 2]);% singular vector
W =data(4425*20*2+1:4425*20*2+4425);% singular value
sdt = data(4425*20*2+4425+1:4425*20*2+4425+40);
sdt = reshape(sdt,[20 2]);%standard deviation of first 20 modes time series
akbk = data(4425*20*2+4425+40+1:4425*20*2+4425+40+360*20*2);% first 20 modes time series
akbk = reshape(akbk,[360 20 2]);
sdv = data(4425*20*2+4425+40+360*20*2+1:end);% spatial mean standard deviation of SLA and Te
clear data
for i = 1:20
for j = 1:2
akbk(:,i,j) = akbk(:,i,j)./sdt(i,j);% Normalised the time series
end
end

% correlation coffeicients of times series
for i = 1:20
RR = corrcoef(akbk(:,i,1),akbk(:,i,2));
R(1,i) = RR(1,2);

end
clear RR i

% calculate the squared covariance fraction 
W2 = W.^2;
Wsum = sum(W2);
SCF = W2./Wsum.*100; clear Wsum
CSCF = cumsum(SCF); clear W2



fid = fopen('E:\FileStorage\Program_else\SVD\FWF\ist1to.dat','r','b');
ist1to = fread(fid,'int32'); ist1to = ist1to(2:end-1);
fclose(fid);
clear fid

fid = fopen('E:\FileStorage\Program_else\SVD\FWF\fort.87','r','b');
data = fread(fid,'float32');
fclose(fid);
data = data(2:end-1);

arr0 = data(8851:97350);arr0 = reshape(arr0,[4425 20]);
brr0 = data(97351:185850);brr0 = reshape(brr0,[4425 20]);
clear fid data

lon_icm=124:2:284;
lat_icm=[-31 -28 -25 -22 -19. -16. -13.75 -12.25 -11.25 -10.5 ...
-10. -9.5 -9. -8.5 -8. -7.5 -7. -6.5 -6. -5.5 -5. -4.5 ...
-4. -3.5 -3. -2.5 -2. -1.5 -1. -0.5 0. 0.5 1. 1.5 ...
2. 2.5 3. 3.5 4. 4.5 5. 5.5 6. 6.5 7. ...
7.5 8. 8.5 9. 9.5 10. 10.5 11.25 12.25 ...
13.75 16. 19. 22 25 28 31];
mask = zeros(134,61);
for i = 1:length(ist1to)
mask(ist1to(i)) = 9999;
end
mask(mask == 0) = nan; ind = isnan(mask);
ind = repmat(ind,[1 1 5]);
left = zeros(134,61,5);% fisrt 5 singular vectors of SL
right = zeros(134,61,5);% fisrt 5 singular vectors of Te
for j = 1:5
left1 = zeros(134,61);
right1 = zeros(134,61);
for i = 1:length(ist1to)

left1(ist1to(i)) = arr0(i,j);
right1(ist1to(i)) = brr0(i,j);
end
left(:,:,j) = left1;
right(:,:,j) = right1;
end
left(ind) = nan;
right(ind) = nan;

singvertor = cat(4,left,right);
clear left rightind i j left1 right1 arr0 brr0
for i = 1:5
singvertor(:,:,i,1) = singvertor(:,:,i,1)./sdt(i,1);
singvertor(:,:,i,2) = singvertor(:,:,i,2)./sdt(i,2); 
end
str = {'mode 1','mode 2','mode 3'};
tit = {'(a) Mode 1: SL, ';'(b) Mode 1: Te, ';'(c) Mode 1: Time series, ';...
'(d) Mode 2: SL, ';'(e) Mode 2: Te, ';'(f) Mode 2: Time series, ';...
'(g) Mode 3: SL, ';'(h) Mode 3: Te, ';'(i) Mode 3: Time series, ' };
idx = linspace(1,64,8);
idx = round(idx);
map = addcolorplus(312); 
C = map(idx,:);
n = 0;
figure
t = tiledlayout(3,3);
t.TileSpacing = 'compact';
t.Padding = 'compact';
for i = 1:3
% Left 
nexttile;
n = n+1;
m_proj('miller','lon',[120 294],'lat',[-30.5 30.5]);
m_contourf(lon_icm,lat_icm,squeeze(singvertor(1:81,:,i,1))'.*100,[-5:0.5:5],'linestyle','none');
caxis([-5 5]);
hold on 
m_plot(lon_icm,zeros(size(lon_icm)),'k--','linewidth',0.8);
m_plot(180.*ones(size(lat_icm)),lat_icm,'k--','linewidth',0.8);
m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_grid('Ytick',[-30:5:30],'fontsize',10,'FontName','Cambria','TickDir', 'out');
colormap(C);
if i ==3 
xlabel('Longitude','fontsize',10,'FontName','Cambria');
end
title([tit{n},'SCF=',num2str(SCF(i),'%.2f'),'%'],'fontsize',10,'FontName','Cambria');

% Right
nexttile;
n = n+1;
m_proj('miller','lon',[120 294],'lat',[-30.5 30.5]);
m_contourf(lon_icm,lat_icm,squeeze(singvertor(1:81,:,i,2))'.*100,[-5:0.5:5],'linestyle','none');
caxis([-5 5]);
hold on 
m_plot(lon_icm,zeros(size(lon_icm)),'k--','linewidth',0.8);
m_plot(180.*ones(size(lat_icm)),lat_icm,'k--','linewidth',0.8);
m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_grid('Ytick',[-30:5:30],'fontsize',10,'FontName','Cambria','TickDir', 'out');
colormap(C);
if i ==3 
xlabel('Longitude','fontsize',10,'FontName','Cambria');
end
title([tit{n},'SCF=',num2str(SCF(i),'%.2f'),'%'],'fontsize',10,'FontName','Cambria');
% Time series
nexttile;
n=n+1;
plot([1:360],akbk(:,i,1),'Color','r','LineWidth',2);%
hold on 
plot([1:360],akbk(:,i,2),'Color','b','LineWidth',2);%

plot([1:1:360],zeros(size([1:1:360])),'k-','MarkerFaceColor',[169,64,71]./255,...
'MarkerEdgeColor',[1,1,1],'LineWidth',2,'MarkerSize',8) 
set(gca,'xtick',[1:24:360]);
set(gca,'xTickLabel',[2004:2:2020]);
title([tit{n},'Corr =',num2str(R(i),'%.2f')],'fontsize',10,'FontName','Cambria');

ylim([-4 4]);xlim([0 360]);
if i ==1
lgd=legend('SLA','Te');
lgd.Location='best';
lgd.FontSize=10;
end

if i == 3
xlabel('Year'); 
end
ax=gca;
ax.LineWidth=1.8;
ax.XMinorTick='on';
ax.YMinorTick='on';
ax.GridLineStyle='-.';
ax.FontName='Cambria';
ax.FontSize=10; 
ax=gca;grid on;box off
ax.YMinorTick='on';
end
% cb = colorbar('ticks',[-4:0.5:4],'ticklabels',[-4:0.5:4],'fontsize',10,'FontName','Cambria');
% cb.Layout.Tile = 'south'



L=squeeze(singvertor(1:81,:,:,1));
R=squeeze(singvertor(1:81,:,:,2));
stdt1=squeeze(sdt(:,1));
stdt2=squeeze(sdt(:,2));
mask2(:,:)=mask(1:81,:);
frcname='C:\Users\LI\Desktop\SVD\svdFWF.nc';
nccreate(frcname,'Longitude'    ,'Dimensions',{'lon'     ,81                                  },'Datatype','double','Format','netcdf4');
nccreate(frcname,'Latitude'     ,'Dimensions',{'lat'     ,61                                  },'Datatype','double','Format','netcdf4');
nccreate(frcname,'mask'         ,'Dimensions',{'x'       ,81  ,'y' ,61                       },'Datatype','double','Format','netcdf4');
nccreate(frcname,'Leftfield'    ,'Dimensions',{'x'       ,81  ,'y' ,61,'mod_num',5},'Datatype','double','Format','netcdf4');
nccreate(frcname,'Rightfield'   ,'Dimensions',{'x'       ,81  ,'y' ,61,'mod_num',5},'Datatype','double','Format','netcdf4');
nccreate(frcname,'SST_stdt'     ,'Dimensions',{'sst_ts'  ,20 ,'time',1             },'Datatype','double','Format','netcdf4');
nccreate(frcname,'FWF_stdt'    ,'Dimensions',{'FWF_ts' ,20  ,'time',1                       },'Datatype','double','Format','netcdf4');
nccreate(frcname,'SSTstd'       ,'Dimensions',{'std_L',1},'Datatype','double','Format','netcdf4');
nccreate(frcname,'FWFstd'       ,'Dimensions',{'std_R'       ,1                                },'Datatype','double','Format','netcdf4');

ncwrite(frcname,'Longitude'  ,lon_icm);
ncwrite(frcname,'Latitude'   ,lat_icm);
ncwrite(frcname,'mask'       ,mask2 );
ncwrite(frcname,'Leftfield'  ,L    );
ncwrite(frcname,'Rightfield' ,R    );
ncwrite(frcname,'SST_stdt'   ,stdt1);
ncwrite(frcname,'FWF_stdt' ,stdt2);
ncwrite(frcname,'SSTstd'     ,0.5551 );
ncwrite(frcname,'FWFstd'   ,2.1399 );


ncwriteatt(frcname,'mask'       ,'long_name','mask'                               );
ncwriteatt(frcname,'Leftfield'  ,'long_name','Leftfield'                          );
ncwriteatt(frcname,'Rightfield' ,'long_name','Rightfield'                         );
ncwriteatt(frcname,'SST_stdt'   ,'long_name','SST_Standard_Timeseries'            );
ncwriteatt(frcname,'FWF_stdt' ,'long_name','FWF_Standard_Timeseries'          );
ncwriteatt(frcname,'SSTstd'     ,'long_name','SST_Standardfield_Spatial_average'  );
ncwriteatt(frcname,'FWFstd'   ,'long_name','FWF_Standardfield_Spatial_average');
ncwriteatt(frcname,'mask'       ,'structure','lat*lon'               );
ncwriteatt(frcname,'Leftfield'  ,'structure','lat*lon*mod');
ncwriteatt(frcname,'Rightfield' ,'structure','lat*lon*mod');
ncwriteatt(frcname,'FWFstd'   ,'structure','lat*lon' );