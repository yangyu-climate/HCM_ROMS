clear
clc

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

SODA_parameter

H_file      = 'SODA';
G_file      = [Run_dir,'Data/Grd.nc'];
S_file      = 'Bry';       

clobber     = 'clobber';      
vtransform  = 2;
type        = 'r';

Data_dir    = [pwd,'/Data'];
Save_dir    = [pwd,'/Result'];
mkdir(Save_dir)

grd_file    = [Save_dir,'/Grd.nc'];
h           = ncload_2D(grd_file,'h');
lonr        = ncload_2D(grd_file,'lon_rho');
latr        = ncload_2D(grd_file,'lat_rho');
lonu        = ncload_2D(grd_file,'lon_u');
latu        = ncload_2D(grd_file,'lat_u');
lonv        = ncload_2D(grd_file,'lon_v');
latv        = ncload_2D(grd_file,'lat_v');

for N = 1:12
    num   = N;
    month = N;
    if month<10
        month_num = ['0',num2str(month)];
    else
        month_num = num2str(month);
    end
   
    T_num = [month_num];
    S_num = [month_num];
        
    T_file    = S_num;    
    file_name = [H_file,'*',T_file,'*'];        
    filename  = dir([Data_dir,'/',file_name]);
    
    if ~isempty(filename)
        disp(['Month ',T_num])
        file_name = filename.name;
        fileN = [Data_dir,'/',file_name];
        disp(['Load data from: ',fileN])
        time(num) = ncload_0D(fileN,'time');
        depth     = ncload_0D(fileN,'depth');
        dep       = [0;depth];
        dep       = dep(2:end)-dep(1:end-1);
        
        nc   = netcdf(fileN);
            
        %Southern boundary
        disp(['Southern boundary'])
        zeta = squeeze(nc{'ssh'}(1,:));
        temp = squeeze(nc{'temp'}(:,1,:));
        salt = squeeze(nc{'salt'}(:,1,:));
        u    = squeeze(nc{'u'}(:,1,:));
        v    = squeeze(nc{'v'}(:,1,:));
        H    = squeeze(        h(1,:));
        [varZ,varT,varS,varU,varV,Ubar,Vbar] ...
                = get_roms_bry_value_clim(zeta,H,depth,dep,temp,salt,u,v,...
                  theta_s,theta_b,hc,layer_N,type,vtransform,zeta0);
        zeta_south(num,:)   = varZ;
        ubar_south(num,:)   = Ubar;
        vbar_south(num,:)   = Vbar;
        temp_south(num,:,:) = varT;
        salt_south(num,:,:) = varS;
        u_south(num,:,:)    = varU;
        v_south(num,:,:)    = varV;
        clear varZ varT varS varU varV Ubar Vbar
            
        %Eastern boundary
        disp(['Eastern boundary'])
        zeta = squeeze(nc{'ssh'}(:,end));
        temp = squeeze(nc{'temp'}(:,:,end));
        salt = squeeze(nc{'salt'}(:,:,end));
        u    = squeeze(nc{'u'}(:,:,end));
        v    = squeeze(nc{'v'}(:,:,end));
        H    = squeeze(        h(:,end));
        [varZ,varT,varS,varU,varV,Ubar,Vbar] ...
                = get_roms_bry_value_clim(zeta,H,depth,dep,temp,salt,u,v,...
                  theta_s,theta_b,hc,layer_N,type,vtransform,zeta0);
        zeta_east(num,:)   = varZ;
        ubar_east(num,:)   = Ubar;
        vbar_east(num,:)   = Vbar;
        temp_east(num,:,:) = varT;
        salt_east(num,:,:) = varS;
        u_east(num,:,:)    = varU;
        v_east(num,:,:)    = varV;
        clear varZ varT varS varU varV Ubar Vbar
            
        %Northern boundary
        disp(['Northern boundary'])
        zeta = squeeze(nc{'ssh'}(end,:));
        temp = squeeze(nc{'temp'}(:,end,:));
        salt = squeeze(nc{'salt'}(:,end,:));
        u    = squeeze(nc{'u'}(:,end,:));
        v    = squeeze(nc{'v'}(:,end,:));
        H    = squeeze(        h(end,:));
        [varZ,varT,varS,varU,varV,Ubar,Vbar] ...
                = get_roms_bry_value_clim(zeta,H,depth,dep,temp,salt,u,v,...
                  theta_s,theta_b,hc,layer_N,type,vtransform,zeta0);
        zeta_north(num,:)   = varZ;
        ubar_north(num,:)   = Ubar;
        vbar_north(num,:)   = Vbar;
        temp_north(num,:,:) = varT;
        salt_north(num,:,:) = varS;
        u_north(num,:,:)    = varU;
        v_north(num,:,:)    = varV;
        clear varZ varT varS varU varV Ubar Vbar
            
        %Western boundary
        disp(['Western boundary'])
        zeta = squeeze(nc{'ssh'}(:,1));
        temp = squeeze(nc{'temp'}(:,:,1));
        salt = squeeze(nc{'salt'}(:,:,1));
        u    = squeeze(nc{'u'}(:,:,1));
        v    = squeeze(nc{'v'}(:,:,1));
        H    = squeeze(        h(:,1));
        [varZ,varT,varS,varU,varV,Ubar,Vbar] ...
                = get_roms_bry_value_clim(zeta,H,depth,dep,temp,salt,u,v,...
                  theta_s,theta_b,hc,layer_N,type,vtransform,zeta0);
        zeta_west(num,:)   = varZ;
        ubar_west(num,:)   = Ubar;
        vbar_west(num,:)   = Vbar;
        temp_west(num,:,:) = varT;
        salt_west(num,:,:) = varS;
        u_west(num,:,:)    = varU;
        v_west(num,:,:)    = varV;
        clear varZ varT varS varU varV Ubar Vbar
            
        close(nc)
    end
