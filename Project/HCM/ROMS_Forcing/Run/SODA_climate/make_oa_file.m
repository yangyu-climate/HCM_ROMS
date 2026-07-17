clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

SODA_parameter

H_file      = 'SODA';
Save_dir    = [pwd,'/Data'];
mkdir(Save_dir)

T_cycle     = 15:30:345;

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

         
filename  = data_file;    
if ~isempty(filename) 
    fileN = filename;  
    disp(['Load data from: ',fileN])
    for N=1:12
        time  = T_cycle(N);
        month = N;
        if month<10
            month_num = ['0',num2str(month)];
        else
            month_num = num2str(month);
        end
        T_name = [month_num];
        disp(['Month ',T_name])   
        depth  = ncload_1D(fileN,'st_ocean'); 
        Dp     = length(depth);
        S_file = [Save_dir,'/',H_file,'_',T_name,'.nc'];
        delete(S_file)
        creat_oa_file(S_file,Lp,Mp,Dp)
        ncwrite(S_file,'time' ,time)
        ncwrite(S_file,'depth',depth)
        
        %SSH
        var_nam   = 'ssh';
        lon_nam   = 'xt_ocean';
        lat_nam   = 'yt_ocean';
        x         = ncload_2D(fileN,lon_nam);
        y         = ncload_2D(fileN,lat_nam);
        var       = ncload_2D(fileN,var_nam); 
        var       = squeeze(var(N,:,:));
        var_s     = interp2(x,y,var,lonr,latr)';
        var_s(isnan(var_s))=0;
        ncwrite(S_file,var_nam,var_s)
        clear x y var var_s
        
        %TEMP
        var_nam   = 'temp';
        lon_nam   = 'xt_ocean';
        lat_nam   = 'yt_ocean';
        x         = ncload_2D(fileN,lon_nam);
        y         = ncload_2D(fileN,lat_nam);
        var       = ncload_2D(fileN,var_nam); 
        var       = squeeze(var(N,:,:,:));
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
        x         = ncload_2D(fileN,lon_nam);
        y         = ncload_2D(fileN,lat_nam);
        var       = ncload_2D(fileN,var_nam); 
        var       = squeeze(var(N,:,:,:));
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
        x         = ncload_2D(fileN,lon_nam);
        y         = ncload_2D(fileN,lat_nam);
        var       = ncload_2D(fileN,var_nam); 
        var       = squeeze(var(N,:,:,:));
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
        x         = ncload_2D(fileN,lon_nam);
        y         = ncload_2D(fileN,lat_nam);
        var       = ncload_2D(fileN,var_nam); 
        var       = squeeze(var(N,:,:,:));
        for layer = 1:size(var,1)
            var_s(:,:,layer)= interp2(x,y,squeeze(var(layer,:,:)),lonv,latv)';
        end
        var_s(isnan(var_s))=0;
        ncwrite(S_file,var_nam,var_s)
        clear x y var var_s

    end
end
