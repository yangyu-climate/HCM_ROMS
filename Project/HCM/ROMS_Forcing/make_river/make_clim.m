%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Build a ROMS climatology file
%
%  Extrapole and interpole temperature and salinity from a
%  Climatology to get boundary and initial conditions for
%  ROMS (climatology and initial netcdf files) .
%  Get the velocities and sea surface elevation via a 
%  geostrophic computation.
%
%  Data input format (netcdf):
%     temperature(T, Z, Y, X)
%     T : time [Months]
%     Z : Depth [m]
%     Y : Latitude [degree north]
%     X : Longitude [degree east]
%
%  Data source : IRI/LDEO Climate Data Library (World Ocean Atlas 1998)
%    http://ingrid.ldgo.columbia.edu/
%    http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NODC/.WOA98/
% 
%  Further Information:  
%  http://www.brest.ird.fr/Roms_tools/
%
%%%%%%%%%%%%%%%%%%%%% USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%
%
% Common parameters
%
Riv_parameter
%
%  Data climatologies file names:
%
%    temp_month_data : monthly temperature climatology
%    temp_ann_data   : annual temperature climatology
%    salt_month_data : monthly salinity climatology
%    salt_ann_data   : annual salinity climatology
%
temp_month_data=[woa_dir,'temp_month.cdf'];
temp_ann_data=[woa_dir,'temp_ann.cdf'];
salt_month_data=[woa_dir,'salt_month.cdf'];
salt_ann_data=[woa_dir,'salt_ann.cdf'];
%
%
%%%%%%%%%%%%%%%%%%% END USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%

disp([' Making the clim: ',clmname])
ROMS_title = title;
N = layer_N;

%
% Read in the grid
%
disp(' Read in the grid...')
nc=netcdf(grdname);
Lp=length(nc('xi_rho'));
Mp=length(nc('eta_rho'));
hmax=max(max(nc{'h'}(:)));
result=close(nc);

%----------------------------------------------------------------------------
% Create the climatology file
%----------------------------------------------------------------------------
makeclim = 1;
makeoa   = 1;
oaname   = 'OA.nc';

Roa=0;

if (makeclim)
  disp(' Create the climatology file...')
  vtransform  = 2;
  if  ~exist('vtransform')
      vtransform=1; %Old Vtransform
      disp([' NO VTRANSFORM parameter found'])
      stop
  end
  delete(clmname)
  create_climfile(clmname,grdname,ROMS_title,...
                  theta_s,theta_b,hc,N,...
                  woa_time,woa_cycle,'write',vtransform);
end


if (makeoa)
  %
  % Create the OA file
  %
  disp(' Create the OA file...')
  nc=netcdf(temp_ann_data);
  Z=nc{'Z'}(:);
  kmax=max(find(Z<hmax))-1;
  Z=Z(1:kmax);
  close(nc)
  delete(oaname)
  create_oafile(oaname,grdname,ROMS_title,Z,...
                woa_time,woa_cycle,'write');

  %
  % Horizontal extrapolations 
  %
  disp(' Horizontal extrapolations')
  disp(' Temperature...')
  ext_tracers(oaname,temp_month_data,temp_ann_data,...
              'temperature','temp','tclm_time','Z',Roa);
  disp(' Salinity...')
  ext_tracers(oaname,salt_month_data,salt_ann_data,...
              'salinity','salt','sclm_time','Z',Roa);
end


if (makeclim)

  %
  % Vertical interpolations 
  %
  disp(' ')
  disp(' Vertical interpolations')
  disp(' ')
  disp(' Temperature...')
  vinterp_clm(clmname,grdname,oaname,'temp','tclm_time','Z',0,'r');
  disp(' ')
  disp(' Salinity...')
  vinterp_clm(clmname,grdname,oaname,'salt','sclm_time','Z',0,'r');

end

delete(oaname)



