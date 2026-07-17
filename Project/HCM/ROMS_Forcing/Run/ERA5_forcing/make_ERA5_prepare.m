clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start

ERA5_forcing_parameter

Data_dir  = [pwd,'/MET'];
Save_dir  = [pwd,'/MET'];

T_beg     = datenum(Time_beg);
T_end     = datenum(Time_end);

% generate 2 metre relative humidity
var_name  = 'rhum';
LN = '2 metre relative humidity';
UT = 'percentage';      
Out_dir = [Save_dir,'/',var_name];
mkdir(Out_dir)
disp([' '])
disp(['Variable: ',var_name])
disp(['Long Name: ',LN])
disp(['Unit: ',UT])
for T=T_beg:Time_frq:T_end
    [year_num,month_num,day_num,...
     hour_num,minu_num,seco_num] = date2str(T);
    T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':00:00'];
    S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-00-00'];
    disp(['Date: ',T_name])
    TIME   = T;
 
    varN   = 't2m';
    fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
    lonr   = ncread(fileN,'lon_r');
    latr   = ncread(fileN,'lat_r');
    L      = size(lonr,1);
    M      = size(lonr,2);
    t2m    = ncread(fileN,[varN,'_r']);
    
    varN   = 'd2m';
    fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
    d2m    = ncread(fileN,[varN,'_r']);
 
%   E  = 6.11 * 10.0 ^ (7.5 * d2m / (237.7 + d2m))    vapor pressure (mb)
%                                                     d2m in Celsius
%
%   Es = 6.11 * 10.0 ^ (7.5 * t2m / (237.7 + t2m))    saturation vapor
%                                                     pressure (mb)
%                                                     t2m in Celsius
    E    = 6.11*10.0.^(7.5*(d2m-237.15)./(d2m));
    Es   = 6.11*10.0.^(7.5*(t2m-237.15)./(t2m));
    varR = 100*(E./Es);
    
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


% generate total rain rate
var_name  = 'prate';
LN = 'total rain rate';
UT = 'kilogram meter-2 second-1';      
Out_dir = [Save_dir,'/',var_name];
mkdir(Out_dir)
disp([' '])
disp(['Variable: ',var_name])
disp(['Long Name: ',LN])
disp(['Unit: ',UT])
for T=T_beg:Time_frq:T_end
    [year_num,month_num,day_num,...
     hour_num,minu_num,seco_num] = date2str(T);
    T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':00:00'];
    S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-00-00'];
    disp(['Date: ',T_name])
    TIME   = T;
 
    varN   = 'crr';
    fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
    lonr   = ncread(fileN,'lon_r');
    latr   = ncread(fileN,'lat_r');
    L      = size(lonr,1);
    M      = size(lonr,2);
    crr    = ncread(fileN,[varN,'_r']);
    
    varN   = 'lsrr';
    fileN  = [Data_dir,'/',varN,'/',varN,'_',S_name,'.nc'];
    lsrr   = ncread(fileN,[varN,'_r']);
  
    varR   = crr+lsrr;
    
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
