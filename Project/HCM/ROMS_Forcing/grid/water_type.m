function S = water_type (Gname, varargin)

%
% SPONGE: Set diffusion and viscosity sponge coefficients
%
% S = sponge (Gname, factor, Nfilter, Lplot, Lwrite)
%
% Given a grid application NetCDF file, this function computes enhanced
% viscosity and diffusion scaling variables (visc_factor and diff_factor)
% that can be added input ROMS Grid NetCDF file. These scales are used
% in an application to set sponge areas with larger horizontal mixing
% coefficients for the damping of high frequency noise coming from open
% boundary conditions or nesting. In ROMS, these scales are used as
% follows:
%
%   visc2_r(i,j) = visc2_r(i,j) * visc_factor(i,j)
%   visc4_r(i,j) = visc4_r(i,j) * visc_factor(i,j)
%
%   diff2(i,j,itrc) = diff2(i,j,itrc) * diff_factor(i,j)
%   diff4(i,j,itrc) = diff4(i,j,itrc) * diff_factor(i,j)
%
% where visc_factor and diff_factor are defined at RHO-points. Usually,
% sponges are linearly tapered over several grid points adjacent to the
% open boundaries. Its positive values linearly increases from the inner
% to outer edges of the sponge. At the interior of the grid we can values
% of zero (no mixing) or one (regular mixing). 
%
% On Input:
%
%    Gname        ROMS Grid NetCDF file name (character string)
%
%    factor       Sponge enhancement factor (default: 3.0)
%
%    Nfilter      Number of passes of 3-point 2-D boxcar filter. It
%                   determines sponge width (default: 25)
%
%    Lplot        Switch to plot sponge variables (default: false)
%
%    Lwrite       Switch to add/write sponge variables to GRID NetCDF
%                   file (default: false)
%
% On Output:
%
%    S           Nested grids Contact Points structure (struct array)
%
%                  S.lon_rho               longitude of RHO-points
%                  S.lat_rho               latitude  of RHO-points
%                  S.mask_rho              land/sea mask at RHO-points
%                  S.diff_factor           diffusivity factor
%                  S.visc_factor           viscosity factor
%
% Methodology:
%  
% The generic method (John Wilkin; 2014) is to start out by setting
% perimeter values of a 2-D RHO-points array equal to 1 along open
% boundary "wet" points of the RHO-points mask and have zeroes elsewhere.
% Then, apply several passes of a 3x3 convolution operator to diffuse
% the non-zero perimeter values into the ocean interior. This means that
% where the very edge of the grid is masked land those points do not
% become part of the sponge. Simply setting all points within some range
% next to edge (as was done by the default analytical sponge functions
% in ROMS: ana_hmixcoef.h and now in ana_sponge.h) can introduce elevated
% viscosity/diffusivity in bays and rivers that fall close to the edges
% of the computational domain.
%
  
% svn $Id: sponge.m 754 2015-01-07 23:23:40Z arango $
%=========================================================================%
%  Copyright (c) 2002-2015 The ROMS/TOMS Group                            %
%    Licensed under a MIT/X style license           Hernan G. Arango      %
%    See License_ROMS.txt                                John Wilkin      %
%=========================================================================%

% Initialize.

h_critical = 200;
mask_type  = 4;
Lplot      = false;
Lwrite     = false;


switch numel(varargin)
  case 1
    h_critical = varargin{1};
  case 2
    h_critical = varargin{1};
    mask_type  = varargin{2};
  case 3
    h_critical = varargin{1};
    mask_type  = varargin{2};
    Lplot      = varargin{3};
  case 4
    h_critical = varargin{1};
    mask_type  = varargin{2};
    Lplot      = varargin{3};
    Lwrite     = varargin{4};
    
end

%--------------------------------------------------------------------------
% Get ROMS grid structure.
%--------------------------------------------------------------------------

G = get_roms_grid(Gname);

S.lon_rho = G.lon_rho;
S.lat_rho = G.lat_rho;
S.mask_rho = G.mask_rho;

H = G.h;

WTYPE = ones(size(G.h));
WTYPE(find(H < h_critical)) = mask_type;

S.wtype_grid = WTYPE;

S

%--------------------------------------------------------------------------
% Plot wtype_grid
%--------------------------------------------------------------------------

if (Lplot),
  figure;
% contourf(G.lon_rho, G.lat_rho, nanland(S.diff_factor,G));
  pcolorjw(G.lon_rho, G.lat_rho, nanland(S.wtype_grid,G));
  title('Water Type')
  colorbar;
end

%--------------------------------------------------------------------------
% If appropriate, add/write wtype coefficient to GRID NetCDF file.
%--------------------------------------------------------------------------

if (Lwrite)
  add_water_type(Gname, S.wtype_grid)
%   sponge_info = [datestr(now,1) ' created with ' which(mfilename)       ...
%                  ': factor = ', num2str(factor)                         ...             
%                  ', Nfilter = ', num2str(Nfilter)];
%   status = nc_attadd(Gname, 'sponge', sponge_info);
end

