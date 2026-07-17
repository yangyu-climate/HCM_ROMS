function create_bry_UMaine15(bryname,grdname,title,obc,...
                        theta_s,theta_b,hc,N,...
                        time,cycle,clobber,vtransform)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
disp([' Creating the file : ',bryname])
disp(' ')
if nargin < 11
    disp([' NO VTRANSFORM parameter found'])
    disp([' USE TRANSFORM default value vtransform = 1'])
    vtransform = 1; 
end
disp([' VTRANSFORM = ',num2str(vtransform)])

%cycle = 365.25;                    % of QSCAT experiments with 
%
%  Read the grid file and check the topography
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
%
%  Create the boundary file
%
type = 'BOUNDARY file' ; 
history = 'ROMS' ;
nc = netcdf(bryname,clobber);
result = redef(nc);
%
%  Create dimensions
%

nc('xi_rho') = Lp;
nc('eta_rho') = Mp;
nc('s_rho') = N;
nc('NO3_time')            = length(time);
nc('NH4_time')            = length(time);
nc('PO4_time')            = length(time);
nc('SiOH_time')           = length(time);
nc('bio_time')            = length(time);
nc('detritus_time')       = length(time);
nc('TIC_time')            = length(time);
nc('alkalinity_time')     = length(time);
nc('oxygen_time')         = length(time);
nc('one') = 1;
%
%  Create variables and attributes
%
nc{'NO3_time'} = ncdouble('NO3_time') ;
nc{'NO3_time'}.units = 'day';
nc{'NO3_time'}.cycle_length = cycle;%
%
nc{'NH4_time'} = ncdouble('NH4_time') ;
nc{'NH4_time'}.units = 'day';
nc{'NH4_time'}.cycle_length = cycle;%
%
nc{'PO4_time'} = ncdouble('PO4_time') ;
nc{'PO4_time'}.units = 'day';
nc{'PO4_time'}.cycle_length = cycle;%
%
nc{'SiOH_time'} = ncdouble('SiOH_time') ;
nc{'SiOH_time'}.units = 'day';
nc{'SiOH_time'}.cycle_length = cycle;%
%
nc{'bio_time'} = ncdouble('bio_time') ;
nc{'bio_time'}.units = 'day';
nc{'bio_time'}.cycle_length = cycle;%
%
nc{'detritus_time'} = ncdouble('detritus_time') ;
nc{'detritus_time'}.units = 'day';
nc{'detritus_time'}.cycle_length = cycle;%
%
nc{'TIC_time'} = ncdouble('TIC_time') ;
nc{'TIC_time'}.units = 'day';
nc{'TIC_time'}.cycle_length = cycle;%
%
nc{'alkalinity_time'} = ncdouble('alkalinity_time') ;
nc{'alkalinity_time'}.units = 'day';
nc{'alkalinity_time'}.cycle_length = cycle;%
%
nc{'oxygen_time'} = ncdouble('oxygen_time') ;
nc{'oxygen_time'}.units = 'day';
nc{'oxygen_time'}.cycle_length = cycle;%

%
if obc(1)==1
%
%   Southern boundary
%
  nc{'NO3_south'}           = ncdouble('NO3_time','s_rho','xi_rho') ;
  nc{'NH4_south'}           = ncdouble('NH4_time','s_rho','xi_rho') ;
  nc{'PO4_south'}           = ncdouble('PO4_time','s_rho','xi_rho') ;
  nc{'SiOH_south'}          = ncdouble('SiOH_time','s_rho','xi_rho') ;
  nc{'nanophy_south'}       = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'diatom_south'}        = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'microzoo_south'}      = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'mesozoo_south'}       = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'detritus_south'}      = ncdouble('detritus_time','s_rho','xi_rho') ;
  nc{'opal_south'}          = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'chlorophyll1_south'}  = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'chlorophyll2_south'}  = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'TIC_south'}           = ncdouble('TIC_time','s_rho','xi_rho') ;  
  nc{'Talk_south'}          = ncdouble('alkalinity_time','s_rho','xi_rho') ;
  nc{'Oxyg_south'}          = ncdouble('oxygen_time','s_rho','xi_rho') ;
 %
