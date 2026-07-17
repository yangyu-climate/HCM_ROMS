clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

Data_dir    = ['/public/home/yuyang/Data/SODA/SODA3.12.2'];
Save_dir    = [pwd,'/Data'];
mkdir(Save_dir)

time_begin  = [2011 1 1 0 0 0];
time_end    = [2016 1 1 0 0 0];
T_buffer    = 5;
T_beg       = datenum(time_begin) - T_buffer;
T_end       = datenum(time_end)   + T_buffer;

H_file      = 'soda';
ref_time    = [1980  1  1 0 0 0];

grd_file    = [Run_dir,'/Data/Grd.nc'];
h           = ncload_2D(grd_file,'h');
lonr        = ncload_2D(grd_file,'lon_rho');
latr        = ncload_2D(grd_file,'lat_rho');
lonu        = ncload_2D(grd_file,'lon_u');
latu        = ncload_2D(grd_file,'lat_u');
lonv        = ncload_2D(grd_file,'lon_v');
latv        = ncload_2D(grd_file,'lat_v');
[Mp,Lp]     = size(h);
L           = Lp-1;
M           = Mp-1;
ddl         = 1;
lon_lim     = [min(min(lonr))-ddl,max(max(lonr))+ddl];
lat_lim     = [min(min(latr))-ddl,max(max(latr))+ddl];


file_name = [H_file,'*.nc'];            
filename  = dir([Data_dir,'/',file_name]);
    
    
if ~isempty(filename)
    for N = 1:length(filename)  
        file_name = filename(N).name;
        fileN = [Data_dir,'/',file_name];  
        T_NUM   = ncload_1D(fileN,'time') + datenum(ref_time);
      if T_NUM>=T_beg&&T_NUM<=T_end
        disp(['Load data from: ',fileN])
        TIME  = datevec(T_NUM);
        time  = T_NUM;
        year  = TIME(1);
        month = TIME(2);
        day   = TIME(3);
        hour  = TIME(4);
        year_num = num2str(year);
        if month<10
            month_num = ['0',num2str(month)];
        else
            month_num = num2str(month);
        end
        if day<10
            day_num = ['0',num2str(day)];
        else
            day_num = num2str(day);
        end
        if hour<10
            hour_num = ['0',num2str(hour)];
        else
            hour_num = num2str(hour);
        end
        T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':00:00'];
        S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-00-00'];
        disp(T_name)   
        
        depth  = ncload_1D(fileN,'st_ocean'); 
        
        Dp     = length(depth);
        S_file = [Save_dir,'/',H_file,'_',S_name,'.nc'];
        delete(S_file)
        creat_oa_file(S_file,Lp,Mp,Dp)
        ncwrite(S_file,'time' ,time)
        ncwrite(S_file,'depth',depth)
        
        %SSH
        var_nam   = 'ssh';
        lon_nam   = 'xt_ocean';
        lat_nam   = 'yt_ocean';
        [x,y,var] = ncload_2D_select(fileN,var_nam,lon_nam,lat_nam,lon_lim,lat_lim);
        var_s     = interp2(x,y,var,lonr,latr)';
        var_s(isnan(var_s))=0;
        ncwrite(S_file,var_nam,var_s)
        clear x y var var_s
        
        %TEMP
        var_nam   = 'temp';
        lon_nam   = 'xt_ocean';
        lat_nam   = 'yt_ocean';
        dep_nam   = 'st_ocean';
        [x,y,var] = ncload_3D_select(fileN,var_nam,lon_nam,lat_nam,dep_nam,lon_lim,lat_lim);
        [x,y]     = meshgrid(x,y);
        for layer = 1:size(var,1)
            var_s(:,:,layer)= interp_ocean(x,y,squeeze(var(layer,:,:)),lonr,latr)';
        end
        ncwrite(S_file,var_nam,var_s)
        clear x y var var_s
        
        %SALT
        var_nam   = 'salt';
        lon_nam   = 'xt_ocean';
        lat_nam   = 'yt_ocean';
        dep_nam   = 'st_ocean';
        [x,y,var] = ncload_3D_select(fileN,var_nam,lon_nam,lat_nam,dep_nam,lon_lim,lat_lim);
        [x,y]     = meshgrid(x,y);
        for layer = 1:size(var,1)
            var_s(:,:,layer)= interp_ocean(x,y,squeeze(var(layer,:,:)),lonr,latr)';
        end
        ncwrite(S_file,var_nam,var_s)
        clear x y var var_s
        
        %U
        var_nam   = 'u';
        lon_nam   = 'xu_ocean';
        lat_nam   = 'yu_ocean';
        dep_nam   = 'st_ocean';
        [x,y,var] = ncload_3D_select(fileN,var_nam,lon_nam,lat_nam,dep_nam,lon_lim,lat_lim);
        for layer = 1:size(var,1)
            var_s(:,:,layer)= interp2(x,y,squeeze(var(layer,:,:)),lonu,latu)';
        end
        var_s(isnan(var_s))=0;
        ncwrite(S_file,var_nam,var_s)
        clear x y var var_s
        
        %V
        var_nam   = 'v';
        lon_nam   = 'xu_ocean';
        lat_nam   = 'yu_ocean';
        dep_nam   = 'st_ocean';
        [x,y,var] = ncload_3D_select(fileN,var_nam,lon_nam,lat_nam,dep_nam,lon_lim,lat_lim);
        for layer = 1:size(var,1)
            var_s(:,:,layer)= interp2(x,y,squeeze(var(layer,:,:)),lonv,latv)';
        end
        var_s(isnan(var_s))=0;
        ncwrite(S_file,var_nam,var_s)
        clear x y var var_s
      end

    end
end
