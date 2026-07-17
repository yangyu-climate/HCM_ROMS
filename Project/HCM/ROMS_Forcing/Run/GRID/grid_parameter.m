% Grid dimensions:
%--------------------------------------------------------------------------
lonmin =   95.0;   % Minimum longitude [degree east]
lonmax =  290.0;   % Maximum longitude [degree east]
latmin =  -30.0;   % Minimum latitude  [degree north]
latmax =   30.0;   % Maximum latitude  [degree north]
dl     =    1/2;   % Grid resolution   [degree]

hmin   =   5;      % Minimum depth [m]
hmax   =   5000;   % Maximum depth [m]

IF_ISO =   0;      % If use an isotropic grid
IF_GLB =   0;      % If a global channel model

% Grid & Nesting condition
%--------------------------------------------------------------------------
Grid_file   = [Run_dir,'Data/Grd.nc'];
contactname = [Run_dir,'Data/ROMS_contact.nc'];
max_dom     = 1;
parent_id   = [0   1   1];
Istr        = [0  20 196]; 
Iend        = [0 370 366]; 
Jstr        = [0  30 250]; 
Jend        = [0 200 350];
grid_ratio  = [0   3   3];

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

% Topo data file
%--------------------------------------------------------------------------
Topo_file  = ['D:/Data/Topo/etopo1.nc'];
Topo_lon   = 'lon';
Topo_lat   = 'lat';
Topo_var   = 'topo';

% Coast file
%--------------------------------------------------------------------------
%  GSHSS user defined coastline (see m_map) 
%  XXX_f.mat    Full resolution data
%  XXX_h.mat    High resolution data
%  XXX_i.mat    Intermediate resolution data
%  XXX_l.mat    Low resolution data
%  XXX_c.mat    Crude resolution data
mkdir([pwd,'/coastline'])
coastfileplot = [pwd,'/coastline/coastline_l.mat'];
coastfilemask = [pwd,'/coastline/coastline_l_mask.mat'];
%--------------------------------------------------------------------------

