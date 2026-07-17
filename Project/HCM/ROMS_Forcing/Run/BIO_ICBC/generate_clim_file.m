clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

Data_dir    = ['E:\WOA18_PISCES'];
Save_dir    = [pwd,'/Data'];
mkdir(Save_dir)

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


for Name_num = 1:7
    if Name_num == 1
        H_dir = 'nitrate';
        V_nam = 'n_an';
    elseif Name_num == 2
        H_dir = 'phosphate';
        V_nam = 'p_an';
    elseif Name_num == 3
        H_dir = 'silicate';
        V_nam = 'i_an';
    elseif Name_num == 4
        H_dir = 'oxygen';
        V_nam = 'o_an';
    elseif Name_num == 5
        H_dir = 'dic';
        V_nam = 'c_an';
    elseif Name_num == 6
        H_dir = 'alkalinity';
        V_nam = 'k_an';
    elseif Name_num == 7
        H_dir = 'iron';
        V_nam = 'f_an';
    end
    H_file    = 'woa';
    T_dir     = [Data_dir,'/',H_dir];
    file_name = [H_file,'*.nc'];            
    filename  = dir([T_dir,'/',file_name]);
    file_name = filename(1).name;
    fileH     = file_name(1:end-8);
    fileE     = file_name(end-5:end);
    
    fileHN = [fileH,'00',fileE];   
    fileN  = [T_dir,'/',fileHN];   
    depth  = ncload_1D(fileN,'depth'); 
    Dp     = length(depth);
        
    % VAR ANNUAL 
    disp(['Load data from: ',fileN])
    var_nam   = V_nam;
    lon_nam   = 'lon';
    lat_nam   = 'lat';
    dep_nam   = 'depth';
    x         = double(ncread(fileN,lon_nam));
    x(end+1)  = x(1)+360;
    x(x<0)    = x(x<0)+360;
    y         = double(ncread(fileN,lat_nam));
    var       = double(ncread(fileN,var_nam));
    var       = [var;var(1,:,:)];
    var(find(var<0)) = NaN;
    [x,y]     = meshgrid(x,y);
    for layer = 1:size(var,3)
        var_s(:,:,layer)= interp_ocean(x,y,squeeze(var(:,:,layer))',lonr,latr)'; 
    end
    var_m = var_s;
    clear x y var var_s
    

    for N=1:12
        if N<10
            NN = ['0',num2str(N)];
        else
            NN = [num2str(N)];
        end
        S_name = [H_dir,'_',NN]; 
        S_file = [Save_dir,'/',H_file,'_',S_name,'.nc'];
        delete(S_file)
        creat_oa_file(S_file,Lp,Mp,Dp)
        ncwrite(S_file,'time' ,N)
        ncwrite(S_file,'depth',depth)

        var_s  = var_m;
        fileHN = [fileH,NN,fileE];
        fileN  = [T_dir,'/',fileHN];
        disp(['Load data from: ',fileN])
        % VAR MONTHLY 
        var_nam   = V_nam;
        lon_nam   = 'lon';
        lat_nam   = 'lat';
        dep_nam   = 'depth';
        x         = double(ncread(fileN,lon_nam));
        x(end+1)  = x(1)+360;
        x(x<0)    = x(x<0)+360;
        y         = double(ncread(fileN,lat_nam));
        var       = double(ncread(fileN,var_nam));
        var       = [var;var(1,:,:)];
        var(find(var<0)) = NaN;
        [x,y]     = meshgrid(x,y);
        for layer = 1:size(var,3)
            var_s(:,:,layer)= interp_ocean(x,y,squeeze(var(:,:,layer))',lonr,latr)';
        end
        ncwrite(S_file,'var',var_s)
        clear x y var var_s
    end
    
end
    
   
