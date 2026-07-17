% Time control
%--------------------------------------------------------------------------
Time_beg  = [1987  7  1  0 0 0];
Time_end  = [1987  7  31 0 0 0];
Time_ref  = [1981  1  1  0 0 0];
Time_frq  = 6/24; %Forcing Frequency in Day
%--------------------------------------------------------------------------
variable_number = 2;
% sustr
variable_input_name{1}  = 'uwnd';
variable_output_name{1} = 'Uwind';
variable_time_name{1}   = 'wind_time';
variable_coordinate{1}  = 'rho';
variable_longname{1}    = '10 meter U wind component';
variable_unit{1}        = 'm s-1';
variable_scale_factor{1}= 1;
variable_add_offset{1}  = 0;
% svstr
variable_input_name{2}  = 'vwnd';
variable_output_name{2} = 'Vwind';
variable_time_name{2}   = 'wind_time';
variable_coordinate{2}  = 'rho';
variable_longname{2}    = '10 meter V wind component';
variable_unit{2}        = 'm s-1';
variable_scale_factor{2}= 1;
variable_add_offset{2}  = 0;
%--------------------------------------------------------------------------
