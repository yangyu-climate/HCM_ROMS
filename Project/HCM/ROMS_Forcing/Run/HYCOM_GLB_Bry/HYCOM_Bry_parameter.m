% Time and coordinate control
%--------------------------------------------------------------------------
title       = 'RESM';
time_begin  = [2020 6  1 0 0 0];
time_end    = [2020 6  2 0 0 0];
obc         = [1 1 1 1];
theta_s     = 4.5;
theta_b     = 1.5;
hc          = 5;
layer_N     = 50;       
%--------------------------------------------------------------------------
Data_dir    = ['/zeolite/clarkyu/work/Data/HYCOM/ROMS_OA_Analysis'];
IF_Separate = 1;
add_to_ssh  = '_ssh';
add_to_temp = '_ts3z';
add_to_salt = '_ts3z';
add_to_u    = '_uv3z';
add_to_v    = '_uv3z';
%--------------------------------------------------------------------------
