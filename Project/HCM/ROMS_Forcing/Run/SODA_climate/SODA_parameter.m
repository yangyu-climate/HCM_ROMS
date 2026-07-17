% Time and coordinate control
%--------------------------------------------------------------------------
title       = 'HCM';
obc         = [1 1 1 1];
theta_s     = 6.5;
theta_b     = 0.5;
hc          = 5;
layer_N     = 50;
zeta0       =-0;
Tcycle      = 360;
%--------------------------------------------------------------------------
data_file   = ['D:\Data\SODA\SODA3.nc'];
%--------------------------------------------------------------------------

% Topo smoothing:
%--------------------------------------------------------------------------
% Slope parameter (r=grad(h)/h) maximum value for topography smoothing
rtarget = 0.35;

% Number of pass of a selective filter to reduce the isolated
% seamounts on the deep ocean.
n_filter_deep_topo=1;

% Number of pass of a single hanning filter at the end of the
% smooting procedure to ensure that there is no 2DX noise in the 
% topography.
n_filter_final=1;

hmin   =   5;      % Minimum depth [m]
hmax   =   5000;   % Maximum depth [m]