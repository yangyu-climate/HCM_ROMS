% Time control
%--------------------------------------------------------------------------
days_per_year   = 360;
D_per_M         = days_per_year/12;
Frc_time        = [D_per_M/2:D_per_M:days_per_year-D_per_M/2];
Frc_cycle       = days_per_year;
Met_file        = [pwd,'/MET/MET.mat'];
Frc_name        = 'Frc_TIW.nc';
%--------------------------------------------------------------------------
Mode_N          = 10;
variable_number = 3;
%--------------------------------------------------------------------------
% HCM parameters
%--------------------------------------------------------------------------
variable_time_name   = 'tiw_time';
variable_coordinate  = 'rho';
% dUdT_M
ID                       = 1;
variable_longname{ID}    = 'TIW U stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dVdT_M
ID                       = 2;
variable_longname{ID}    = 'TIW V stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dTdT_W
ID                       = 3;
variable_longname{ID}    = 'weight of TIW wind stress to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