end

bryname = [Save_dir,'/',S_file,'.nc'];
grdname = G_file;
delete(bryname)
create_bryfile_clim(bryname,grdname,title,obc,...
                    theta_s,theta_b,hc,layer_N,...
                    time,clobber,vtransform,Tcycle)
            
for obc_num = 1:4
    if obc_num==1   
        suffix   ='_south';        
        u_var    = u_south;   
        v_var    = v_south;        
        t_var    = temp_south;       
        s_var    = salt_south;       
        ubar_var = ubar_south;      
        vbar_var = vbar_south;      
        zeta_var = zeta_south;      
    end   
    if obc_num==2    
        suffix   ='_east';       
        u_var    = u_east;  
        v_var    = v_east;
        t_var    = temp_east;      
        s_var    = salt_east;       
        ubar_var = ubar_east;       
        vbar_var = vbar_east;      
        zeta_var = zeta_east;        
    end   
    if obc_num==3    
        suffix   ='_north';       
        u_var    = u_north;        
        v_var    = v_north;        
        t_var    = temp_north;      
        s_var    = salt_north;       
        ubar_var = ubar_north;        
        vbar_var = vbar_north;      
        zeta_var = zeta_north;      
    end    
    if obc_num==4
        suffix   ='_west';       
        u_var    = u_west;       
        v_var    = v_west;      
        t_var    = temp_west; 
        s_var    = salt_west;    
        ubar_var = ubar_west;    
        vbar_var = vbar_west;     
        zeta_var = zeta_west;  
    end
    
    zeta_var = zeta_var+zeta0;
    
    nc         = netcdf(bryname,'write');
    disp('Writes into broundary file ...')
    nc{['u',suffix]}(:)    =squeeze(u_var);
    nc{['v',suffix]}(:)    =squeeze(v_var);
    nc{['temp',suffix]}(:) =squeeze(t_var);
    nc{['salt',suffix]}(:) =squeeze(s_var);
    nc{['ubar',suffix]}(:) =squeeze(ubar_var);
    nc{['vbar',suffix]}(:) =squeeze(vbar_var);
    nc{['zeta',suffix]}(:) =squeeze(zeta_var);   
    close(nc)
end
