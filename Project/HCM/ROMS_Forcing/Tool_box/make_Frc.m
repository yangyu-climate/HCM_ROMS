
clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

Frc_parameter

disp(' ')
disp(' Read in the grid...')
nc=netcdf(grdname);
Lp=length(nc('xi_rho'));
Mp=length(nc('eta_rho'));
lon=nc{'lon_rho'}(:);
lat=nc{'lat_rho'}(:);
angle=nc{'angle'}(:);
result=close(nc);
cosa = cos(angle);
sina = sin(angle);

disp(' ')
disp(' Create the forcing file...')
create_Frc(frcname,grdname,ROMS_title,...
           coads_time,coads_time,...
           coads_cycle,coads_cycle,IF_mkSST)

sst_file=[coads_dir,'/sst.cdf'];
sst_name='sst';
sat_file=[coads_dir,'/sat.cdf'];
sat_name='sat';
airdens_file=[coads_dir,'/airdens.cdf'];
airdens_name='airdens';
w3_file=[coads_dir,'/w3.cdf'];
w3_name='w3';
qsea_file=[coads_dir,'/qsea.cdf'];
qsea_name='qsea';
sss_file=[coads_dir,'/sss.cdf'];
sss_name='salinity';

Roa=0;

%
% Loop on time
%
nc=netcdf(frcname,'write');

for tindex=1:length(coads_time)
  time=nc{'sst_time'}(tindex);
  sst=ext_data(sst_file,sst_name,tindex,lon,lat,time,Roa,2);
  sat=ext_data(sat_file,sat_name,tindex,lon,lat,time,Roa,2);
  airdens=ext_data(airdens_file,airdens_name,tindex,lon,lat,time,Roa,2);
  w3=ext_data(w3_file,w3_name,tindex,lon,lat,time,Roa,2);
  qsea=0.001*ext_data(qsea_file,qsea_name,tindex,lon,lat,time,Roa,2);
  dqdsst=get_dqdsst(sst,sat,airdens,w3,qsea);
  nc{'dQdSST'}(tindex,:,:)=dqdsst;
  if IF_mkSST
  nc{'SST'}(tindex,:,:)=sst;
  end
end
for tindex=1:length(coads_time)
  time=nc{'sss_time'}(tindex);
  nc{'SSS'}(tindex,:,:)=ext_data(sss_file,sss_name,tindex,...
                                 lon,lat,time,Roa,1);			 
end

close(nc)



