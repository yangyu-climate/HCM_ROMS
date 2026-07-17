clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start

WRF_forcing_parameter

Data_dir  = [pwd,'/MET'];
Save_dir  = [pwd,'/MET'];

T_beg     = datenum(Time_beg);
T_end     = datenum(Time_end);

% generate rain rate
var_name  = 'prate';
LN = 'Precipitation';
UT = 'kilogram meter-2 second-1';      
Out_dir = [Save_dir,'/',var_name];
mkdir(Out_dir)
disp([' '])
disp(['Variable: ',var_name])
disp(['Long Name: ',LN])
disp(['Unit: ',UT])
for T=T_beg:Time_frq:T_end
    if T==T_beg
        TIME   = T;
        [year_num,month_num,day_num,...
        hour_num,minu_num,seco_num] = date2str(T);
        T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':',minu_num,':',seco_num];
        S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-',minu_num,'-',seco_num];
        disp(['Date: ',T_name])
        varN   = 'RAINC';
        fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
        lonr   = ncread(fileN,'lon_r');
        latr   = ncread(fileN,'lat_r');
        L      = size(lonr,1);
        M      = size(lonr,2);
        rainc  = ncread(fileN,[varN,'_r']);
        varN   = 'RAINNC';
        fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
        rainnc = ncread(fileN,[varN,'_r']);
        varR   = (rainc + rainnc);
    else
        TIME   = T;
        [year_num,month_num,day_num,...
        hour_num,minu_num,seco_num] = date2str(T-Time_frq);
        T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':',minu_num,':',seco_num];
        S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-',minu_num,'-',seco_num];
        varN   = 'RAINC';
        fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
        RAINC1 = ncread(fileN,[varN,'_r']);
        varN   = 'RAINNC';
        fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
        RAINNC1= ncread(fileN,[varN,'_r']);
        
        [year_num,month_num,day_num,...
        hour_num,minu_num,seco_num] = date2str(T);
        T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':',minu_num,':',seco_num];
        S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-',minu_num,'-',seco_num];
        disp(['Date: ',T_name])
        varN   = 'RAINC';
        fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
        lonr   = ncread(fileN,'lon_r');
        latr   = ncread(fileN,'lat_r');
        L      = size(lonr,1);
        M      = size(lonr,2);
        RAINC2 = ncread(fileN,[varN,'_r']);
        varN   = 'RAINNC';
        fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
        RAINNC2= ncread(fileN,[varN,'_r']);
        
        rainc  = RAINC2 -RAINC1;
        rainnc = RAINNC2-RAINNC1;
        varR   = (rainc + rainnc);
    end
    
    varR = varR/(Time_frq*24*60*60);    % mm / 1000mm/m * 1000kg/m3 / T(s)
    
    S_file = [Out_dir,'/',var_name,'_',S_name,'.nc'];
    delete(S_file)
    creat_met_fileR(S_file,var_name,L,M)
    
    ncwrite(S_file,'time'         ,TIME)
    ncwrite(S_file,'lon_r'        ,lonr)
    ncwrite(S_file,'lat_r'        ,latr)
    ncwrite(S_file,[var_name,'_r'],varR)
   
    fileattrib(S_file,'+w');
    ncwriteatt(S_file,'time','long name','Time');           
    ncwriteatt(S_file,'time','unit','days since 0000-00-00');   
    ncwriteatt(S_file,'lon_r','long name','longitude');    
    ncwriteatt(S_file,'lon_r','unit','degrees east');
    ncwriteatt(S_file,'lat_r','long name','latitude');
    ncwriteatt(S_file,'lat_r','unit','degrees north');
    ncwriteatt(S_file,[var_name,'_r'],'long name',LN);
    ncwriteatt(S_file,[var_name,'_r'],'unit',UT);
    ncwriteatt(S_file,'/','creation_date',datestr(now));
end
