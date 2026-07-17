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
variable_input_name{ID}  = 'Rrob';
variable_output_name{ID} = 'Rrob';
variable_time_name{ID}   = 'flt_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Rossby radius of deformation';
variable_unit{ID}        = 'm';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;

