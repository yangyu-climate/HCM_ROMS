clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

grid_parameter

lonr=load_data(POM_grid,'lon');
latr=load_data(POM_grid,'lat');
h=load_data(POM_grid,'depth');
lonr=lonr';
latr=latr';
h=h';

lonmin = min(min(lonr));
lonmax = max(max(lonr));
latmin = min(min(latr));
latmax = max(max(latr));

Grid_file = ROMS_grid;

disp(' ')
disp([' Making the grid: ',Grid_file])
disp([' Lon: ',num2str(lonmin),'~',num2str(lonmax),' [degree east]'])
disp([' Lat: ',num2str(latmin),'~',num2str(latmax),' [degree north]'])

Lonr =lonr;
Latr =latr;    
[Lonu,Lonv,Lonp]=rho2uvp(Lonr); 
[Latu,Latv,Latp]=rho2uvp(Latr);

disp(' ')
disp(' Create the grid file...')
[M,L]=size(Latp);
disp([' LLm = ',num2str(L-1)])
disp([' MMm = ',num2str(M-1)])
delete(Grid_file)
create_grid(L,M,Grid_file)

disp(' ')
disp(' Fill the grid file...')
nc=netcdf(Grid_file,'write');
nc{'lat_u'}(:)=Latu;
nc{'lon_u'}(:)=Lonu;
nc{'lat_v'}(:)=Latv;
nc{'lon_v'}(:)=Lonv;
nc{'lat_rho'}(:)=Latr;
nc{'lon_rho'}(:)=Lonr;
nc{'lat_psi'}(:)=Latp;
nc{'lon_psi'}(:)=Lonp;
close(nc)

disp(' ')
disp(' Compute the metrics...')
[pm,pn,dndx,dmde]=get_metrics(Grid_file);
xr=0.*pm;
yr=xr;
for i=1:L
  xr(:,i+1)=xr(:,i)+2./(pm(:,i+1)+pm(:,i));
end
for j=1:M
  yr(j+1,:)=yr(j,:)+2./(pn(j+1,:)+pn(j,:));
end
[xu,xv,xp]=rho2uvp(xr);
[yu,yv,yp]=rho2uvp(yr);
dx=1./pm;
dy=1./pn;
dxmax=max(max(dx/1000));
dxmin=min(min(dx/1000));
dymax=max(max(dy/1000));
dymin=min(min(dy/1000));
disp([' Min dx=',num2str(dxmin),' km - Max dx=',num2str(dxmax),' km'])
disp([' Min dy=',num2str(dymin),' km - Max dy=',num2str(dymax),' km'])

% Angle between XI-axis and the direction
%  to the EAST at RHO-points [radians].
angle=Grd_get_angle(Latu,Lonu);

% Coriolis parameter
f=4*pi*sin(pi*Latr/180)/(24*3600);

% Fill the grid file
nc=netcdf(Grid_file,'write');
nc{'pm'}(:)=pm;
nc{'pn'}(:)=pn;
nc{'dndx'}(:)=dndx;
nc{'dmde'}(:)=dmde;
nc{'x_u'}(:)=xu;
nc{'y_u'}(:)=yu;
nc{'x_v'}(:)=xv;
nc{'y_v'}(:)=yv;
nc{'x_rho'}(:)=xr;
nc{'y_rho'}(:)=yr;
nc{'x_psi'}(:)=xp;
nc{'y_psi'}(:)=yp;
nc{'angle'}(:)=angle;
nc{'f'}(:)=f;
nc{'spherical'}(:)='T';
close(nc);

disp(' ')
disp(' Add topography...')

% Set initial mask
maskr=h>0;
maskr(find(h<=hmin))=0;

% % Smooth the topography
% h=smoothgrid(h,maskr,hmin,hmax,hmax,...
%              rtarget,n_filter_deep_topo,n_filter_final);

 
% Set water type
wtype = ones(size(h));
wtype(find(h<200)) = 4;
         
% Compute the mask
% maskr=process_mask(maskr);
[masku,maskv,maskp]=uvp_mask(maskr);

% Write it down
nc=netcdf(Grid_file,'write');
nc{'h'}(:)=h;
nc{'wtype_grid'}(:) = wtype;
nc{'mask_u'}(:)=masku;
nc{'mask_v'}(:)=maskv;
nc{'mask_psi'}(:)=maskp;
nc{'mask_rho'}(:)=maskr;
close(nc);

% Create the coastline
if ~isempty(coastfileplot)
  make_coast(Grid_file,coastfileplot);
end

r=input('Do you want to use editmask ? y,[n]','s');
if strcmp(r,'y')
  disp(' Editmask:')
  disp(' Edit manually the land mask.')
  disp(' Press enter when finished.')
  disp(' ')
  if ~isempty(coastfileplot)
    editmask(Grid_file,coastfilemask)
  else
    editmask(Grid_file)
  end
  r=input(' Finished with edit mask ? [press enter when finished]','s');
end
close all
         
% Write it down
disp(' ')
disp(' Write it down...')

make_sponge(Grid_file)
