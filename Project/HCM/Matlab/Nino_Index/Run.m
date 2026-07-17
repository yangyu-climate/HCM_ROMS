clear
clc

Run_dir = ['../'];
addpath(Run_dir);
start
warning off
%----------------------------------------------------------------
Case_nam = 'ALPHA_TAU1.5_FWF1.0';
Data_dir = ['/public/home/yuyang/Clark/application/HCM/Result/Zdata/OCM/EXP_FWF/',Case_nam];
Clim_dir = Data_dir;
Save_dir = [pwd,'/Result'];
if ~exist(Save_dir,'dir')
mkdir(Save_dir)
end

lon_lim  = [190 240];
lat_lim  = [-5 5];

Y_limit  = 30;
M_limit  = [1:12*Y_limit];

for M = 1:length(M_limit)
    month(M) = M_limit(M);
    YYY      = ceil(M_limit(M)/12);
    MMM      = mod(M_limit(M),12);
    if YYY<10
      year_num = ['000',num2str(YYY)];
    elseif YYY<100
      year_num = ['00',num2str(YYY)];
    elseif YYY<1000
      year_num = ['0',num2str(YYY)];
    else
      year_num = [num2str(YYY)];
    end
    if MMM==0
       MMM=12;
    end
    if MMM<10
      month_num = ['0',num2str(MMM)];
    else
      month_num = [num2str(MMM)];
    end

    fileN = [Data_dir,'/DIA_',year_num,'-',month_num,'.nc'];
    fileC = [Clim_dir,'/CLM_',month_num,'.nc'];
    disp(['File: ',fileN]);
    lon   = ncload_2D(fileN,'lon');
    lat   = ncload_2D(fileN,'lat');
    tempN = ncload_3D(fileN,'temp');
    tempC = ncload_3D(fileC,'temp');
    SSTN  = squeeze(tempN(1,:,:));
    SSTC  = squeeze(tempC(1,:,:));
    SSTA  = SSTN-SSTC;
    clear tempN tempC SSTN SSTC

    loc = find(lon>=min(lon_lim)...
              &lon<=max(lon_lim)...
              &lat>=min(lat_lim)...
              &lat<=max(lat_lim));

    varSSTA(M)=nanmean(SSTA(loc));
end

SSTA = varSSTA;

save([Save_dir,'/',Case_nam,'.mat'],'month','SSTA')


