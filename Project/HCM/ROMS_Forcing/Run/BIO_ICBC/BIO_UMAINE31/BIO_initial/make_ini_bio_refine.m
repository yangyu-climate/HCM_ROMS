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
add_ini_UMaine31(BIO_IniF,'write')
%--------------------------------------------------------------------------
for Name_num = 1:31
if Name_num == 1
    varN = 'NO3';
elseif Name_num == 2
    varN = 'NH4';
elseif Name_num == 3
    varN = 'SiOH';
elseif Name_num == 4
    varN = 'PO4';
elseif Name_num == 5
    varN = 'S1_N';
elseif Name_num == 6
    varN = 'S1_C';
elseif Name_num == 7
    varN = 'S1CH';
elseif Name_num == 8
    varN = 'S2_N';
elseif Name_num == 9
    varN = 'S2_C';
elseif Name_num == 10
    varN = 'S2CH';
elseif Name_num == 11
    varN = 'S3_N';
elseif Name_num == 12
    varN = 'S3_C';
elseif Name_num == 13
    varN = 'S3CH';
elseif Name_num == 14
    varN = 'Z1_N';
elseif Name_num == 15
    varN = 'Z1_C';
elseif Name_num == 16
    varN = 'Z2_N';
elseif Name_num == 17
    varN = 'Z2_C';
elseif Name_num == 18
    varN = 'BAC_';
elseif Name_num == 19
    varN = 'DD_N';
elseif Name_num == 20
    varN = 'DD_C';
elseif Name_num == 21
    varN = 'DDCA';
elseif Name_num == 22
    varN = 'DDSi';
elseif Name_num == 23
    varN = 'LDON';
elseif Name_num == 24
    varN = 'LDOC';
elseif Name_num == 25
    varN = 'SDON';
elseif Name_num == 26
    varN = 'SDOC';
elseif Name_num == 27
    varN = 'CLDN';
elseif Name_num == 28
    varN = 'CSDC';
elseif Name_num == 29
    varN = 'oxyg';
elseif Name_num == 30
    varN = 'Talk';
elseif Name_num == 31
    varN = 'TIC';
end

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
end
%--------------------------------------------------------------------------

