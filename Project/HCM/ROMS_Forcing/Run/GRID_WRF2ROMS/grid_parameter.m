% Grid & Nesting condition
%--------------------------------------------------------------------------
WRF_grid    = [pwd,'/geo_em.d01.nc'];
ROMS_grid   = [Run_dir,'Data/Grd.nc'];

% Grid dimensions:
%--------------------------------------------------------------------------
hmin   =   5;      % Minimum depth [m]
hmax   =   5000;   % Maximum depth [m]

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
Topo_file  = ['E:/Topo/etopo1.nc'];
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

