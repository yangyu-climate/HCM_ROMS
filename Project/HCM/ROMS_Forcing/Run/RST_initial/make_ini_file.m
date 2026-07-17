clear
clc

Run_dir = ['../../'];
addpath(Run_dir)
start
warning off

title       = 'Hagupit';
Ini_time    = [2020 8 1 0 0 0];
RST_file    = [pwd,'/rst.nc'];

IF_WET_DRY  = 1;
IF_WAT_AGE  = 1;

G_file      = [Run_dir,'Data/Grd.nc'];
S_file      = 'Ini'; 
clobber     = 'write';      

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

T = datenum(Ini_time);
[year,month,day,hour,minu,seco] = date2num(T);
[year_num,month_num,day_num,...
 hour_num,minu_num,seco_num] = date2str(T);
tini    = 0;
      
T_num = [year_num,'-',month_num,'-',day_num,'-',hour_num,':',minu_num,':',seco_num];         
disp(['Date: ',T_num])

ocean_time = ncread(RST_file,'ocean_time');
UN = ncreadatt(RST_file,'ocean_time','units');
Time_ref = datenum(...
[str2num(UN(end-3-5*3:end-5*3)),str2num(UN(end-1-4*3:end-4*3)),...
 str2num(UN(end-1-3*3:end-3*3)),str2num(UN(end-1-2*3:end-2*3)),...
 str2num(UN(end-1-1*3:end-1*3)),str2num(UN(end-1-0*3:end-0*3))]);
ocean_time = ocean_time/24/60/60 + Time_ref;
T_loc = find(ocean_time==T);

if ~isempty(T_loc)
    theta_s    = ncread(RST_file,'theta_s');
    theta_b    = ncread(RST_file,'theta_b');
    hc         = ncread(RST_file,'hc');
    vtransform = ncread(RST_file,'Vtransform');
    layer_N    = length(ncread(RST_file,'s_rho'));

    ininame = [Save_dir,'/',S_file,'_',year_num,'.nc'];
    grdname = G_file;
    delete(ininame)
    create_inifile_rst(ininame,grdname,title,...
                       theta_s,theta_b,hc,layer_N,...
                       tini,clobber,vtransform)
                        
    mask_rho = ncload_2D(RST_file,'mask_rho');
    mask_u   = ncload_2D(RST_file,'mask_u');
    mask_v   = ncload_2D(RST_file,'mask_v');
    if IF_WET_DRY==1
    wetdry_mask_rho = ncload_2D(RST_file,'wetdry_mask_rho');
    wetdry_mask_u   = ncload_2D(RST_file,'wetdry_mask_u');
    wetdry_mask_v   = ncload_2D(RST_file,'wetdry_mask_v');
    mask_rho = mask_rho.*squeeze(wetdry_mask_rho(T_loc,:,:));
    mask_u   = mask_u  .*squeeze(wetdry_mask_u(T_loc,:,:));
    mask_v   = mask_v  .*squeeze(wetdry_mask_v(T_loc,:,:));
    end
            
    zeta = ncload_2D(RST_file,'zeta');
    zeta = squeeze(zeta(T_loc,:,:)).*mask_rho;
    ubar = ncload_2D(RST_file,'ubar');
    ubar = squeeze(ubar(T_loc,:,:)).*mask_u;
    vbar = ncload_2D(RST_file,'vbar');
    vbar = squeeze(vbar(T_loc,:,:)).*mask_v;
    temp = ncload_2D(RST_file,'temp');
    temp = squeeze(temp(T_loc,:,:,:));
    salt = ncload_2D(RST_file,'salt');
    salt = squeeze(salt(T_loc,:,:,:));
    u    = ncload_2D(RST_file,'u');
    u    = squeeze(u(T_loc,:,:,:));
    v    = ncload_2D(RST_file,'v');
    v    = squeeze(v(T_loc,:,:,:));
    if IF_WAT_AGE==1 
    dye_01     = ncload_3D(RST_file,'dye_01');
    dye_01     = squeeze(dye_01(T_loc,:,:,:));
    dye_01_age = ncload_3D(RST_file,'dye_01_age');
    dye_01_age = squeeze(dye_01_age(T_loc,:,:,:));
    end
 
    for k = 1:layer_N
        temp(k,:,:) = squeeze(temp(k,:,:)).*mask_rho;
        salt(k,:,:) = squeeze(salt(k,:,:)).*mask_rho;
        u(k,:,:)    = squeeze(u(k,:,:))   .*mask_u;
        v(k,:,:)    = squeeze(v(k,:,:))   .*mask_v;
        if IF_WAT_AGE==1 
        dye_01(k,:,:)     = squeeze(dye_01(k,:,:)    ).*mask_rho;
        dye_01_age(k,:,:) = squeeze(dye_01_age(k,:,:)).*mask_rho;
        end
    end
       
    % Save data
    nc  = netcdf(ininame,'write');
    disp('Writes into Ini file ...')
    nc{'zeta'}(:) = squeeze(zeta);
    nc{'ubar'}(:) = squeeze(ubar);
    nc{'vbar'}(:) = squeeze(vbar);
    nc{'temp'}(:) = squeeze(temp);
    nc{'salt'}(:) = squeeze(salt);
    nc{'u'}(:)    = squeeze(u);
    nc{'v'}(:)    = squeeze(v);
    if IF_WAT_AGE==1
    nc{'dye_01'}(:)     = squeeze(dye_01);
    nc{'dye_01_age'}(:) = squeeze(dye_01_age);
    end
    close(nc)
end


           
           
           
