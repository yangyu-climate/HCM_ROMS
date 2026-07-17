function create_inifile(inifile,gridfile,title,...
                         theta_s,theta_b,hc,N,time,clobber,vtransform)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  function nc=create_inifile(inifile,gridfile,theta_s,...
%                  theta_b,hc,N,ttime,stime,utime,... 
%                  cycle,clobber)
%
%   This function create the header of a Netcdf climatology 
%   file.
%
%   Input: 
% 
%   inifile      Netcdf initial file name (character string).
%   gridfile     Netcdf grid file name (character string).
%   theta_s      S-coordinate surface control parameter.(Real)
%   theta_b      S-coordinate bottom control parameter.(Real)
%   hc           Width (m) of surface or bottom boundary layer
%                where higher vertical resolution is required 
%                during stretching.(Real)
%   N            Number of vertical levels.(Integer)  
%   time         Initial time.(Real) 
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
disp(' ')
disp([' Creating the file : ',inifile])
if nargin < 10
   disp([' NO VTRANSFORM parameter found'])
   disp([' USE TRANSFORM default value vtransform = 1'])
   vtransform = 1; 
end
disp([' VTRANSFORM = ',num2str(vtransform)])
%
%  Read the grid file
%
nc=netcdf(gridfile);
h=nc{'h'}(:);  
mask=nc{'mask_rho'}(:);
close(nc);
hmin=min(min(h(mask==1)));
if vtransform ==1;
    if hc > hmin
        error([' hc (',num2str(hc),' m) > hmin (',num2str(hmin),' m)'])
    end