end
%
if obc(2)==1
%
%   Eastern boundary
%
  nc{'NO3_east'}           = ncdouble('NO3_time','s_rho','eta_rho') ;
  nc{'NH4_east'}           = ncdouble('NH4_time','s_rho','eta_rho') ;
  nc{'PO4_east'}           = ncdouble('PO4_time','s_rho','eta_rho') ;
  nc{'SiOH_east'}          = ncdouble('SiOH_time','s_rho','eta_rho') ;
  nc{'nanophy_east'}       = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'diatom_east'}        = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'microzoo_east'}      = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'mesozoo_east'}       = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'detritus_east'}      = ncdouble('detritus_time','s_rho','eta_rho') ;
  nc{'opal_east'}          = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'chlorophyll1_east'}  = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'chlorophyll2_east'}  = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'TIC_east'}           = ncdouble('TIC_time','s_rho','eta_rho') ;  
  nc{'Talk_east'}          = ncdouble('alkalinity_time','s_rho','eta_rho') ;
  nc{'Oxyg_east'}          = ncdouble('oxygen_time','s_rho','eta_rho') ;
end
%
if obc(3)==1
%
%   Northern boundary
%
  nc{'NO3_north'}           = ncdouble('NO3_time','s_rho','xi_rho') ;
  nc{'NH4_north'}           = ncdouble('NH4_time','s_rho','xi_rho') ;
  nc{'PO4_north'}           = ncdouble('PO4_time','s_rho','xi_rho') ;
  nc{'SiOH_north'}          = ncdouble('SiOH_time','s_rho','xi_rho') ;
  nc{'nanophy_north'}       = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'diatom_north'}        = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'microzoo_north'}      = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'mesozoo_north'}       = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'detritus_north'}      = ncdouble('detritus_time','s_rho','xi_rho') ;
  nc{'opal_north'}          = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'chlorophyll1_north'}  = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'chlorophyll2_north'}  = ncdouble('bio_time','s_rho','xi_rho') ;
  nc{'TIC_north'}           = ncdouble('TIC_time','s_rho','xi_rho') ;  
  nc{'Talk_north'}          = ncdouble('alkalinity_time','s_rho','xi_rho') ;
  nc{'Oxyg_north'}          = ncdouble('oxygen_time','s_rho','xi_rho') ;
%
end
%
if obc(4)==1
%
%   Western boundary
%
  nc{'NO3_west'}           = ncdouble('NO3_time','s_rho','eta_rho') ;
  nc{'NH4_west'}           = ncdouble('NH4_time','s_rho','eta_rho') ;
  nc{'PO4_west'}           = ncdouble('PO4_time','s_rho','eta_rho') ;
  nc{'SiOH_west'}          = ncdouble('SiOH_time','s_rho','eta_rho') ;
  nc{'nanophy_west'}       = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'diatom_west'}        = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'microzoo_west'}      = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'mesozoo_west'}       = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'detritus_west'}      = ncdouble('detritus_time','s_rho','eta_rho') ;
  nc{'opal_west'}          = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'chlorophyll1_west'}  = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'chlorophyll2_west'}  = ncdouble('bio_time','s_rho','eta_rho') ;
  nc{'TIC_west'}           = ncdouble('TIC_time','s_rho','eta_rho') ;  
  nc{'Talk_west'}          = ncdouble('alkalinity_time','s_rho','eta_rho') ;
  nc{'Oxyg_west'}          = ncdouble('oxygen_time','s_rho','eta_rho') ;
%
end
%
%
% Create global attributes
%
nc.title = ncchar(title);
nc.title = title;
nc.date = ncchar(date);
nc.date = date;
nc.clim_file = ncchar(bryname);
nc.clim_file = bryname;
nc.grd_file = ncchar(grdname);
nc.grd_file = grdname;
nc.type = ncchar(type);
nc.type = type;
nc.history = ncchar(history);
nc.history = history;
%
% Leave define mode
%
result = endef(nc);
%
% Write variables
%
nc{'NO3_time'}(:)            = time;
nc{'NH4_time'}(:)            = time;
nc{'PO4_time'}(:)            = time;
nc{'SiOH_time'}(:)           = time;
nc{'bio_time'}(:)            = time;
nc{'detritus_time'}(:)       = time;
nc{'TIC_time'}(:)            = time;
nc{'alkalinity_time'}(:)     = time;
nc{'oxygen_time'}(:)         = time;


