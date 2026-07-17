% Time control
%--------------------------------------------------------------------------
days_per_year   = 360;
D_per_M         = days_per_year/12;
Frc_time        = [D_per_M/2:D_per_M:days_per_year-D_per_M/2];
Frc_cycle       = days_per_year;
%--------------------------------------------------------------------------
variable_number = 5;
% sustr
variable_input_name{1}  = 'sustr';
variable_output_name{1} = 'sustr';
variable_time_name{1}   = 'sms_time';
variable_coordinate{1}  = 'u';
variable_longname{1}    = 'east-west surface stress';
variable_unit{1}        = 'N m-2';
variable_scale_factor{1}= 1;
variable_add_offset{1}  = 0;
% svstr
variable_input_name{2}  = 'svstr';
variable_output_name{2} = 'svstr';
variable_time_name{2}   = 'sms_time';
variable_coordinate{2}  = 'v';
variable_longname{2}    = 'north-south surface stress';
variable_unit{2}        = 'N m-2';
variable_scale_factor{2}= 1;
variable_add_offset{2}  = 0;
% shflux
variable_input_name{3}  = 'shflux';
variable_output_name{3} = 'shflux';
variable_time_name{3}   = 'shf_time';
variable_coordinate{3}  = 'rho';
variable_longname{3}    = 'surface net heat flux';
variable_unit{3}        = 'W m-2';
variable_scale_factor{3}= 1;
variable_add_offset{3}  = 0;
% swflux
variable_input_name{4}  = 'swflux';
variable_output_name{4} = 'swflux';
variable_time_name{4}   = 'swf_time';
variable_coordinate{4}  = 'rho';
variable_longname{4}    = 'surface net freswater flux, (E-P)';
variable_unit{4}        = 'centimeter day-1';
variable_scale_factor{4}= 1;
variable_add_offset{4}  = 0;
% swrad
variable_input_name{5}  = 'swrad';
variable_output_name{5} = 'swrad';
variable_time_name{5}   = 'srf_time';
variable_coordinate{5}  = 'rho';
variable_longname{5}    = 'solar shortwave radiation flux';
variable_unit{5}        = 'W m-2';
variable_scale_factor{5}= 1;
variable_add_offset{5}  = 0;
%--------------------------------------------------------------------------
