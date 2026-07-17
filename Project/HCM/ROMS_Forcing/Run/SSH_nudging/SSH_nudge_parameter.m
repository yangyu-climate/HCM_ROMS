% Time control
%--------------------------------------------------------------------------
days_per_year   = 360;
D_per_M         = days_per_year/12;
Frc_time        = [D_per_M/2:D_per_M:days_per_year-D_per_M/2];
Frc_cycle       = days_per_year;
%--------------------------------------------------------------------------
variable_number = 1;
%--------------------------------------------------------------------------

% HCM SST filter parameters
%--------------------------------------------------------------------------
% Rrob
ID                       = 1;
variable_input_name{ID}  = 'SSH';
variable_output_name{ID} = 'zeta';
variable_time_name{ID}   = 'zeta_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'sea surface height climatology';
variable_unit{ID}        = 'm';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;

