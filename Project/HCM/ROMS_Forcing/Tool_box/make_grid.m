clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

grid_parameter

if IF_GLB
    lonmin = -180.0 + dl/2; % change minimum longitude for global model
    lonmax =  180.0 - dl/2; % change maximum longitude for global model
end

disp(' ')
disp([' Making the grid: ',Grid_file])
disp([' Lon: ',num2str(lonmin),'~',num2str(lonmax),' [degree east]'])
disp([' Lat: ',num2str(latmin),'~',num2str(latmax),' [degree north]'])
disp([' Resolution: 1/',num2str(1/dl),' deg'])

lonr=(lonmin:dl:lonmax);
latr=(latmin:dl:latmax);

if IF_ISO 
    i=1;
    latr(i)=latmin;
    while latr(i)<=latmax
    i=i+1;
    latr(i)=latr(i-1)+dl*cos(latr(i-1)*pi/180);
    end
end

[Lonr,Latr]=meshgrid(lonr,latr);    
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
e=4*pi*cos(pi*Latr/180)/(24*3600);

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
nc{'e'}(:)=e;
nc{'spherical'}(:)='T';
close(nc);

disp(' ')
disp(' Add topography...')
if IF_GLB
    X = [(-360+dl/2):dl:(360-dl/2)];
    Y = latr;
else
    X = lonr;
    Y = latr;
end
[LON,LAT] = meshgrid(X,Y);

h=add_topo(LON,LAT,pm,pn,Topo_file,Topo_lon,Topo_lat,Topo_var);
if IF_GLB
H=griddata(LON,LAT,h,Lonr,Latr);
end

% Set initial mask
maskr=h>0;

% Smooth the topography
h=smoothgrid(h,maskr,hmin,hmax,hmax,...
             rtarget,n_filter_deep_topo,n_filter_final);
if IF_GLB
h=griddata(LON,LAT,h,Lonr,Latr);
end
 
% Set water type
wtype = ones(size(h));
wtype(find(h<200)) = 4;
         
% Compute the mask
if IF_GLB
maskr=H>0; 
end
maskr=process_mask(maskr);
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

if max_dom >1
    make_nesting
end