end
[Mp,Lp]=size(h);
L=Lp-1;
M=Mp-1;
Np=N+1;
%
%  Create the initial file
%
type = 'INITIAL file' ; 
history = 'ROMS' ;
%
%  Create variables
%
nccreate(inifile,'spherical'  ,'Dimensions',{'one',1}    ,'Datatype','char')
nccreate(inifile,'Vtransform' ,'Dimensions',{'one',1}    ,'Datatype','int8')
nccreate(inifile,'Vstretching','Dimensions',{'one',1}    ,'Datatype','int8')
nccreate(inifile,'tstart'     ,'Dimensions',{'one',1}    ,'Datatype','double')
nccreate(inifile,'tend'       ,'Dimensions',{'one',1}    ,'Datatype','double')
nccreate(inifile,'theta_s'    ,'Dimensions',{'one',1}    ,'Datatype','double')
nccreate(inifile,'theta_b'    ,'Dimensions',{'one',1}    ,'Datatype','double')
nccreate(inifile,'Tcline'     ,'Dimensions',{'one',1}    ,'Datatype','double')
nccreate(inifile,'hc'         ,'Dimensions',{'one',1}    ,'Datatype','double')
nccreate(inifile,'sc_r'       ,'Dimensions',{'s_rho' ,N} ,'Datatype','double')
nccreate(inifile,'Cs_r'       ,'Dimensions',{'s_rho' ,N} ,'Datatype','double')
nccreate(inifile,'ocean_time' ,'Dimensions',{'time'  ,1} ,'Datatype','double')
nccreate(inifile,'scrum_time' ,'Dimensions',{'time'  ,1} ,'Datatype','double')
nccreate(inifile,'u'          ,'Dimensions',{'xi_u'  ,L  ,'eta_u'  ,Mp,'s_rho' ,N,'time' ,1},'Datatype','double')
nccreate(inifile,'v'          ,'Dimensions',{'xi_v'  ,Lp ,'eta_v'  ,M ,'s_rho' ,N,'time' ,1},'Datatype','double')
nccreate(inifile,'ubar'       ,'Dimensions',{'xi_u'  ,L  ,'eta_u'  ,Mp,'time'  ,1},'Datatype','double')
nccreate(inifile,'vbar'       ,'Dimensions',{'xi_v'  ,Lp ,'eta_v'  ,M ,'time'  ,1},'Datatype','double')
nccreate(inifile,'zeta'       ,'Dimensions',{'xi_rho',Lp ,'eta_rho',Mp,'time'  ,1},'Datatype','double')
nccreate(inifile,'temp'       ,'Dimensions',{'xi_rho',Lp ,'eta_rho',Mp,'s_rho' ,N,'time' ,1},'Datatype','double')
nccreate(inifile,'salt'       ,'Dimensions',{'xi_rho',Lp ,'eta_rho',Mp,'s_rho' ,N,'time' ,1},'Datatype','double')
%
%  Create attributes
%
nc = netcdf(inifile,clobber);
%
nc{'Vtransform'}.long_name = ncchar('vertical terrain-following transformation equation');
nc{'Vtransform'}.long_name = 'vertical terrain-following transformation equation';
%
nc{'Vstretching'}.long_name = ncchar('vertical terrain-following stretching function');
nc{'Vstretching'}.long_name = 'vertical terrain-following stretching function';
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
nc{'sc_r'}.units = ncchar('nondimensional');
nc{'sc_r'}.units = 'nondimensional';
nc{'sc_r'}.valid_min = -1;
nc{'sc_r'}.valid_max = 0;
%
nc{'Cs_r'}.long_name = ncchar('S-coordinate stretching curves at RHO-points');
nc{'Cs_r'}.long_name = 'S-coordinate stretching curves at RHO-points';
nc{'Cs_r'}.units = ncchar('nondimensional');
nc{'Cs_r'}.units = 'nondimensional';
nc{'Cs_r'}.valid_min = -1;
nc{'Cs_r'}.valid_max = 0;
%
nc{'ocean_time'}.long_name = ncchar('time since initialization');
nc{'ocean_time'}.long_name = 'time since initialization';
nc{'ocean_time'}.units = ncchar('second');
nc{'ocean_time'}.units = 'second';
%
nc{'scrum_time'}.long_name = ncchar('time since initialization');
nc{'scrum_time'}.long_name = 'time since initialization';
nc{'scrum_time'}.units = ncchar('second');
nc{'scrum_time'}.units = 'second';
%
nc{'u'}.long_name = ncchar('u-momentum component');
nc{'u'}.long_name = 'u-momentum component';
nc{'u'}.units = ncchar('meter second-1');
nc{'u'}.units = 'meter second-1';
%
nc{'v'}.long_name = ncchar('v-momentum component');
nc{'v'}.long_name = 'v-momentum component';
nc{'v'}.units = ncchar('meter second-1');
nc{'v'}.units = 'meter second-1';
%
nc{'ubar'}.long_name = ncchar('vertically integrated u-momentum component');
nc{'ubar'}.long_name = 'vertically integrated u-momentum component';
nc{'ubar'}.units = ncchar('meter second-1');
nc{'ubar'}.units = 'meter second-1';
%
nc{'vbar'}.long_name = ncchar('vertically integrated v-momentum component');
nc{'vbar'}.long_name = 'vertically integrated v-momentum component';
nc{'vbar'}.units = ncchar('meter second-1');
nc{'vbar'}.units = 'meter second-1';
%
nc{'zeta'}.long_name = ncchar('free-surface');
nc{'zeta'}.long_name = 'free-surface';
nc{'zeta'}.units = ncchar('meter');
nc{'zeta'}.units = 'meter';
%
nc{'temp'}.long_name = ncchar('potential temperature');
nc{'temp'}.long_name = 'potential temperature';
nc{'temp'}.units = ncchar('Celsius');
nc{'temp'}.units = 'Celsius';
%
nc{'salt'}.long_name = ncchar('salinity');
nc{'salt'}.long_name = 'salinity';
nc{'salt'}.units = ncchar('PSU');
nc{'salt'}.units = 'PSU';
%
% Create global attributes
%
nc.title = ncchar(title);
nc.title = title;
nc.date = ncchar(date);
nc.date = date;
nc.clim_file = ncchar(inifile);
nc.clim_file = inifile;
nc.grd_file = ncchar(gridfile);
nc.grd_file = gridfile;
nc.type = ncchar(type);
nc.type = type;
nc.history = ncchar(history);
nc.history = history;
close(nc)
%
% Compute S coordinates
%
[sc_r,Cs_r,sc_w,Cs_w] = scoordinate(theta_s,theta_b,N,hc,vtransform);
%disp(['vtransform=',num2str(vtransform)])

%
% Write variables
%
ncwrite(inifile,'spherical','T')
ncwrite(inifile,'Vtransform',vtransform)
if vtransform==1
    ncwrite(inifile,'Vstretching',1)
else
    ncwrite(inifile,'Vstretching',4)
end
ncwrite(inifile,'tstart'    , time)
ncwrite(inifile,'tend'      , time)
ncwrite(inifile,'theta_s'   , theta_s)
ncwrite(inifile,'theta_b'   , theta_b)
ncwrite(inifile,'Tcline'    , hc)
ncwrite(inifile,'hc'        , hc)
ncwrite(inifile,'sc_r'      , sc_r)
ncwrite(inifile,'Cs_r'      , Cs_r)
ncwrite(inifile,'scrum_time', time*24*3600)
ncwrite(inifile,'ocean_time', time*24*3600)
ncwrite(inifile,'u'         , zeros(L ,Mp,N,length(time)))
ncwrite(inifile,'v'         , zeros(Lp,M ,N,length(time)))
ncwrite(inifile,'ubar'      , zeros(L ,Mp,length(time)))
ncwrite(inifile,'vbar'      , zeros(Lp,M ,length(time)))
ncwrite(inifile,'temp'     , zeros(Lp,Mp,N,length(time)))
ncwrite(inifile,'salt'     , zeros(Lp,Mp,N,length(time)))



