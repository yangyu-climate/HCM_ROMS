clear
clc
warning off 

Run_dir = ['../../../'];
addpath(Run_dir)
start
% warning off

Data_dir  = [pwd,'/SVD_prepare'];
file_name = 'SVD_fwf.mat';
Save_dir  = [Run_dir,'/Run/HCM_coupling/MET'];
mkdir(Save_dir)

grd_file  = [Run_dir,'/Data/Grd.nc'];
h         = ncread(grd_file,'h');
lonr      = ncread(grd_file,'lon_rho');
latr      = ncread(grd_file,'lat_rho');
lonu      = ncread(grd_file,'lon_u');
latu      = ncread(grd_file,'lat_u');
lonv      = ncread(grd_file,'lon_v');
latv      = ncread(grd_file,'lat_v');
mask      = ncread(grd_file,'mask_rho');
L         = size(mask,1);
M         = size(mask,2);


fileN     = [Data_dir,'/',file_name];
lon_svd   = load_data(fileN,'lon');
lat_svd   = load_data(fileN,'lat');
mask_svd  = load_data(fileN,'mask');
A_svd     = load_data(fileN,'A');
W_svd     = load_data(fileN,'W');
SD12      = load_data(fileN,'SD12');
WD12      = load_data(fileN,'WD12');
STD12     = load_data(fileN,'STD12');

mask(find(mask==0)) = NaN;
mask_svd(find(mask_svd==0)) = NaN;

MASK = griddata(lonr,latr,mask,lon_svd,lat_svd);
MASK = MASK.*mask_svd;
MASK(~isnan(MASK))=1;
count_SVD  = ceil(sum_2D(MASK));
MASK = griddata(lon_svd,lat_svd,mask_svd,lonr,latr);
MASK = MASK.*mask;
MASK(~isnan(MASK))=1;
count_ROMS = ceil(sum_2D(MASK));
Ratio = count_SVD/count_ROMS;

AMean = squeeze(sqrt(nanmean(A_svd.^2,4)));
AM1   = squeeze(AMean(:,:,1));
AM2   = squeeze(AMean(:,:,2));
AM3   = squeeze(AMean(:,:,3));
AM4   = squeeze(AMean(:,:,4));
AM5   = squeeze(AMean(:,:,5));

