% 
% coads_time=15:30:345; % year of 360 days
% coads_cycle=360;

coads_time=(15.2188:30.4375:350.0313); % year of 365.25 days
coads_cycle=365.25;

coads_dir = ['Z:\Data\COADS05'];
Save_dir  = [pwd,'/Result'];
mkdir(Save_dir)

frcname   = [Save_dir,'/Frc.nc'];
grdname   = [Run_dir,'/Data/Grd.nc'];
ROMS_title='ROMS forcing';

IF_mkSST  = 0;