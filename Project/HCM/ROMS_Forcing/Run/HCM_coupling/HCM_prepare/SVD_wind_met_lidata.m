clear
clc
warning off 

Run_dir = ['../../../'];
addpath(Run_dir)
start
% warning off

Data_dir  = ['/public/home/yuyang/Data/SVD_matlab_data'];
Uname     = 'u_svd1980_2000.nc';
Vname     = 'v_svd1980_2000.nc';
Save_dir  = [Run_dir,'/Run/HCM_coupling/MET'];
mkdir(Save_dir)

grd_file  = [Run_dir,'/Data/Grd.nc'];
h         = ncread(grd_file,'h');
lonr      = ncread(grd_file,'lon_rho');
latr      = ncread(grd_file,'lat_rho');
mask      = ncread(grd_file,'mask_rho');
L         = size(mask,1);
M         = size(mask,2);

fileU     = [Data_dir,'/',Uname];
lonU      = ncread(fileU,'Longitude');
latU      = ncread(fileU,'Latitude');
maskU     = ncread(fileU,'mask');
USST_svd  = ncread(fileU,'Leftfield');
UTAU_svd  = ncread(fileU,'Rightfield');
USST_std  = ncread(fileU,'SSTstd');
UTAU_std  = ncread(fileU,'Utaustd');
USST_stdt = ncread(fileU,'SST_stdt');
UTAU_stdt = ncread(fileU,'Utau_stdt');

fileV     = [Data_dir,'/',Vname];
lonV      = ncread(fileV,'Longitude');
latV      = ncread(fileV,'Latitude');
maskV     = ncread(fileV,'mask');
VSST_svd  = ncread(fileV,'Leftfield');
VTAU_svd  = ncread(fileV,'Rightfield');
VSST_std  = ncread(fileV,'SSTstd');
VTAU_std  = ncread(fileV,'Vtaustd');
VSST_stdt = ncread(fileV,'SST_stdt');
VTAU_stdt = ncread(fileV,'Vtau_stdt');

[lonU,latU] = meshgrid(lonU,latU);
[lonV,latV] = meshgrid(lonV,latV);
lonU = lonU';
latU = latU';
lonV = lonV';
latV = latV';

MASKU = griddata(lonr,latr,mask,lonU,latU);
MASKU = MASKU.*maskU;
countU_SVD = sum_2D(MASKU);
MASKU = griddata(lonU,latU,maskU,lonr,latr);
MASKU = MASKU.*mask;
countU_ROMS = sum_2D(MASKU);
RatioU = countU_SVD/countU_ROMS;

MASKV = griddata(lonr,latr,mask,lonV,latV);
MASKV = MASKV.*maskV;
countV_SVD = sum_2D(MASKV);
MASKV = griddata(lonV,latV,maskV,lonr,latr);
MASKV = MASKV.*mask;
countV_ROMS = sum_2D(MASKV);
RatioV = countV_SVD/countV_ROMS;

UAMean = squeeze(sqrt(nanmean(USST_svd.^2,4)));
UAM1   = squeeze(UAMean(:,:,1));
UAM2   = squeeze(UAMean(:,:,2));
UAM3   = squeeze(UAMean(:,:,3));
UAM4   = squeeze(UAMean(:,:,4));
UAM5   = squeeze(UAMean(:,:,5));

VAMean = squeeze(sqrt(nanmean(VSST_svd.^2,4)));
VAM1   = squeeze(VAMean(:,:,1));
VAM2   = squeeze(VAMean(:,:,2));
VAM3   = squeeze(VAMean(:,:,3));
VAM4   = squeeze(VAMean(:,:,4));
VAM5   = squeeze(VAMean(:,:,5));

