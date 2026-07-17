clear
clc

Run_dir = ['../../../../'];
addpath(Run_dir)
start
% warning off
H_file      = 'woa';
Ycycle      = 360;
MonthD      = Ycycle/12;
woa_time    = [MonthD/2:MonthD:Ycycle-MonthD/2];
R_factor    = 1029/1000;
G_file      = [Run_dir,'Data/Grd.nc'];
S_file      = 'Bry_Bio';       
title       = 'BIO_HCM';
obc         = [1 1 1 1];
theta_s     = 6.5;
theta_b     = 0.5;
hc          = 5;
layer_N     = 50;       
clobber     = 'clobber';      
vtransform  = 2;
type        = 'r';

Data_dir   = ['../../Data'];
Save_dir    = [pwd,'/Result'];
mkdir(Save_dir)

grd_file    = G_file;
h           = ncload_2D(grd_file,'h');
lonr        = ncload_2D(grd_file,'lon_rho');
latr        = ncload_2D(grd_file,'lat_rho');
lonu        = ncload_2D(grd_file,'lon_u');
latu        = ncload_2D(grd_file,'lat_u');
lonv        = ncload_2D(grd_file,'lon_v');
latv        = ncload_2D(grd_file,'lat_v');

bryname = [Save_dir,'/',S_file,'.nc'];
grdname = G_file;
delete(bryname)
time = woa_time;
create_bry_UMaine31Fe(bryname,grdname,title,obc,...
                      theta_s,theta_b,hc,layer_N,...
                      time,Ycycle,clobber,vtransform)

for Name_num = 1:7
    if Name_num == 1
        H_dir = 'nitrate';
        V_nam = 'NO3';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 2
        H_dir = 'phosphate';
        V_nam = 'PO4';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 3
        H_dir = 'silicate';
        V_nam = 'SiOH';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 4
        H_dir = 'oxygen';
        V_nam = 'Oxyg';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 5
        H_dir = 'dic';
        V_nam = 'TIC';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 6
        H_dir = 'alkalinity';
        V_nam = 'Talk';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 7
        H_dir = 'iron';
        V_nam = 'FeD';
        Fscale= 1000;
        Fadd  = 0;
    end
    disp(['Nutrition components: ',H_dir])

    for Month = 1:12
        if Month<10
            NN = ['0',num2str(Month)];
        else
            NN = [num2str(Month)];
        end
        disp(['Month: ',NN])
        fileN  = [Data_dir,'/',H_file,'_', H_dir,'_',NN,'.nc'];
        disp(['Load data from: ',fileN])
        depth     = ncload_0D(fileN,'depth');    
        dep       = [0;depth];
        dep       = dep(2:end)-dep(1:end-1);
        nc   = netcdf(fileN);
        
        %Southern boundary
        disp(['Southern boundary'])
        zeta = 0*squeeze(nc{'ssh'}(1,:));    
        var  =   squeeze(nc{'var'}(:,1,:));  
        H    =   squeeze(        h(1,:));
        varT =   get_roms_bry_value_bio(zeta,H,depth,dep,var,...
                  theta_s,theta_b,hc,layer_N,type,vtransform);
        varT = Fscale*varT+Fadd;
        varT_south(Month,:,:) = R_factor * varT;
        clear varT
            
        %Eastern boundary
        disp(['Eastern boundary'])    
        zeta = 0*squeeze(nc{'ssh'}(:,end));
        var  =   squeeze(nc{'var'}(:,:,end));   
        H    =   squeeze(        h(:,end));
        varT =   get_roms_bry_value_bio(zeta,H,depth,dep,var,...
                  theta_s,theta_b,hc,layer_N,type,vtransform);
        varT = Fscale*varT+Fadd;
        varT_east(Month,:,:) = R_factor * varT;
        clear varT
        
        %Northern boundary    
        disp(['Northern boundary']) 
        zeta = 0*squeeze(nc{'ssh'}(end,:));
        var  =   squeeze(nc{'var'}(:,end,:));    
        H    =   squeeze(        h(end,:));
        varT =   get_roms_bry_value_bio(zeta,H,depth,dep,var,...
                  theta_s,theta_b,hc,layer_N,type,vtransform);
        varT = Fscale*varT+Fadd;
        varT_north(Month,:,:) = R_factor * varT; 
        clear varT
            
        %Western boundary
        disp(['Western boundary'])
        zeta = 0*squeeze(nc{'ssh'}(:,1));   
        var  =   squeeze(nc{'var'}(:,:,1));   
        H    =   squeeze(        h(:,1));
        varT =   get_roms_bry_value_bio(zeta,H,depth,dep,var,...
                  theta_s,theta_b,hc,layer_N,type,vtransform); 
        varT = Fscale*varT+Fadd;
        varT_west(Month,:,:) = R_factor * varT;
        clear varT    
        close(nc)
    end
    
    nc = netcdf(bryname,'write');  
    disp('Writes into broundary file ...')
    for obc_num = 1:4
        if obc_num==1
            suffix ='_south';
            varT   = varT_south;
        elseif obc_num==2
            suffix ='_east';
            varT   = varT_east;
        elseif obc_num==3
            suffix ='_north';
            varT   = varT_north;  
        elseif obc_num==4
            suffix ='_west';
            varT   = varT_west;
        end
        nc{[V_nam,suffix]}(:) =squeeze(varT);
    end
    close(nc)
    clear varT_*
end
