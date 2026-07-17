%%%%%%%%%%%%%%%%%%%%% USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%
Riv_parameter

ROMS_title=title;

disp(' ')
disp(['Make River Input file for:'])
disp(ROMS_title)

nc=netcdf(grdname);
Lp=length(nc('xi_rho'));
Mp=length(nc('eta_rho'));
lon=nc{'lon_rho'}(:);
lat=nc{'lat_rho'}(:);
angle=nc{'angle'}(:);
result=close(nc);
cosa = cos(angle);
sina = sin(angle);
%
% Create the forcing file
%
disp(' Create the forcing file...')

load river.mat
create_river_forcing(rivname,grdname,ininame,ROMS_title,...
                     woa_time,woa_cycle,number)     
       
ncload(rivname);
river_Xposition =C_Xposition;
river_Eposition =C_Eposition;
river_direction =C_direction;
river_transport =C_transport;
river_Vshape    =C_Vshape;
river_temp      =C_temp;
river_salt      =C_salt;
river_flag      =C_flag;

ncsave(rivname,...
       river_Xposition,river_Eposition,...
       river_direction,river_transport,...
       river_Vshape,river_temp,river_salt,river_flag);



