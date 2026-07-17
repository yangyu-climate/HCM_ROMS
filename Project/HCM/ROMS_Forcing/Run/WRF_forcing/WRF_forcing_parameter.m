% Time control
%--------------------------------------------------------------------------
Time_beg  = [2011  1  1  0 0 0];
Time_end  = [2016  1  1  0 0 0];
Time_ref  = [2011  1  1  0 0 0];
Time_frq  = 3/24; %Forcing Frequency in Day
%--------------------------------------------------------------------------
variable_number = 9;
% Uwind
variable_input_name{1}  = 'u10';
variable_output_name{1} = 'Uwind';
variable_time_name{1}   = 'wind_time';
variable_coordinate{1}  = 'rho';
variable_longname{1}    = 'surface u-wind component';
variable_unit{1}        = 'meter second-1';
variable_scale_factor{1}= 1;
variable_add_offset{1}  = 0;
% Vwind
variable_input_name{2}  = 'v10';
variable_output_name{2} = 'Vwind';
variable_time_name{2}   = 'wind_time';
variable_coordinate{2}  = 'rho';
variable_longname{2}    = 'surface v-wind component';
variable_unit{2}        = 'meter second-1';
variable_scale_factor{2}= 1;
variable_add_offset{2}  = 0;
% Pair
variable_input_name{3}  = 'slp';
variable_output_name{3} = 'Pair';
variable_time_name{3}   = 'pair_time';
variable_coordinate{3}  = 'rho';
variable_longname{3}    = 'surface air pressure';
variable_unit{3}        = 'millibar';
variable_scale_factor{3}= 1;
variable_add_offset{3}  = 0;
% Tair
variable_input_name{4}  = 't2';
variable_output_name{4} = 'Tair';
variable_time_name{4}   = 'tair_time';
variable_coordinate{4}  = 'rho';
variable_longname{4}    = 'surface air temperature';
variable_unit{4}        = 'Celsius';
variable_scale_factor{4}= 1;
variable_add_offset{4}  = -273.15;
% Qair
variable_input_name{5}  = 'rh2';
variable_output_name{5} = 'Qair';
variable_time_name{5}   = 'qair_time';
variable_coordinate{5}  = 'rho';
variable_longname{5}    = 'surface air relative humidity';
variable_unit{5}        = 'percentage';
variable_scale_factor{5}= 1;
variable_add_offset{5}  = 0;
% cloud
variable_input_name{6}  = 'tcdc';
variable_output_name{6} = 'cloud';
variable_time_name{6}   = 'cloud_time';
variable_coordinate{6}  = 'rho';
variable_longname{6}    = 'cloud fraction';
variable_unit{6}        = 'nondimesional';
variable_scale_factor{6}= 1;
variable_add_offset{6}  = 0;
% sward
variable_input_name{7}  = 'gsw';
variable_output_name{7} = 'swrad';
variable_time_name{7}   = 'srf_time';
variable_coordinate{7}  = 'rho';
variable_longname{7}    = 'solar shortwave radiation flux';
variable_unit{7}        = 'W m-2';
variable_scale_factor{7}= 1;
variable_add_offset{7}  = 0;
% lward
variable_input_name{8}  = 'glw';
variable_output_name{8} = 'lwrad';
variable_time_name{8}   = 'lrf_time';
variable_coordinate{8}  = 'rho';
variable_longname{8}    = 'net longwave radiation flux';
variable_unit{8}        = 'W m-2';
variable_scale_factor{8}= 1;
variable_add_offset{8}  = 0;
% rain
variable_input_name{9}  = 'prate';
variable_output_name{9} = 'rain';
variable_time_name{9}   = 'rain_time';
variable_coordinate{9}  = 'rho';
variable_longname{9}    = 'rain fall rate';
variable_unit{9}        = 'kilogram meter-2 second-1';
variable_scale_factor{9}= 1;
variable_add_offset{9}  = 0;
%--------------------------------------------------------------------------
