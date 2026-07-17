function create_climfile(clmname,grdname,title,...
                         theta_s,theta_b,hc,N,...
                         time,cycle,clobber,vtransform)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function create_climfile(clmname,grdname,title,...
%                          theta_s,theta_b,hc,N,...
%                          time,cycle,clobber);
%
%   This function create the header of a Netcdf climatology 
%   file.
%
%   Input:
%
%   clmname      Netcdf climatology file name (character string).
%   grdname      Netcdf grid file name (character string).
%   theta_s      S-coordinate surface control parameter.(Real) 
%   theta_b      S-coordinate bottom control parameter.(Real)
%   hc           Width (m) of surface or bottom boundary layer
%                where higher vertical resolution is required
%                during stretching.(Real) 
%   N            Number of vertical levels.(Integer) 
%   time        Temperature climatology time.(vector) 
%   time        Salinity climatology time.(vector)
%   time        Velocity climatology time.(vector)
%   cycle        Length (days) for cycling the climatology.(Real)
%   clobber      Switch to allow or not writing over an existing 
%                file.(character string)
%
%   Output
%
%   nc       Output netcdf object.
% 
%  Further Information:  
%  http://www.brest.ird.fr/Roms_tools/
%  
%  This file is part of ROMSTOOLS
%
%  ROMSTOOLS is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published
%  by the Free Software Foundation; either version 2 of the License,
%  or (at your option) any later version.
%
%  ROMSTOOLS is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program; if not, write to the Free Software
%  Foundation, Inc., 59 Temple Place, Suite 330, Boston,
%  MA  02111-1307  USA
%
%  Copyright (c) 2001-2006 by Pierrick Penven 
%  e-mail:Pierrick.Penven@ird.fr  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp([' Creating the file : ',clmname])
if nargin < 11
   disp([' NO VTRANSFORM parameter found'])
   disp([' USE TRANSFORM default value vtransform = 1'])
    vtransform = 1; 
end
disp([' VTRANSFORM = ',num2str(vtransform)])
%
%  Read the grid file
%
nc = netcdf(grdname, 'nowrite');
h=nc{'h'}(:);
maskr=nc{'mask_rho'}(:);
Lp=length(nc('xi_rho'));
Mp=length(nc('eta_rho'));
status=close(nc);
hmin=min(min(h(maskr==1)));
if vtransform ==1;
  if hc > hmin
    error([' hc (',num2str(hc),' m) > hmin (',num2str(hmin),' m)'])
  end
