clear
clc
warning off 

Run_dir = ['../../../../'];
addpath(Run_dir)
start
% warning off
ini_time    = [2011 7 28 0 0 0];
ref_time    = [2011 1  0 0 0 0];

Data_dir    = ['E:\Result\POM_BIO\SSTNG'];
Save_dir    = [pwd,'/Result'];
mkdir(Save_dir)

DYN_IniF    = ['E:\Download\Muifa_BIO\Ini_2011.nc'];
BIO_IniF    = [Save_dir,'/Ini_Bio.nc'];

grd_file    = [Run_dir,'/Data/Grd.nc'];
h           = ncread(grd_file,'h');
lon         = ncread(grd_file,'lon_rho');
lat         = ncread(grd_file,'lat_rho');

T_ini = datenum(ini_time);
T_ref = datenum(ref_time);
T_num = T_ini-T_ref;

[year_num,month_num,day_num,...
hour_num,minu_num,seco_num] = date2str(T_ini);
disp(['Year: ',year_num,' Month: ',month_num,' Day: ',day_num])
if T_num<10
    F_num = ['0000',num2str(T_num)];
elseif T_num<100
    F_num = ['000',num2str(T_num)];   
elseif T_num<1000
    F_num = ['00',num2str(T_num)];   
elseif T_num<10000
    F_num = ['0',num2str(T_num)];   
else    
    F_num = [num2str(T_num)];   
end
file_name = ['avg_',F_num,'.nc'];
filePN    = [Data_dir,'/',file_name];
disp(['Parent Momain Output Name: ',filePN])
X = ncread(filePN,'lon_rho');
Y = ncread(filePN,'lat_rho');

delete(BIO_IniF)
copyfile(DYN_IniF,BIO_IniF)
add_ini_UMaine15(BIO_IniF,'write')
%--------------------------------------------------------------------------
varN = 'NO3';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'NH4';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'SiOH';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'PO4';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'nanophytoplankton';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'diatom';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'microzooplankton';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'mesozooplankton';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'detritus';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'opal';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'chlorophyll1';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'chlorophyll2';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'oxyg';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'Talk';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------
varN = 'TIC';
varC = [];
varP = ncread(filePN,varN);
for k=1:size(varP,3)
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varT = griddata(XT,YT,VT,lon,lat);
    varT(isnan(varT)) = nanmean(nanmean(varT));
    varC(:,:,k) = varT;
end
varC(isnan(varC)) = 0;
ncwrite(BIO_IniF,varN,varC);
%--------------------------------------------------------------------------