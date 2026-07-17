clear
clc

Run_dir = ['../../../'];
addpath(Run_dir)
start
warning off

title       = 'ROMS_HCM';
RST_file    = ['/home7/yyu12/Clark/application/HCM/Result/BIO/CLM/rst.nc'];

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

ocean_time = ncread(RST_file,'ocean_time');
%UN = ncreadatt(RST_file,'ocean_time','units');
%Time_ref = datenum(...
%[str2num(UN(end-3-5*3:end-5*3)),str2num(UN(end-1-4*3:end-4*3)),...
% str2num(UN(end-1-3*3:end-3*3)),str2num(UN(end-1-2*3:end-2*3)),...
% str2num(UN(end-1-1*3:end-1*3)),str2num(UN(end-1-0*3:end-0*3))]);
%ocean_time = ocean_time/24/60/60 + Time_ref;
ocean_time = ocean_time/24/60/60;

T     = max(ocean_time);
T_loc = find(ocean_time==T);
tini  = 0;

%[year,month,day,hour,minu,seco] = date2num(T);
%[year_num,month_num,day_num,...
% hour_num,minu_num,seco_num] = date2str(T);
TT    = T;
year  =(TT-mod(TT,360))/360+1;
TT    = TT-360*(year-1);
month =(TT-mod(TT,30))/30+1;
TT    = TT-30*(month-1);
day   = TT;
if day<10
day_num = ['0',num2str(day)];
else
day_num = [num2str(day)];
end
if month<10
month_num = ['0',num2str(month)];
else
month_num = [num2str(month)];
end
year_num = [num2str(year)];

T_num = [year_num,'-',month_num,'-',day_num];         
disp(['Date: ',T_num])

if ~isempty(T_loc)
    theta_s    = ncread(RST_file,'theta_s');
    theta_b    = ncread(RST_file,'theta_b');
    hc         = ncread(RST_file,'hc');
    vtransform = ncread(RST_file,'Vtransform');
    layer_N    = length(ncread(RST_file,'s_rho'));

    ininame = [Save_dir,'/',S_file,'_',year_num,'.nc'];
    grdname = G_file;
    delete(ininame)
    create_inifile(ininame,grdname,title,...
                   theta_s,theta_b,hc,layer_N,...
                   tini,clobber,vtransform)

    add_ini_UMaine31Fe(ininame,'write')

    mask_rho = ncload_2D(RST_file,'mask_rho');
    mask_u   = ncload_2D(RST_file,'mask_u');
    mask_v   = ncload_2D(RST_file,'mask_v');
%    wetdry_mask_rho = ncload_2D(RST_file,'wetdry_mask_rho');
%    wetdry_mask_u   = ncload_2D(RST_file,'wetdry_mask_u');
%    wetdry_mask_v   = ncload_2D(RST_file,'wetdry_mask_v');
    
%    mask_rho = mask_rho.*squeeze(wetdry_mask_rho(T_loc,:,:));
%    mask_u   = mask_u  .*squeeze(wetdry_mask_u(T_loc,:,:));
%    mask_v   = mask_v  .*squeeze(wetdry_mask_v(T_loc,:,:));
            
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

    for k = 1:layer_N
        temp(k,:,:) = squeeze(temp(k,:,:)).*mask_rho;
        salt(k,:,:) = squeeze(salt(k,:,:)).*mask_rho;
        u(k,:,:)    = squeeze(u(k,:,:))   .*mask_u;
        v(k,:,:)    = squeeze(v(k,:,:))   .*mask_v;
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
    close(nc)

    for Vnum=1:35
      if     Vnum==1
        varN = 'NO3';
      elseif Vnum==2
        varN = 'NH4';
      elseif Vnum==3
        varN = 'SiOH';
      elseif Vnum==4
        varN = 'PO4';
      elseif Vnum==5
        varN = 'S1_N';
      elseif Vnum==6
        varN = 'S1_C';
      elseif Vnum==7
        varN = 'S1CH';
      elseif Vnum==8
        varN = 'S2_N';
      elseif Vnum==9
        varN = 'S2_C';
      elseif Vnum==10
        varN = 'S2CH';
      elseif Vnum==11
        varN = 'S3_N';
      elseif Vnum==12
        varN = 'S3_C';
      elseif Vnum==13
        varN = 'S3CH';
      elseif Vnum==14
        varN = 'Z1_N';
      elseif Vnum==15
        varN = 'Z1_C';
      elseif Vnum==16
        varN = 'Z2_N';
      elseif Vnum==17
        varN = 'Z2_C';
      elseif Vnum==18
        varN = 'BAC_';
      elseif Vnum==19
        varN = 'DD_N';
      elseif Vnum==20
        varN = 'DD_C';
      elseif Vnum==21
        varN = 'DDCA';
      elseif Vnum==22
        varN = 'DDSi';
      elseif Vnum==23
        varN = 'LDON';
      elseif Vnum==24
        varN = 'LDOC';
      elseif Vnum==25
        varN = 'SDON';
      elseif Vnum==26
        varN = 'SDOC';
      elseif Vnum==27
        varN = 'CLDC';
      elseif Vnum==28
        varN = 'CSDC';
      elseif Vnum==29
        varN = 'oxyg';
      elseif Vnum==30
        varN = 'Talk';
      elseif Vnum==31
        varN = 'TIC';
      elseif Vnum==32
        varN = 'S1Fe';
      elseif Vnum==33
        varN = 'S2Fe';
      elseif Vnum==34
        varN = 'S3Fe';
      elseif Vnum==35
        varN = 'FeD';
      end
      disp(['Biogeochemistry variable: ',varN])
      var = ncload_2D(RST_file,varN);
      var = squeeze(var(T_loc,:,:,:));
      for k = 1:layer_N
        var(k,:,:) = squeeze(var(k,:,:)).*mask_rho;
      end
      nc  = netcdf(ininame,'write');
      nc{varN}(:) = squeeze(var);
      close(nc)

    end

end