end
L=Lp-1;
M=Mp-1;
Np=N+1;
%
%  Create the climatology file
%
type = 'CLIMATOLOGY file' ; 
history = 'ROMS' ;
%
%  Create variables
%
nccreate(clmname,'spherical'  ,'Dimensions',{'one',1}   ,'Datatype','char')
nccreate(clmname,'Vtransform' ,'Dimensions',{'one',1}   ,'Datatype','int8')
nccreate(clmname,'Vstretching','Dimensions',{'one',1}   ,'Datatype','int8')
nccreate(clmname,'tstart'     ,'Dimensions',{'one',1}   ,'Datatype','double')
nccreate(clmname,'tend'       ,'Dimensions',{'one',1}   ,'Datatype','double')
nccreate(clmname,'theta_s'    ,'Dimensions',{'one',1}   ,'Datatype','double')
nccreate(clmname,'theta_b'    ,'Dimensions',{'one',1}   ,'Datatype','double')
nccreate(clmname,'Tcline'     ,'Dimensions',{'one',1}   ,'Datatype','double')
nccreate(clmname,'hc'         ,'Dimensions',{'one',1}   ,'Datatype','double')
nccreate(clmname,'sc_r'       ,'Dimensions',{'s_rho',N} ,'Datatype','double')
nccreate(clmname,'sc_w'       ,'Dimensions',{'s_w'  ,Np},'Datatype','double')
nccreate(clmname,'Cs_r'       ,'Dimensions',{'s_rho',N} ,'Datatype','double')
nccreate(clmname,'Cs_w'       ,'Dimensions',{'s_w'  ,Np} ,'Datatype','double')
nccreate(clmname,'temp_time'  ,'Dimensions',{'tclm_time',length(time)},'Datatype','double')
nccreate(clmname,'salt_time'  ,'Dimensions',{'tclm_time',length(time)},'Datatype','double')
nccreate(clmname,'temp'       ,'Dimensions',{'xi_rho',Lp,'eta_rho',Mp,'s_rho',N,'tclm_time',length(time)},'Datatype','double')
nccreate(clmname,'salt'       ,'Dimensions',{'xi_rho',Lp,'eta_rho',Mp,'s_rho',N,'tclm_time',length(time)},'Datatype','double')
%
%  Create attributes
%
nc = netcdf(clmname,clobber);
%
nc{'Vtransform'}.long_name = ncchar('vertical terrain-following transformation equation');
nc{'Vtransform'}.long_name = 'vertical terrain-following transformation equation';
%
nc{'Vstretching'}.long_name = ncchar('vertical terrain-following stretching function');
nc{'Vstretching'}.long_name = 'vertical terrain-following stretching function';
%
nc{'spherical'}.long_name = ncchar('grid type logical switch');
nc{'spherical'}.long_name = 'grid type logical switch';
nc{'spherical'}.flag_values = ncchar('T, F');
nc{'spherical'}.flag_values = 'T, F';
nc{'spherical'}.flag_meanings = ncchar('spherical Cartesian');
nc{'spherical'}.flag_meanings = 'spherical Cartesian';
%
nc{'tstart'}.long_name = ncchar('start processing day');
nc{'tstart'}.long_name = 'start processing day';
nc{'tstart'}.units = ncchar('day');
nc{'tstart'}.units = 'day';
%
nc{'tend'}.long_name = ncchar('end processing day');
nc{'tend'}.long_name = 'end processing day';
nc{'tend'}.units = ncchar('day');
nc{'tend'}.units = 'day';
%
nc{'theta_s'}.long_name = ncchar('S-coordinate surface control parameter');
nc{'theta_s'}.long_name = 'S-coordinate surface control parameter';
nc{'theta_s'}.units = ncchar('nondimensional');
nc{'theta_s'}.units = 'nondimensional';
%
nc{'theta_b'}.long_name = ncchar('S-coordinate bottom control parameter');
nc{'theta_b'}.long_name = 'S-coordinate bottom control parameter';
nc{'theta_b'}.units = ncchar('nondimensional');
nc{'theta_b'}.units = 'nondimensional';
%
nc{'Tcline'}.long_name = ncchar('S-coordinate surface/bottom layer width');
nc{'Tcline'}.long_name = 'S-coordinate surface/bottom layer width';
nc{'Tcline'}.units = ncchar('meter');
nc{'Tcline'}.units = 'meter';
%
nc{'hc'}.long_name = ncchar('S-coordinate parameter, critical depth');
nc{'hc'}.long_name = 'S-coordinate parameter, critical depth';
nc{'hc'}.units = ncchar('meter');
nc{'hc'}.units = 'meter';
%
nc{'sc_r'}.long_name = ncchar('S-coordinate at RHO-points');
nc{'sc_r'}.long_name = 'S-coordinate at RHO-points';
nc{'sc_r'}.valid_min = -1.;
nc{'sc_r'}.valid_max = 0.;
nc{'sc_r'}.positive = ncchar('up');
nc{'sc_r'}.positive = 'up';
if (vtransform ==1)
    nc{'sc_r'}.standard_name = ncchar('ocena_s_coordinate_g1');
    nc{'sc_r'}.standard_name = 'ocena_s_coordinate_g1';
elseif (vtransform ==2)
    nc{'sc_r'}.standard_name = ncchar('ocena_s_coordinate_g2');
    nc{'sc_r'}.standard_name = 'ocena_s_coordinate_g2';     
end
nc{'sc_r'}.formula_terms = ncchar('s: s_rho C: Cs_r eta: zeta depth: h depth_c: hc');
nc{'sc_r'}.formula_terms = 's: s_rho C: Cs_r eta: zeta depth: h depth_c: hc';
%
nc{'sc_w'}.long_name = ncchar('S-coordinate at W-points');
nc{'sc_w'}.long_name = 'S-coordinate at W-points';
nc{'sc_w'}.valid_min = -1. ;
nc{'sc_w'}.valid_max = 0. ;
nc{'sc_w'}.positive = ncchar('up');
nc{'sc_w'}.positive = 'up';
if (vtransform == 1)
    nc{'sc_w'}.standard_name = ncchar('ocena_s_coordinate_g1');
    nc{'sc_w'}.standard_name = 'ocena_s_coordinate_g1';
elseif (vtransform == 2)
    nc{'sc_w'}.standard_name = ncchar('ocena_s_coordinate_g2');
    nc{'sc_w'}.standard_name = 'ocena_s_coordinate_g2';
