clear
clc

Run_dir = ['../'];
addpath(Run_dir);
start
warning off
%----------------------------------------------------------------
Case_nam = 'ALPHA_TAU1.5_FWF1.0';
Data_dir = ['/public/home/yuyang/Clark/application/HCM/Result/original/OCM/EXP_FWF/',Case_nam];
Zlev_dir = ['/public/home/yuyang/Clark/application/HCM/Result/Zdata/OCM/EXP_FWF/',Case_nam];
Clim_dir = ['/public/home/yuyang/Clark/application/HCM/Result/Zdata/OCM/CLM_AVG'];
fil_hard = 'avg';
Save_dir = [pwd,'/Result'];
if ~exist(Save_dir,'dir')
mkdir(Save_dir)
end

dlat     = 0.5;

Y_limit  = 30;
M_limit  = [1:12*Y_limit];

for M = 1:length(M_limit)
    month(M) = M_limit(M);
    NUM      = M;
    YYY      = ceil(M_limit(M)/12);
    MMM      = mod(M_limit(M),12);
    if NUM<10
      num = ['0000',num2str(NUM)];
    elseif NUM<100
      num = ['000',num2str(NUM)];
    elseif NUM<1000
      num = ['00',num2str(NUM)];
    elseif NUM<10000
      num = ['0',num2str(NUM)];
    elseif NUM<100000
      num = [num2str(NUM)];
    end
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

    fileN = [Data_dir,'/',fil_hard,'_',num,'.nc'];
    fileC = [Clim_dir,'/CLM_',month_num,'.nc'];
    fileZ = [Zlev_dir,'/DIA_',year_num,'-',month_num,'.nc'];
    disp(['File: ',fileN]);
    lon   = ncload_2D(fileN,'lon_rho');
    lat   = ncload_2D(fileN,'lat_rho');
    lonU  = ncload_2D(fileN,'lon_u');
    latU  = ncload_2D(fileN,'lat_u');
    lonV  = ncload_2D(fileN,'lon_v');
    latV  = ncload_2D(fileN,'lat_v');
    mask  = ncload_2D(fileN,'mask_rho');
    mask(find(mask==0))=NaN;
    SSTA  = ncload_2D(fileN,'SSTA');
    saltF = ncload_3D(fileZ,'salt');
    saltC = ncload_3D(fileC,'salt');
    saltA = saltF-saltC;
    SSSA  = squeeze(saltA(end,:,:));
    sustrA= ncload_2D(fileN,'sustrA');
    sustrA= griddata(lonU,latU,sustrA,lon,lat);
    svstrA= ncload_2D(fileN,'svstrA');
    svstrA= griddata(lonV,latV,svstrA,lon,lat);
    shflxF= ncload_2D(fileZ,'shflux');
    shflxC= ncload_2D(fileC,'shflux');
    shflxA= shflxF-shflxC;
    evapF = ncload_2D(fileZ,'evap');
    evapC = ncload_2D(fileC,'evap');
    evapA = evapF-evapC;
    rainF = ncload_2D(fileZ,'rain');
    rainC = ncload_2D(fileC,'rain');
    rainA = rainF-rainC;
    swflxA= evapA-rainA;
    zetaF = ncload_2D(fileZ,'zeta');
    zetaC = ncload_2D(fileC,'zeta');
    zetaA = zetaF-zetaC;
    SSTA  =  SSTA.*mask;
    SSSA  =  SSSA.*mask;
    zetaA = zetaA.*mask;
    for i=1:size(SSTA,2)
        LAT=squeeze(lat(:,i));
        loc=find(abs(LAT)<=dlat);
        x(i)=nanmean(lon(loc,i));
        y(i)=nanmean(lat(loc,i));
        Vssta(i)=nanmean(SSTA(loc,i));
        Vsssa(i)=nanmean(SSSA(loc,i));
        Vustr(i)=nanmean(sustrA(loc,i));
        Vvstr(i)=nanmean(svstrA(loc,i));
	    Vheat(i)=nanmean(shflxA(loc,i));
	    Vswfx(i)=nanmean(swflxA(loc,i));
	    Vevap(i)=nanmean(evapA(loc,i));
	    Vrain(i)=nanmean(rainA(loc,i));
        Vzeta(i)=nanmean(zetaA(loc,i));
    end
    varSSTA(NUM,:)=Vssta;
    varSSSA(NUM,:)=Vsssa;
    varUSTR(NUM,:)=Vustr;
    varVSTR(NUM,:)=Vvstr;
    varHEAT(NUM,:)=Vheat;
    varSWFX(NUM,:)=Vswfx;
    varEVAP(NUM,:)=Vevap;
    varRAIN(NUM,:)=Vrain;
    varZETA(NUM,:)=Vzeta;
end

SSTA    = varSSTA;
SSSA    = varSSSA;
sustrA  = varUSTR;
svstrA  = varVSTR;
shfluxA = varHEAT;
swfluxA = varSWFX;
evapA   = varEVAP;
rainA   = varRAIN;
zetaA   = varZETA;

save([Save_dir,'/',Case_nam,'.mat'],'month','x','y','SSTA','SSSA','sustrA','svstrA','shfluxA','swfluxA','evapA','rainA','zetaA')


