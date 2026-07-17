% Time control
%--------------------------------------------------------------------------
days_per_year   = 360;
D_per_M         = days_per_year/12;
Frc_time        = [D_per_M/2:D_per_M:days_per_year-D_per_M/2];
Frc_cycle       = days_per_year;
%--------------------------------------------------------------------------
%variable_number = 10;
variable_number = 48;
%--------------------------------------------------------------------------
% sustr
ID                       = 1;
variable_input_name{ID}  = 'sustr';
variable_output_name{ID} = 'sustr';
variable_time_name{ID}   = 'sms_time';
variable_coordinate{ID}  = 'u';
variable_longname{ID}    = 'east-west surface stress';
variable_unit{ID}        = 'N m-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% svstr
ID                       = 2;
variable_input_name{ID}  = 'svstr';
variable_output_name{ID} = 'svstr';
variable_time_name{ID}   = 'sms_time';
variable_coordinate{ID}  = 'v';
variable_longname{ID}    = 'north-south surface stress';
variable_unit{ID}        = 'N m-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% shflux
ID                       = 3;
variable_input_name{ID}  = 'shflux';
variable_output_name{ID} = 'shflux';
variable_time_name{ID}   = 'shf_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'surface net heat flux';
variable_unit{ID}        = 'W m-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% swflux
ID                       = 4;
variable_input_name{ID}  = 'swflux';
variable_output_name{ID} = 'swflux';
variable_time_name{ID}   = 'swf_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'surface net freswater flux, (E-P)';
variable_unit{ID}        = 'centimeter day-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% swrad
ID                       = 5;
variable_input_name{ID}  = 'swrad';
variable_output_name{ID} = 'swrad';
variable_time_name{ID}   = 'srf_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'solar shortwave radiation flux';
variable_unit{ID}        = 'W m-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% lwrad
ID                       = 6;
variable_input_name{ID}  = 'lwrad';
variable_output_name{ID} = 'lwrad';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'net longwave radiation flux';
variable_unit{ID}        = 'W m-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% TairC
ID                       = 7;
variable_input_name{ID}  = 'air';
variable_output_name{ID} = 'TairC';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'surface air temperature climatology';
variable_unit{ID}        = 'Celsius';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% PairC
ID                       = 8;
variable_input_name{ID}  = 'slp';
variable_output_name{ID} = 'PairC';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'surface pressure climatology';
variable_unit{ID}        = 'millibar';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% QairC
ID                       = 9;
variable_input_name{ID}  = 'rhum';
variable_output_name{ID} = 'QairC';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'surface air relative humidity climatology';
variable_unit{ID}        = 'percentage';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% RainC
ID                       = 10;
variable_input_name{ID}  = 'rain';
variable_output_name{ID} = 'rain';
variable_time_name{ID}   = 'rain_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'rain fall rate';
variable_unit{ID}        = 'kilogram meter-2 second-1';
variable_scale_factor{ID}= 1.157407d-4;
variable_add_offset{ID}  = 0;
%--------------------------------------------------------------------------
% HCM parameters
%--------------------------------------------------------------------------
% SSTC
ID                       = 11;
variable_input_name{ID}  = 'SST';
variable_output_name{ID} = 'SSTC';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'sea surface temperature climatology';
variable_unit{ID}        = 'Celsius';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% SSTA
ID                       = 12;
variable_input_name{ID}  = 'SST';
variable_output_name{ID} = 'SSTA';
variable_time_name{ID}   = 'hcm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'sea surface temperature anomaly';
variable_unit{ID}        = 'Celsius';
variable_scale_factor{ID}= 0;
variable_add_offset{ID}  = 0;
% sustrC
ID                       = 13;
variable_input_name{ID}  = 'sustr';
variable_output_name{ID} = 'sustrC';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'u';
variable_longname{ID}    = 'east-west surface stress climatology';
variable_unit{ID}        = 'N m-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% svstrC
ID                       = 14;
variable_input_name{ID}  = 'svstr';
variable_output_name{ID} = 'svstrC';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'v';
variable_longname{ID}    = 'north-south surface stress climatology';
variable_unit{ID}        = 'N m-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% sustrA
ID                       = 15;
variable_input_name{ID}  = 'sustr';
variable_output_name{ID} = 'sustrA';
variable_time_name{ID}   = 'hcm_time';
variable_coordinate{ID}  = 'u';
variable_longname{ID}    = 'east-west surface stress anomaly';
variable_unit{ID}        = 'N m-2';
variable_scale_factor{ID}= 0;
variable_add_offset{ID}  = 0;
% svstrA
ID                       = 16;
variable_input_name{ID}  = 'svstr';
variable_output_name{ID} = 'svstrA';
variable_time_name{ID}   = 'hcm_time';
variable_coordinate{ID}  = 'v';
variable_longname{ID}    = 'north-south surface stress anomaly';
variable_unit{ID}        = 'N m-2';
variable_scale_factor{ID}= 0;
variable_add_offset{ID}  = 0;
% RainC
ID                       = 17;
variable_input_name{ID}  = 'rain';
variable_output_name{ID} = 'rainC';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'surface precipitation climatology';
variable_unit{ID}        = 'centimeter day-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% RainA
ID                       = 18;
variable_input_name{ID}  = 'rain';
variable_output_name{ID} = 'rainA';
variable_time_name{ID}   = 'hcm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'surface precipitation anomaly';
variable_unit{ID}        = 'centimeter day-1';
variable_scale_factor{ID}= 0;
variable_add_offset{ID}  = 0;
%--------------------------------------------------------------------------
% dUdT_M1
ID                       = 19;
variable_input_name{ID}  = 'dUdT_M1';
variable_output_name{ID} = 'dUdT_M1';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 1 U stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_M2
ID                       = 20;
variable_input_name{ID}  = 'dUdT_M2';
variable_output_name{ID} = 'dUdT_M2';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 2 U stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_M3
ID                       = 21;
variable_input_name{ID}  = 'dUdT_M3';
variable_output_name{ID} = 'dUdT_M3';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 3 U stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_M4
ID                       = 22;
variable_input_name{ID}  = 'dUdT_M4';
variable_output_name{ID} = 'dUdT_M4';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 4 U stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_M5
ID                       = 23;
variable_input_name{ID}  = 'dUdT_M5';
variable_output_name{ID} = 'dUdT_M5';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 5 U stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_W1
ID                       = 24;
variable_input_name{ID}  = 'dUdT_W1';
variable_output_name{ID} = 'dUdT_W1';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 1 U stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_W2
ID                       = 25;
variable_input_name{ID}  = 'dUdT_W2';
variable_output_name{ID} = 'dUdT_W2';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 2 U stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_W3
ID                       = 26;
variable_input_name{ID}  = 'dUdT_W3';
variable_output_name{ID} = 'dUdT_W3';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 3 U stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_W4
ID                       = 27;
variable_input_name{ID}  = 'dUdT_W4';
variable_output_name{ID} = 'dUdT_W4';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 4 U stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_W5
ID                       = 28;
variable_input_name{ID}  = 'dUdT_W5';
variable_output_name{ID} = 'dUdT_W5';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 5 U stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
%--------------------------------------------------------------------------
% dVdT_M1
ID                       = 29;
variable_input_name{ID}  = 'dVdT_M1';
variable_output_name{ID} = 'dVdT_M1';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 1 V stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dVdT_M2
ID                       = 30;
variable_input_name{ID}  = 'dVdT_M2';
variable_output_name{ID} = 'dVdT_M2';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 2 V stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dVdT_M3
ID                       = 31;
variable_input_name{ID}  = 'dVdT_M3';
variable_output_name{ID} = 'dVdT_M3';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 3 U stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dVdT_M4
ID                       = 32;
variable_input_name{ID}  = 'dVdT_M4';
variable_output_name{ID} = 'dVdT_M4';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 4 V stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dVdT_M5
ID                       = 33;
variable_input_name{ID}  = 'dVdT_M5';
variable_output_name{ID} = 'dVdT_M5';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 5 V stress sensitivity to SST';
variable_unit{ID}        = 'newton meter-2';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dVdT_W1
ID                       = 34;
variable_input_name{ID}  = 'dVdT_W1';
variable_output_name{ID} = 'dVdT_W1';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 1 V stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dVdT_W2
ID                       = 35;
variable_input_name{ID}  = 'dVdT_W2';
variable_output_name{ID} = 'dVdT_W2';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 1 V stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dUdT_W3
ID                       = 36;
variable_input_name{ID}  = 'dVdT_W3';
variable_output_name{ID} = 'dVdT_W3';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 3 U stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dVdT_W4
ID                       = 37;
variable_input_name{ID}  = 'dVdT_W4';
variable_output_name{ID} = 'dVdT_W4';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 4 V stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dVdT_W5
ID                       = 38;
variable_input_name{ID}  = 'dVdT_W5';
variable_output_name{ID} = 'dVdT_W5';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 5 V stress sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
%--------------------------------------------------------------------------
% dWdT_M1
ID                       = 39;
variable_input_name{ID}  = 'dWdT_M1';
variable_output_name{ID} = 'dWdT_M1';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 1 water flux sensitivity to SST';
variable_unit{ID}        = 'centimeter day-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dWdT_M2
ID                       = 40;
variable_input_name{ID}  = 'dWdT_M2';
variable_output_name{ID} = 'dWdT_M2';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 2 water flux sensitivity to SST';
variable_unit{ID}        = 'centimeter day-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dWdT_M3
ID                       = 41;
variable_input_name{ID}  = 'dWdT_M3';
variable_output_name{ID} = 'dWdT_M3';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 3 water flux sensitivity to SST';
variable_unit{ID}        = 'centimeter day-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dWdT_M4
ID                       = 42;
variable_input_name{ID}  = 'dWdT_M4';
variable_output_name{ID} = 'dWdT_M4';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 4 water flux sensitivity to SST';
variable_unit{ID}        = 'centimeter day-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dWdT_M5
ID                       = 43;
variable_input_name{ID}  = 'dWdT_M5';
variable_output_name{ID} = 'dWdT_M5';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'Mod 5 water flux sensitivity to SST';
variable_unit{ID}        = 'centimeter day-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dWdT_W1
ID                       = 44;
variable_input_name{ID}  = 'dWdT_W1';
variable_output_name{ID} = 'dWdT_W1';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 1 water flux sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dWdT_W2
ID                       = 45;
variable_input_name{ID}  = 'dWdT_W2';
variable_output_name{ID} = 'dWdT_W2';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 2 water flux sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dWdT_W3
ID                       = 46;
variable_input_name{ID}  = 'dWdT_W3';
variable_output_name{ID} = 'dWdT_W3';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 3 water flux sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dWdT_W4
ID                       = 47;
variable_input_name{ID}  = 'dWdT_W4';
variable_output_name{ID} = 'dWdT_W4';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 4 water flux sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;
% dWdT_W5
ID                       = 48;
variable_input_name{ID}  = 'dWdT_W5';
variable_output_name{ID} = 'dWdT_W5';
variable_time_name{ID}   = 'clm_time';
variable_coordinate{ID}  = 'rho';
variable_longname{ID}    = 'weight in mod 5 water flux sensitivity to SST';
variable_unit{ID}        = 'Celsius-1';
variable_scale_factor{ID}= 1;
variable_add_offset{ID}  = 0;


