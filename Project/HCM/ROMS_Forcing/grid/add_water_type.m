function add_water_type(ncfile, wtype_grid)

%
% ADD_SPONGE:  Adds sponge data to a ROMS Grid NetCDF file
%
% add_sponge(ncfile, visc_factor, diff_factor)
%
% Adds enhanced viscosity and diffusion scaling variables (visc_factor
% and diff_factor) to an existing ROMS Grid NetCDF file.  These scales
% are used in an application to set sponge areas with larger horizontal
% mixing coefficients for the damping of high frequency noise coming
% from open boundary conditions or nesting.  In ROMS, these scales are
% used as follows:
%
%    visc2_r(i,j) = visc2_r(i,j) * visc_factor(i,j)
%    visc4_r(i,j) = visc4_r(i,j) * visc_factor(i,j)
%
%    diff2(i,j,itrc) = diff2(i,j,itrc) * diff_factor(i,j)
%    diff4(i,j,itrc) = diff4(i,j,itrc) * diff_factor(i,j)
%
% where the variables 'visc_factor' and 'diff_factor' are defined at
% RHO-points.  Usually, sponges are linearly tapered over several grid
% points adjacent to the open boundaries.  Its positive values linearly
% increase from the inner to outer edges of the sponge. At the interior
% of the grid we can values of zero (no mixing) or one (regular mixing).
%
% NOTICE that it is more advantageous to specify these scaling factors
% in the ROMS Grid that coding it inside ROMS.  We can plot and adjust
% their values in an easy way in Matlab.
%
% On Input:
%
%    ncfile        GRID NetCDF file name (string)
%    visc_factor   Viscosity factor (2D array; nondimensional, positive)
%    diff_factor   Diffusivity factor (2D array; nondimensional, positive)
%

% svn $Id: add_sponge.m 754 2015-01-07 23:23:40Z arango $
%=========================================================================%
%  Copyright (c) 2002-2015 The ROMS/TOMS Group                            %
%    Licensed under a MIT/X style license                                 %
%    See License_ROMS.txt                           Hernan G. Arango      %
%=========================================================================%

%--------------------------------------------------------------------------
% Inquire grid NetCDF file.
%--------------------------------------------------------------------------

I = nc_inq_grid(ncfile);

got.wtype = any(strcmp({I.Variables.Name}, 'wtype_grid'));

if (any(strcmp({I.Variables.Name}, 'spherical'))),
  spherical = nc_read(ncfile, 'spherical');
  if (ischar(spherical)),
    if (spherical == 'T' || spherical == 't')
      spherical = true;
    else
      spherical = false;
    end
  end
else
  spherical = true;
end

%--------------------------------------------------------------------------
%  If appropriate, define sponge variables.
%--------------------------------------------------------------------------

ic = 0;

append_vars = false;

if (~got.wtype),
  ic = ic + 1;
  S.Dimensions = I.Dimensions;
  S.Variables(ic) = roms_metadata('wtype_grid', spherical);
  append_vars = true;
else
  disp(['Variable "wtype_grid" already exists. Updating its value']);
end


if (append_vars),
  check_metadata(S);
  nc_append(ncfile, S);
end

%--------------------------------------------------------------------------
%  Write out sponge variables into GRID NetCDF file.
%--------------------------------------------------------------------------

Lr = I.Dimensions(strcmp({I.Dimensions.Name},'xi_rho' )).Length;
Mr = I.Dimensions(strcmp({I.Dimensions.Name},'eta_rho')).Length;

[Im,Jm] = size(wtype_grid);

if (Im == Lr && Jm == Mr),
  nc_write(ncfile, 'wtype_grid', wtype_grid);
else
  error([' ADD_WTYPE_GRID: size(wtype_grid) is different to Lr = ',        ...
         num2str(Lr), blanks(3), 'Mr = ', num2str(Mr)]);	 
end

return
