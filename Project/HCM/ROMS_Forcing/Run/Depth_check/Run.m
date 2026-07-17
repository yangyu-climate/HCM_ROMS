clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start

depth       = 100;
theta_s     = 4.5;
theta_b     = 1.5;
hc          = 5;
layer_N     = 50;
vtransform  = 2;

Depth  = -zlevs(depth,0,theta_s,theta_b,hc,layer_N,'r',vtransform);
dDepth =  zlevs(depth,0,theta_s,theta_b,hc,layer_N,'w',vtransform);
dDepth = diff(dDepth);


DD(:,1) = Depth;
DD(:,2) = dDepth;