for month =1:12
    A1      = squeeze(A_svd(:,:,1,month));
    A2      = squeeze(A_svd(:,:,2,month));
    A3      = squeeze(A_svd(:,:,3,month));
    A4      = squeeze(A_svd(:,:,4,month));
    A5      = squeeze(A_svd(:,:,5,month));
    SIGN1   = sign(mean_2D(A1.*AM1));
    SIGN2   = sign(mean_2D(A2.*AM2));
    SIGN3   = sign(mean_2D(A3.*AM3));
    SIGN4   = sign(mean_2D(A4.*AM4));
    SIGN5   = sign(mean_2D(A5.*AM5));

    MASK    = griddata(lonr,latr,mask,lon_svd,lat_svd);
    MASK_SVD= zeros(size(mask));
    for i=1:size(A_svd,1)
        for j=1:size(A_svd,2)
            if ~isnan(MASK(i,j))
                x    = lon_svd(i,j);
                y    = lat_svd(i,j);
                dist = sqrt((lonr-x).^2+(latr-y).^2);
                loc = find(dist==nanmin(nanmin(dist)));
                MASK_SVD(loc) = 1;
            end
        end
    end
    
    dSST_M1 = griddata(lon_svd,lat_svd,A1,lonr,latr).*MASK_SVD*SIGN1;
    dSST_M2 = griddata(lon_svd,lat_svd,A2,lonr,latr).*MASK_SVD*SIGN2;
    dSST_M3 = griddata(lon_svd,lat_svd,A3,lonr,latr).*MASK_SVD*SIGN3;
    dSST_M4 = griddata(lon_svd,lat_svd,A4,lonr,latr).*MASK_SVD*SIGN4;
    dSST_M5 = griddata(lon_svd,lat_svd,A5,lonr,latr).*MASK_SVD*SIGN5;
    
    dSST_W1 = dSST_M1/SD12(month)/STD12(1,month)/STD12(1,month);
    dSST_W2 = dSST_M2/SD12(month)/STD12(2,month)/STD12(2,month);
    dSST_W3 = dSST_M3/SD12(month)/STD12(3,month)/STD12(3,month);
    dSST_W4 = dSST_M4/SD12(month)/STD12(4,month)/STD12(4,month);
    dSST_W5 = dSST_M5/SD12(month)/STD12(5,month)/STD12(5,month);

    % weight
    dWdT_W1(:,:,month) = dSST_W1*WD12(month);
    dWdT_W2(:,:,month) = dSST_W2*WD12(month);
    dWdT_W3(:,:,month) = dSST_W3*WD12(month);
    dWdT_W4(:,:,month) = dSST_W4*WD12(month);
    dWdT_W5(:,:,month) = dSST_W5*WD12(month);

    % pattern
    dWdT_M1(:,:,month) = griddata(lon_svd,lat_svd,squeeze(W_svd(:,:,1,month)),lonr,latr)*SIGN1;
    dWdT_M2(:,:,month) = griddata(lon_svd,lat_svd,squeeze(W_svd(:,:,2,month)),lonr,latr)*SIGN2;
    dWdT_M3(:,:,month) = griddata(lon_svd,lat_svd,squeeze(W_svd(:,:,3,month)),lonr,latr)*SIGN3;
    dWdT_M4(:,:,month) = griddata(lon_svd,lat_svd,squeeze(W_svd(:,:,4,month)),lonr,latr)*SIGN4;
    dWdT_M5(:,:,month) = griddata(lon_svd,lat_svd,squeeze(W_svd(:,:,5,month)),lonr,latr)*SIGN5;

end

for var_num=1:10
    if var_num==1
        VAR       =  dWdT_M1;
        var_name  = 'dWdT_M1';
        LN        = 'Mod 1 water flux sensitivity to SST';
        UT        = 'centimeter day-1';
    elseif var_num==2
        VAR       =  dWdT_M2;
        var_name  = 'dWdT_M2';
        LN        = 'Mod 2 water flux sensitivity to SST';
        UT        = 'centimeter day-1';
    elseif var_num==3
        VAR       =  dWdT_M3;
        var_name  = 'dWdT_M3';
        LN        = 'Mod 3 water flux sensitivity to SST';
        UT        = 'centimeter day-1';
    elseif var_num==4
        VAR       =  dWdT_M4;
        var_name  = 'dWdT_M4';
        LN        = 'Mod 4 water flux sensitivity to SST';
        UT        = 'centimeter day-1';
    elseif var_num==5
        VAR       =  dWdT_M5;
        var_name  = 'dWdT_M5';
        LN        = 'Mod 5 water flux sensitivity to SST';
        UT        = 'centimeter day-1';
    elseif var_num==6
        VAR       =  dWdT_W1;
        var_name  = 'dWdT_W1';
        LN        = 'weight in mod 1 water flux sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==7
        VAR       =  dWdT_W2;
        var_name  = 'dWdT_W2';
        LN        = 'weight in mod 2 water flux sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==8
        VAR       =  dWdT_W3;
        var_name  = 'dWdT_W3';
        LN        = 'weight in mod 3 water flux sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==9
        VAR       =  dWdT_W4;
        var_name  = 'dWdT_W4';
        LN        = 'weight in mod 4 water flux sensitivity to SST';
        UT        = 'Celsius-1';
    elseif var_num==10
        VAR       =  dWdT_W5;
        var_name  = 'dWdT_W5';
        LN        = 'weight in mod 5 water flux sensitivity to SST';
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