for month =1:12
    UA1      = squeeze(USST_svd(:,:,1,month));
    UA2      = squeeze(USST_svd(:,:,2,month));
    UA3      = squeeze(USST_svd(:,:,3,month));
    UA4      = squeeze(USST_svd(:,:,4,month));
    UA5      = squeeze(USST_svd(:,:,5,month));
    USIGN1   = sign(mean_2D(UA1.*UAM1));
    USIGN2   = sign(mean_2D(UA2.*UAM2));
    USIGN3   = sign(mean_2D(UA3.*UAM3));
    USIGN4   = sign(mean_2D(UA4.*UAM4));
    USIGN5   = sign(mean_2D(UA5.*UAM5));
    
    VA1      = squeeze(VSST_svd(:,:,1,month));
    VA2      = squeeze(VSST_svd(:,:,2,month));
    VA3      = squeeze(VSST_svd(:,:,3,month));
    VA4      = squeeze(VSST_svd(:,:,4,month));
    VA5      = squeeze(VSST_svd(:,:,5,month));
    VSIGN1   = sign(mean_2D(VA1.*VAM1));
    VSIGN2   = sign(mean_2D(VA2.*VAM2));
    VSIGN3   = sign(mean_2D(VA3.*VAM3));
    VSIGN4   = sign(mean_2D(VA4.*VAM4));
    VSIGN5   = sign(mean_2D(VA5.*VAM5));
    
    USST_M1 = griddata(lonU,latU,UA1,lonr,latr)*USIGN1;
    USST_M2 = griddata(lonU,latU,UA2,lonr,latr)*USIGN2;
    USST_M3 = griddata(lonU,latU,UA3,lonr,latr)*USIGN3;
    USST_M4 = griddata(lonU,latU,UA4,lonr,latr)*USIGN4;
    USST_M5 = griddata(lonU,latU,UA5,lonr,latr)*USIGN5;
    
    VSST_M1 = griddata(lonV,latV,VA1,lonr,latr)*VSIGN1;
    VSST_M2 = griddata(lonV,latV,VA2,lonr,latr)*VSIGN2;
    VSST_M3 = griddata(lonV,latV,VA3,lonr,latr)*VSIGN3;
    VSST_M4 = griddata(lonV,latV,VA4,lonr,latr)*VSIGN4;
    VSST_M5 = griddata(lonV,latV,VA5,lonr,latr)*VSIGN5;

    % weight
    dUdT_W1(:,:,month) = RatioU/USST_std(1)*USST_M1/USST_stdt(1,month)*UTAU_stdt(1,month)*UTAU_std(1);
    dUdT_W2(:,:,month) = RatioU/USST_std(2)*USST_M2/USST_stdt(2,month)*UTAU_stdt(2,month)*UTAU_std(2);
    dUdT_W3(:,:,month) = RatioU/USST_std(3)*USST_M3/USST_stdt(3,month)*UTAU_stdt(3,month)*UTAU_std(3);
    dUdT_W4(:,:,month) = RatioU/USST_std(4)*USST_M4/USST_stdt(4,month)*UTAU_stdt(4,month)*UTAU_std(4);
    dUdT_W5(:,:,month) = RatioU/USST_std(5)*USST_M5/USST_stdt(5,month)*UTAU_stdt(5,month)*UTAU_std(5);

    dVdT_W1(:,:,month) = RatioV/VSST_std(1)*VSST_M1/VSST_stdt(1,month)*VTAU_stdt(1,month)*VTAU_std(1);
    dVdT_W2(:,:,month) = RatioV/VSST_std(2)*VSST_M2/VSST_stdt(2,month)*VTAU_stdt(2,month)*VTAU_std(2);
    dVdT_W3(:,:,month) = RatioV/VSST_std(3)*VSST_M3/VSST_stdt(3,month)*VTAU_stdt(3,month)*VTAU_std(3);
    dVdT_W4(:,:,month) = RatioV/VSST_std(4)*VSST_M4/VSST_stdt(4,month)*VTAU_stdt(4,month)*VTAU_std(4);
    dVdT_W5(:,:,month) = RatioV/VSST_std(5)*VSST_M5/VSST_stdt(5,month)*VTAU_stdt(5,month)*VTAU_std(5);

    % pattern
    dUdT_M1(:,:,month) = griddata(lonU,latU,squeeze(UTAU_svd(:,:,1,month)),lonr,latr)*USIGN1;
    dUdT_M2(:,:,month) = griddata(lonU,latU,squeeze(UTAU_svd(:,:,2,month)),lonr,latr)*USIGN2;
    dUdT_M3(:,:,month) = griddata(lonU,latU,squeeze(UTAU_svd(:,:,3,month)),lonr,latr)*USIGN3;
    dUdT_M4(:,:,month) = griddata(lonU,latU,squeeze(UTAU_svd(:,:,4,month)),lonr,latr)*USIGN4;
    dUdT_M5(:,:,month) = griddata(lonU,latU,squeeze(UTAU_svd(:,:,5,month)),lonr,latr)*USIGN5;

    dVdT_M1(:,:,month) = griddata(lonV,latV,squeeze(VTAU_svd(:,:,1,month)),lonr,latr)*VSIGN1;
    dVdT_M2(:,:,month) = griddata(lonV,latV,squeeze(VTAU_svd(:,:,2,month)),lonr,latr)*VSIGN2;
    dVdT_M3(:,:,month) = griddata(lonV,latV,squeeze(VTAU_svd(:,:,3,month)),lonr,latr)*VSIGN3;
    dVdT_M4(:,:,month) = griddata(lonV,latV,squeeze(VTAU_svd(:,:,4,month)),lonr,latr)*VSIGN4;
    dVdT_M5(:,:,month) = griddata(lonV,latV,squeeze(VTAU_svd(:,:,5,month)),lonr,latr)*VSIGN5;
