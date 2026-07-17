function create_oafile(oaname,grdname,title,Z,...
                       time,cycle,clobber)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  function nc=create_oafile(oaname,grdname,title,Z,...
%                       time,cycle,clobber);
%
%   This function create the header of a Netcdf OA
%   file. ie an intermediate file on a Z-grid.
%
%   Input: 
% 
%   oaname       Netcdf OA file name (character string).
%   grdname      Netcdf grid file name (character string).
%   Z            Vertical levels.(Vector)  
%   time         OA time.(Vector) 
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
disp([' Creating the file : ',oaname])
%
%  Read the grid file
%
nc = netcdf(grdname, 'nowrite');
lonr=nc{'lon_rho'}(:);
latr=nc{'lat_rho'}(:);
lonu=nc{'lon_u'}(:);
latu=nc{'lat_u'}(:);
lonv=nc{'lon_v'}(:);
latv=nc{'lat_v'}(:);
status=close(nc);
[Mp,Lp]=size(lonr);
L=Lp-1;
M=Mp-1;
%
%  Create the climatology file
%
type = 'OA file' ; 
history = 'ROMS' ;
%
%  Create variables
%
nccreate(oaname,'lon_rho'  ,'Dimensions',{'xi_rho',Lp,'eta_rho',Mp},'Datatype','double')
nccreate(oaname,'lat_rho'  ,'Dimensions',{'xi_rho',Lp,'eta_rho',Mp},'Datatype','double')
nccreate(oaname,'lon_u'    ,'Dimensions',{'xi_u'  ,L ,'eta_rho',Mp},'Datatype','double')
nccreate(oaname,'lat_u'    ,'Dimensions',{'xi_u'  ,L ,'eta_rho',Mp},'Datatype','double')
nccreate(oaname,'lon_v'    ,'Dimensions',{'xi_rho',Lp,'eta_v'  ,M },'Datatype','double')
nccreate(oaname,'lat_v'    ,'Dimensions',{'xi_rho',Lp,'eta_v'  ,M },'Datatype','double')
nccreate(oaname,'Z'        ,'Dimensions',{'Z'           ,length(Z)},'Datatype','double')
nccreate(oaname,'tclm_time','Dimensions',{'tclm_time',length(time)},'Datatype','double')
nccreate(oaname,'sclm_time','Dimensions',{'sclm_time',length(time)},'Datatype','double')
nccreate(oaname,'temp'     ,'Dimensions',{'xi_rho',Lp,'eta_rho',Mp,'Z',length(Z),'tclm_time',length(time)},'Datatype','double')
nccreate(oaname,'salt'     ,'Dimensions',{'xi_rho',Lp,'eta_rho',Mp,'Z',length(Z),'tclm_time',length(time)},'Datatype','double')
%
%  Create attributes
%
nc = netcdf(oaname,clobber);
%
nc{'lon_rho'}.long_name = ncchar('longitude of RHO-points');
nc{'lon_rho'}.long_name = 'longitude of RHO-points';
nc{'lon_rho'}.units = ncchar('degree_east');
nc{'lon_rho'}.units = 'degree_east';
%
nc{'lat_rho'}.latg_name = ncchar('latitude of RHO-points');
nc{'lat_rho'}.latg_name = 'latitude of RHO-points';
nc{'lat_rho'}.units = ncchar('degree_north');
nc{'lat_rho'}.units = 'degree_north';
%
nc{'lon_u'}.long_name = ncchar('longitude of U-points');
nc{'lon_u'}.long_name = 'longitude of U-points';
nc{'lon_u'}.units = ncchar('degree_east');
nc{'lon_u'}.units = 'degree_east';
%
nc{'lat_u'}.latg_name = ncchar('latitude of U-points');
nc{'lat_u'}.latg_name = 'latitude of U-points';
nc{'lat_u'}.units = ncchar('degree_north');
nc{'lat_u'}.units = 'degree_north';
%
nc{'lon_v'}.long_name = ncchar('longitude of V-points');
nc{'lon_v'}.long_name = 'longitude of V-points';
nc{'lon_v'}.units = ncchar('degree_east');
nc{'lon_v'}.units = 'degree_east';
%
nc{'lat_v'}.latg_name = ncchar('latitude of V-points');
nc{'lat_v'}.latg_name = 'latitude of V-points';
nc{'lat_v'}.units = ncchar('degree_north');
nc{'lat_v'}.units = 'degree_north';
%
nc{'Z'}.long_name = ncchar('Depth');
nc{'Z'}.long_name = 'Depth';
nc{'Z'}.units = ncchar('m');
nc{'Z'}.units = 'm';
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
nc.grd_file = ncchar(grdname);
nc.grd_file = grdname;
nc.type = ncchar(type);
nc.type = type;
nc.history = ncchar(history);
nc.history = history;
close(nc)
%
% Write variables
%
ncwrite(oaname,'Z'        ,Z)
ncwrite(oaname,'lon_rho'  ,lonr')
ncwrite(oaname,'lat_rho'  ,latr')
ncwrite(oaname,'lon_u'    ,lonu')
ncwrite(oaname,'lat_u'    ,latu')
ncwrite(oaname,'lon_v'    ,lonv')
ncwrite(oaname,'lat_v'    ,latv')
ncwrite(oaname,'tclm_time',time)
ncwrite(oaname,'sclm_time',time)
ncwrite(oaname,'temp'     ,zeros(Lp,Mp,length(Z),length(time)))
ncwrite(oaname,'salt'     ,zeros(Lp,Mp,length(Z),length(time)))