end
nc{'sc_w'}.formula_terms = ncchar('s: s_w C: Cs_w eta: zeta depth: h depth_c: hc');
nc{'sc_w'}.formula_terms = 's: s_w C: Cs_w eta: zeta depth: h depth_c: hc';
%
nc{'Cs_r'}.long_name = ncchar('S-coordinate stretching curves at RHO-points');
nc{'Cs_r'}.long_name = 'S-coordinate stretching curves at RHO-points';
nc{'Cs_r'}.units = ncchar('nondimensional');
nc{'Cs_r'}.units = 'nondimensional';
nc{'Cs_r'}.valid_min = -1;
nc{'Cs_r'}.valid_max = 0;
%
nc{'Cs_w'}.long_name = ncchar('S-coordinate stretching curves at W-points');
nc{'Cs_w'}.long_name = 'S-coordinate stretching curves at W-points';
nc{'Cs_w'}.units = ncchar('nondimensional');
nc{'Cs_w'}.units = 'nondimensional';
nc{'Cs_w'}.valid_min = -1;
nc{'Cs_w'}.valid_max = 0;
%
nc{'temp_time'}.long_name = ncchar('time for temperature climatology');
nc{'temp_time'}.long_name = 'time for temperature climatology';
nc{'temp_time'}.units = ncchar('day');
nc{'temp_time'}.units = 'day';
nc{'temp_time'}.calendar = ncchar('360.0 days in every year');
nc{'temp_time'}.calendar = '360.0 days in every year';
nc{'temp_time'}.cycle_length = cycle;
%
nc{'salt_time'}.long_name = ncchar('time for salinity climatology');
nc{'salt_time'}.long_name = 'time for salinity climatology';
nc{'salt_time'}.units = ncchar('day');
nc{'salt_time'}.units = 'day';
nc{'salt_time'}.calendar = ncchar('360.0 days in every year');
nc{'salt_time'}.calendar = '360.0 days in every year';
nc{'salt_time'}.cycle_length = cycle;
%
nc{'temp'}.long_name = ncchar('potential temperature');
nc{'temp'}.long_name = 'potential temperature';
nc{'temp'}.units = ncchar('Celsius');
nc{'temp'}.units = 'Celsius';
nc{'temp'}.time = ncchar('temp_time');
nc{'temp'}.time = 'temp_time';
nc{'temp'}.coordinates = ncchar('lon_rho lat_rho s_rho temp_time');
nc{'temp'}.coordinates = 'lon_rho lat_rho s_rho temp_time';
%
nc{'salt'}.long_name = ncchar('salinity');
nc{'salt'}.long_name = 'salinity';
nc{'salt'}.units = ncchar('PSU');
nc{'salt'}.units = 'PSU';
nc{'salt'}.time = ncchar('salt_time');
nc{'salt'}.time = 'salt_time';
nc{'salt'}.coordinates = ncchar('lon_rho lat_rho s_rho salt_time');
nc{'salt'}.coordinates = 'lon_rho lat_rho s_rho salt_time';
%
% Create global attributes
%
nc.title = ncchar(title);
nc.title = title;
nc.date = ncchar(date);
nc.date = date;
nc.clim_file = ncchar(clmname);
nc.clim_file = clmname;
nc.grd_file = ncchar(grdname);
nc.grd_file = grdname;
nc.type = ncchar(type);
nc.type = type;
nc.history = ncchar(history);
nc.history = history;
close(nc)
%
% Set S-Curves in domain [-1 < sc < 0] at vertical W- and RHO-points.
%
[sc_r,Cs_r,sc_w,Cs_w] = scoordinate(theta_s,theta_b,N,hc,vtransform);
%disp(['vtransform=',num2str(vtransform)])

% cff1=1./sinh(theta_s);
% cff2=0.5/tanh(0.5*theta_s);
% sc_r=((1:N)-N-0.5)/N;
% Cs_r=(1.-theta_b)*cff1*sinh(theta_s*sc_r)...
%     +theta_b*(cff2*tanh(theta_s*(sc_r+0.5))-0.5);
% sc_w=((0:N)-N)/N;
% Cs_w=(1.-theta_b)*cff1*sinh(theta_s*sc_w)...
%     +theta_b*(cff2*tanh(theta_s*(sc_w+0.5))-0.5);


%
% Write variables
%
ncwrite(clmname,'spherical','T')
ncwrite(clmname,'Vtransform',vtransform)
if vtransform==1
    ncwrite(clmname,'Vstretching',1)
else
    ncwrite(clmname,'Vstretching',4)
end
ncwrite(clmname,'tstart' , min([min(time) min(time) min(time)]))
ncwrite(clmname,'tend'   , max([max(time) max(time) max(time)]))
ncwrite(clmname,'theta_s', theta_s)
ncwrite(clmname,'theta_b', theta_b)
ncwrite(clmname,'Tcline' , hc)
ncwrite(clmname,'hc'     , hc)
ncwrite(clmname,'sc_r'   , sc_r)
ncwrite(clmname,'sc_w'   , sc_w)
ncwrite(clmname,'Cs_r'   , Cs_r)
ncwrite(clmname,'Cs_w'   , Cs_w)
ncwrite(clmname,'temp_time', time)
ncwrite(clmname,'salt_time', time)
ncwrite(clmname,'temp'     , zeros(Lp,Mp,N,length(time)))
ncwrite(clmname,'salt'     , zeros(Lp,Mp,N,length(time)))



