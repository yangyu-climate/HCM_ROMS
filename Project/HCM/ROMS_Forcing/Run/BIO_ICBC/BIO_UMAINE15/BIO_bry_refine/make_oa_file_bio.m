clear
clc
warning off 

Run_dir = ['../../../../'];
addpath(Run_dir)
start
% warning off
time_beg    = [2011 7 27 0 0 0];
time_end    = [2011 8  9 0 0 0];
time_ref    = [2011 1  0 0 0 0];
time_frq    = 1;
time_shf    = 0.5;

Data_dir    = ['E:\Result\POM_BIO\SSTNG'];
Save_dir    = [pwd,'/Data'];
mkdir(Save_dir)

grd_file    = [Run_dir,'/Data/Grd.nc'];
h           = ncload_2D(grd_file,'h');
lon         = ncread(grd_file,'lon_rho');
lat         = ncread(grd_file,'lat_rho');
[Mp,Lp]     = size(h);

T_beg = datenum(time_beg);
T_end = datenum(time_end);
T_ref = datenum(time_ref);
T_frq = time_frq;

for T = T_beg:T_frq:T_end
    T_num = T-T_ref;
    T_sft = T+time_shf;
    [year_num,month_num,day_num,...
    hour_num,minu_num,seco_num] = date2str(T_sft);
    T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':00:00'];
    S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-00-00'];
    disp(['Date: ',T_name])
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
    %----------------------------------------------------------------------
    varN = 'NO3';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'NH4';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'SiOH';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'PO4';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'nanophytoplankton';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'diatom';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'microzooplankton';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'mesozooplankton';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'detritus';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'opal';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'oxyg';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'Talk';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    varN = 'TIC';
    varC = [];
    varP = ncread(filePN,varN);
    Dp   = size(varP,3);
    for k=1:Dp
    XT   = X;
    YT   = Y;
    VT   = squeeze(varP(:,:,k));
    locT = find(~isnan(VT));
    XT   = XT(locT);
    YT   = YT(locT);
    VT   = VT(locT);
    varC(:,:,k) = griddata(XT,YT,VT,lon,lat);
    end
    S_file = [Save_dir,'/',varN,'_',S_name,'.nc'];
  	delete(S_file)
   	creat_oa_file(S_file,Lp,Mp,Dp)
  	ncwrite(S_file,'time' ,T_sft)
    ncwrite(S_file,'depth',1:Dp)
    ncwrite(S_file,'var'  ,varC)
    %----------------------------------------------------------------------
    
end


