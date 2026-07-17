clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

HYCOM_Ini_parameter

Save_dir    = [pwd,'/Data'];
mkdir(Save_dir)

H_file      = 'hycom';
ref_time    = [2000 1 1 0 0 0];

grd_file    = [Run_dir,'/Data/Grd.nc'];
h           = ncload_2D(grd_file,'h');
lonr        = ncload_2D(grd_file,'lon_rho');
latr        = ncload_2D(grd_file,'lat_rho');
lonu        = ncload_2D(grd_file,'lon_u');
latu        = ncload_2D(grd_file,'lat_u');
lonv        = ncload_2D(grd_file,'lon_v');
latv        = ncload_2D(grd_file,'lat_v');
pm          = ncload_2D(grd_file,'pm');
pn          = ncload_2D(grd_file,'pn');
% Get ROMS averaged resolution
dx=mean(mean(1./pm));
dy=mean(mean(1./pn));
dx_roms=mean([dx dy]);
disp([' ROMS resolution : ',num2str(dx_roms/1000,3),' km'])

[Mp,Lp]     = size(h);
L           = Lp-1;
M           = Mp-1;
ddl         = 1;
lon_lim     = [min(min(lonr))-ddl,max(max(lonr))+ddl];
lat_lim     = [min(min(latr))-ddl,max(max(latr))+ddl];

T_ini = Ini_time;
time  = datenum(T_ini);
year  = T_ini(1);
month = T_ini(2);
day   = T_ini(3);
hour  = T_ini(4);
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
H_name = [year_num,month_num,day_num,hour_num];

if IF_Separate
file_name = [H_file,'*',H_name,'*',add_to_ssh,'.nc'];
else
file_name = [H_file,'*',H_name,'*.nc'];
end          
filename  = dir([Data_dir,'/',file_name]);    
    
