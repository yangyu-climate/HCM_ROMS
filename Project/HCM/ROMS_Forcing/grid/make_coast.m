function make_coast(grid_file,coast_file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function make_coast(grid_file,coast_file)
%
%  Get GSHH smaller data files (see m_map toolbox for details)
%  
%  Grid dimensions:
%   lonmin : Minimum longitude [degree east]
%   lonmax : Maximum longitude [degree east]
%   latmin : Minimum latitude [degree north]
%   latmax : Maximum latitude [degree north]
%
%   res : resolution indice (ex: 'i' for intermediate)
%  gshhs_f.b    Full resolution data
%  gshhs_h.b    High resolution data
%  gshhs_i.b    Intermediate resolution data
%  gshhs_l.b    Low resolution data
%  gshhs_c.b    Crude resolution data
%
%  prename:
%   GSHH coastline name prefix (ex biscay for biscay_i.mat)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<1
  grid_file='roms_grd.nc';
end
if nargin<2
  res='i';
  prename='coastline';
else
  lc=length(coast_file);
  res=coast_file(lc-4);
  prename=coast_file(1:lc-6);
end
%
nc=netcdf(grid_file);
lon=nc{'lon_rho'}(:);
lat=nc{'lat_rho'}(:);
close(nc)
lonmin=min(min(lon));
lonmax=max(max(lon));
latmin=min(min(lat));
latmax=max(max(lat));
% dl=.1*max(lonmax-lonmin,latmax-latmin);
dl=0;
lonmin=lonmin-dl;
lonmax=lonmax+dl;
latmin=latmin-dl;
latmax=latmax+dl;

%
% Extract the coastlines
%
m_proj('mercator',...
       'lon',[lonmin lonmax],...
       'lat',[latmin latmax]);
	 
fname=[prename,'_',res,'.mat'];
disp(['Processing ',fname,' ...'])
  
if res=='c'
  m_gshhs_c('save',fname);
end

if res=='l'
  m_gshhs_l('save',fname);
end

if res=='i'
  m_gshhs_i('save',fname);
end

if res=='h'
  m_gshhs_h('save',fname);
end

if res=='f'
  m_gshhs_f('save',fname);
end

m_usercoast(fname,'patch',[.9 .9 .9]);
m_grid('box','fancy','tickdir','in');

%
% Save cstline data in lon,lat form to be used
% in editmask
%
load(fname)
lon=ncst(:,1);
lat=ncst(:,2);
fname2=[prename,'_',res,'_mask.mat'];
eval(['save ',fname2,' lon lat']);

%
% Convert to ASCII file to be used in scrum_mask
%
%load(fname);
%var=ncst;
%var(isnan(var))=999;
%var1=var;
%var1(:,1)=var(:,2);
%var1(:,2)=var(:,1);
%var=var1;
%fname2=[prename,'_',res,'.dat'];
%eval(['save -ASCII ',fname2,' var']);