if obc(1)==1
  nc{'NO3_south'}(:)           =  15;
  nc{'NH4_south'}(:)           =  0.2;
  nc{'PO4_south'}(:)           =  10;
  nc{'SiOH_south'}(:)          =  20;
  nc{'nanophy_south'}(:)       =  0.01;
  nc{'diatom_south'}(:)        =  0.01;
  nc{'microzoo_south'}(:)      =  0.01;
  nc{'mesozoo_south'}(:)       =  0.01;
  nc{'detritus_south'}(:)      =  0.01;
  nc{'opal_south'}(:)          =  0.01;
  nc{'chlorophyll1_south'}(:)  =  0.01;
  nc{'chlorophyll2_south'}(:)  =  0.01;
  nc{'TIC_south'}(:)           =  2111;
  nc{'Talk_south'}(:)          =  2353;
  nc{'Oxyg_south'}(:)          =  233.15;
end 
if obc(2)==1
  nc{'NO3_east'}(:)           =  15;
  nc{'NH4_east'}(:)           =  0.2;
  nc{'PO4_east'}(:)           =  10;
  nc{'SiOH_east'}(:)          =  20;
  nc{'nanophy_east'}(:)       =  0.01;
  nc{'diatom_east'}(:)        =  0.01;
  nc{'microzoo_east'}(:)      =  0.01;
  nc{'mesozoo_east'}(:)       =  0.01;
  nc{'detritus_east'}(:)      =  0.01;
  nc{'opal_east'}(:)          =  0.01;
  nc{'chlorophyll1_east'}(:)  =  0.01;
  nc{'chlorophyll2_east'}(:)  =  0.01;
  nc{'TIC_east'}(:)           =  2111;
  nc{'Talk_east'}(:)          =  2353;
  nc{'Oxyg_east'}(:)          =  233.15;
end 
if obc(3)==1
  nc{'NO3_north'}(:)           =  15;
  nc{'NH4_north'}(:)           =  0.2;
  nc{'PO4_north'}(:)           =  10;
  nc{'SiOH_north'}(:)          =  20;
  nc{'nanophy_north'}(:)       =  0.01;
  nc{'diatom_north'}(:)        =  0.01;
  nc{'microzoo_north'}(:)      =  0.01;
  nc{'mesozoo_north'}(:)       =  0.01;
  nc{'detritus_north'}(:)      =  0.01;
  nc{'opal_north'}(:)          =  0.01;
  nc{'chlorophyll1_north'}(:)  =  0.01;
  nc{'chlorophyll2_north'}(:)  =  0.01;
  nc{'TIC_north'}(:)           =  2111;
  nc{'Talk_north'}(:)          =  2353;
  nc{'Oxyg_north'}(:)          =  233.15;
end 
if obc(4)==1
  nc{'NO3_west'}(:)           =  15;
  nc{'NH4_west'}(:)           =  0.2;
  nc{'PO4_west'}(:)           =  10;
  nc{'SiOH_west'}(:)          =  20;
  nc{'nanophy_west'}(:)       =  0.01;
  nc{'diatom_west'}(:)        =  0.01;
  nc{'microzoo_west'}(:)      =  0.01;
  nc{'mesozoo_west'}(:)       =  0.01;
  nc{'detritus_west'}(:)      =  0.01;
  nc{'opal_west'}(:)          =  0.01;
  nc{'chlorophyll1_west'}(:)  =  0.01;
  nc{'chlorophyll2_west'}(:)  =  0.01;
  nc{'TIC_west'}(:)           =  2111;
  nc{'Talk_west'}(:)          =  2353;
  nc{'Oxyg_west'}(:)          =  233.15;
end 
close(nc)
return


