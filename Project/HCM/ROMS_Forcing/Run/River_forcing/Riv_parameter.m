% Time and coordinate control
%--------------------------------------------------------------------------
title       = 'BYECS';
theta_s     = 4.5;
theta_b     = 1.5;
hc          = 1;
layer_N     = 30;
%--------------------------------------------------------------------------
Save_dir  = [pwd,'/Result'];
mkdir(Save_dir)

grdname   = [Run_dir,'/Data/Grd.nc'];
clmname   = [Save_dir,'/Clm.nc'];
rivname   = [Save_dir,'/Riv.nc'];
ininame   = [Run_dir,'/Run/SODA_initial/Result/Ini.nc'];

% Runoff monthly seasonal climatology (Dai and Trenberth)
bound_lim = 25;
global_clim_riverdir=[Run_dir,'make_river/RUNOFF_DAI/'];
global_clim_rivername=[global_clim_riverdir,'Dai_Trenberth_runoff_global_clim.nc'];

woa_dir =[Run_dir,'make_river/WOA2009/'];
woa_time=(15.2188:30.4375:350.0313); % year of 365.25 days
woa_cycle=365.25;