if ~isempty(filename)
    for N = 1:length(filename)  
        file_name = filename(N).name;
        if IF_Separate
        file_name = file_name(1:end-length([add_to_ssh,'.nc']));
        fileN = [Data_dir,'/',file_name,add_to_ssh,'.nc'];
        else
        file_name = file_name(1:end-length(['.nc']));
        fileN = [Data_dir,'/',file_name,'.nc'];
        end
        T_NUM   = ncload_1D(fileN,'time');
        T_NUM   = T_NUM/24; % hour to day
        T_NUM   = T_NUM  + datenum(ref_time);
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
        disp([' '])   
        disp(['Date: ',T_name])   
        
        %Depth
        if IF_Separate
        fileN  = [Data_dir,'/',file_name,add_to_temp,'.nc'];
        else
        fileN  = [Data_dir,'/',file_name,'.nc'];
        end
        depth  = ncload_1D(fileN,'depth'); 
        
        %create oa file
        Dp     = length(depth);
        S_file = [Save_dir,'/',H_file,'_',S_name,'.nc'];
        delete(S_file)
        creat_oa_file(S_file,Lp,Mp,Dp)
        ncwrite(S_file,'time' ,time)
        ncwrite(S_file,'depth',depth)

        %SSH
        if IF_Separate
        fileN = [Data_dir,'/',file_name,add_to_ssh,'.nc'];
        else
        fileN = [Data_dir,'/',file_name,'.nc'];
        end
        disp([' '])
        disp(['SSH: '])
        disp(['File: ',fileN])
        var_nam   = 'surf_el';
        lon_nam   = 'lon';
        lat_nam   = 'lat';
        wrt_nam   = 'ssh';
        x         = ncload_2D(fileN,lon_nam);
        y         = ncload_2D(fileN,lat_nam);
        var       = ncload_2D(fileN,var_nam); 
        x         =[x-360;x;x+360];
        var       =[var,var,var];
        [x,y,var] = upscale2D(x,y,var,dx_roms);
        var_s     = interp2(x,y,var,lonr,latr)';
        var_s(isnan(var_s))=0;
        ncwrite(S_file,wrt_nam,var_s)
        clear x y var var_s
      
        %TEMP
        if IF_Separate
        fileN = [Data_dir,'/',file_name,add_to_temp,'.nc'];
        else
        fileN = [Data_dir,'/',file_name,'.nc'];
        end
        disp([' '])
        disp(['Temperature: '])
        disp(['File: ',fileN])
        var_nam   = 'water_temp';
        lon_nam   = 'lon';
        lat_nam   = 'lat';
        dep_nam   = 'depth';
        wrt_nam   = 'temp';
        X         = ncload_3D(fileN,lon_nam);
        Y         = ncload_3D(fileN,lat_nam);
        VAR       = ncload_3D(fileN,var_nam);
        for layer = 1:size(VAR,1)
            disp(['Processing Layer :',num2str(layer)])
            x         = X;
            y         = Y;
            var       = squeeze(VAR(layer,:,:));
            x         =[x-360;x;x+360];
            var       =[var,var,var];
            [x,y,var] = upscale2D(x,y,var,dx_roms);
            [x,y]     = meshgrid(x,y);
            var_s(:,:,layer)= interp_ocean(x,y,var,lonr,latr)';
        end
        ncwrite(S_file,wrt_nam,var_s)
        clear x y var var_s
        
        %SALT
        if IF_Separate
        fileN = [Data_dir,'/',file_name,add_to_salt,'.nc'];
        else
        fileN = [Data_dir,'/',file_name,'.nc'];
        end
        disp([' '])
        disp(['Salinity: '])
        disp(['File: ',fileN])
        var_nam   = 'salinity';
        lon_nam   = 'lon';
        lat_nam   = 'lat';
        dep_nam   = 'depth';
        wrt_nam   = 'salt';
        X         = ncload_3D(fileN,lon_nam);
        Y         = ncload_3D(fileN,lat_nam);
        VAR       = ncload_3D(fileN,var_nam);
        for layer = 1:size(VAR,1)
            disp(['Processing Layer :',num2str(layer)])
            x         = X;
            y         = Y;
            var       = squeeze(VAR(layer,:,:));
            x         =[x-360;x;x+360];
            var       =[var,var,var];
            [x,y,var] = upscale2D(x,y,var,dx_roms);
            [x,y]     = meshgrid(x,y);
            var_s(:,:,layer)= interp_ocean(x,y,var,lonr,latr)';
        end
        ncwrite(S_file,wrt_nam,var_s)
        clear x y var var_s
       
        %U
        if IF_Separate
        fileN = [Data_dir,'/',file_name,add_to_u,'.nc'];
        else
        fileN = [Data_dir,'/',file_name,'.nc'];
        end
        disp([' '])
        disp(['Eastward current: '])
        disp(['File: ',fileN])
        var_nam   = 'water_u';
        lon_nam   = 'lon';
        lat_nam   = 'lat';
        dep_nam   = 'depth';
        wrt_nam   = 'u';
        X         = ncload_3D(fileN,lon_nam);
        Y         = ncload_3D(fileN,lat_nam);
        VAR       = ncload_3D(fileN,var_nam);
        for layer = 1:size(VAR,1)
            disp(['Processing Layer :',num2str(layer)])
            x         = X;
            y         = Y;
            var       = squeeze(VAR(layer,:,:));
            x         =[x-360;x;x+360];
            var       =[var,var,var];
            [x,y,var] = upscale2D(x,y,var,dx_roms);
            var_s(:,:,layer)= interp2(x,y,var,lonu,latu)';
        end
        var_s(isnan(var_s))=0;
        ncwrite(S_file,wrt_nam,var_s)
        clear x y var var_s
        
        %V
        if IF_Separate
        fileN = [Data_dir,'/',file_name,add_to_v,'.nc'];
        else
        fileN = [Data_dir,'/',file_name,'.nc'];
        end
        disp([' '])
        disp(['Northward current: '])
        disp(['File: ',fileN])
        var_nam   = 'water_v';
        lon_nam   = 'lon';
        lat_nam   = 'lat';
        dep_nam   = 'depth';
        wrt_nam   = 'v';
        X         = ncload_3D(fileN,lon_nam);
        Y         = ncload_3D(fileN,lat_nam);
        VAR       = ncload_3D(fileN,var_nam);
        for layer = 1:size(VAR,1)
            disp(['Processing Layer :',num2str(layer)])
            x         = X;
            y         = Y;
            var       = squeeze(VAR(layer,:,:));
            x         =[x-360;x;x+360];
            var       =[var,var,var];
            [x,y,var] = upscale2D(x,y,var,dx_roms);
            var_s(:,:,layer)= interp2(x,y,var,lonv,latv)';
        end
        var_s(isnan(var_s))=0;
        ncwrite(S_file,wrt_nam,var_s)
        clear x y var var_s

    end
end