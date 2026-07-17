% Time control
%--------------------------------------------------------------------------
Time_beg  = [2020  6  1  0 0 0];
Time_end  = [2020  10 1 0 0 0];
Time_ref  = [2020  6  1  0 0 0];
Time_frq  = 1; %Forcing Frequency in Day
%--------------------------------------------------------------------------
variable_number = 1;
% SST
variable_input_name{1}  = 'analysed_sst';
variable_output_name{1} = 'SST';
variable_time_name{1}   = 'sst_time';
variable_coordinate{1}  = 'rho';
variable_longname{1}    = 'sea surface temperature';
variable_unit{1}        = 'Celsius';
variable_scale_factor{1}= 1;
variable_add_offset{1}  = -273.15;
%--------------------------------------------------------------------------
