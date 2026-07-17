clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start

make_ERA5_met_file
make_ERA5_prepare
make_surface_forcing