end

for var_num=1:20
    if var_num==1
        VAR       =  dUdT_M1;
        var_name  = 'dUdT_M1';
        LN        = 'Mod 1 U stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==2
        VAR       =  dUdT_M2;
        var_name  = 'dUdT_M2';
        LN        = 'Mod 2 U stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==3
        VAR       =  dUdT_M3;
        var_name  = 'dUdT_M3';
        LN        = 'Mod 3 U stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==4
        VAR       =  dUdT_M4;
        var_name  = 'dUdT_M4';
        LN        = 'Mod 4 U stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==5
        VAR       =  dUdT_M5;
        var_name  = 'dUdT_M5';
        LN        = 'Mod 5 U stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==6
        VAR       =  dVdT_M1;
        var_name  = 'dVdT_M1';
        LN        = 'Mod 1 V stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==7
        VAR       =  dVdT_M2;
        var_name  = 'dVdT_M2';
        LN        = 'Mod 2 V stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==8
        VAR       =  dVdT_M3;
        var_name  = 'dVdT_M3';
        LN        = 'Mod 3 V stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==9
        VAR       =  dVdT_M4;
        var_name  = 'dVdT_M4';
        LN        = 'Mod 4 V stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==10
        VAR       =  dVdT_M5;
        var_name  = 'dVdT_M5';
        LN        = 'Mod 5 V stress sensitivity to SST';
        UT        = 'newton meter-2';
    elseif var_num==11
        VAR       =  dUdT_W1;
        var_name  = 'dUdT_W1';
        LN        = 'weight in mod 1 U stress sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==12
        VAR       =  dUdT_W2;
        var_name  = 'dUdT_W2';
        LN        = 'weight in mod 2 U stress sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==13
        VAR       =  dUdT_W3;
        var_name  = 'dUdT_W3';
        LN        = 'weight in mod 3 U stress sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==14
        VAR       =  dUdT_W4;
        var_name  = 'dUdT_W4';
        LN        = 'weight in mod 4 U stress sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==15
        VAR       =  dUdT_W5;
        var_name  = 'dUdT_W5';
        LN        = 'weight in mod 5 U stress sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==16
        VAR       =  dVdT_W1;
        var_name  = 'dVdT_W1';
        LN        = 'weight in mod 1 V stress sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==17
        VAR       =  dVdT_W2;
        var_name  = 'dVdT_W2';
        LN        = 'weight in mod 2 V stress sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==18
        VAR       =  dVdT_W3;
        var_name  = 'dVdT_W3';
        LN        = 'weight in mod 3 V stress sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==19
        VAR       =  dVdT_W4;
        var_name  = 'dVdT_W4';
        LN        = 'weight in mod 4 V stress sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==20
        VAR       =  dVdT_W5;
        var_name  = 'dVdT_W5';
        LN        = 'weight in mod 5 V stress sensitivity to SST';
        UT        = 'Celsius-1';
    end
    disp(['Variable: ',var_name])
    disp(['Long Name: ',LN])
    disp(['Unit: ',UT])
    Out_dir = [Save_dir,'/',var_name];
    mkdir(Out_dir)
         
    for NUM = 1:12
        TIME = NUM;
        if TIME<10       
            T_name = ['0',num2str(TIME)];           
            S_name = ['0',num2str(TIME)];            
        else      
            T_name = [num2str(TIME)];           
            S_name = [num2str(TIME)];           
        end       
        S_file = [Out_dir,'/',var_name,'_',S_name,'.nc'];        
        delete(S_file)
        creat_met_file(S_file,var_name,L,M)
        disp(['Date: ',T_name])
        var  = squeeze(VAR(:,:,NUM));
        var(isnan(var))=0;
            
        ncwrite(S_file,'time'         ,TIME)        
        ncwrite(S_file,'lon_r'        ,lonr)        
        ncwrite(S_file,'lat_r'        ,latr)
        ncwrite(S_file,[var_name,'_r'],var)
              
        fileattrib(S_file,'+w');       
        ncwriteatt(S_file,'time','long_name','Time');       
        ncwriteatt(S_file,'time','units','month');        
        ncwriteatt(S_file,'lon_r','long_name','longitude');       
        ncwriteatt(S_file,'lon_r','units','degrees east');       
        ncwriteatt(S_file,'lat_r','long_name','latitude');        
        ncwriteatt(S_file,'lat_r','units','degrees north');        
        ncwriteatt(S_file,[var_name,'_r'],'long name',LN);        
        ncwriteatt(S_file,[var_name,'_r'],'unit',UT);        
        ncwriteatt(S_file,'/','creation_date',datestr(now));

    end
end
