clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start

make_WRF_met_file
make_WRF_prepare
make_surface_forcing

