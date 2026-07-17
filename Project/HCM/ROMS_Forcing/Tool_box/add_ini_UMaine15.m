function add_ini_UMaine15(inifile,clobber)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Adding Bio UMaine Data in: ',inifile])
%
%Create the initial file
nc = netcdf(inifile,clobber);
result = redef(nc);
%
%Create variables

%UMaine 15
nc{'NO3'}              = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'NH4'}              = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'SiOH'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'PO4'}              = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'nanophytoplankton'}= ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'diatom'}           = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'microzooplankton'} = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'mesozooplankton'}  = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'detritus'}         = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'opal'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'chlorophyll1'}     = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'chlorophyll2'}     = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'oxyg'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'Talk'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'TIC'}              = ncdouble('time','s_rho','eta_rho','xi_rho') ;

%
% Leave define mode
%
result = endef(nc);
%
% Write variables

%UMaine 15
nc{'NO3'}(:)               = 15;
nc{'NH4'}(:)               = 0.2;
nc{'SiOH'}(:)              = 20;
nc{'PO4'}(:)               = 10;
nc{'nanophytoplankton'}(:) = 0.01;
nc{'diatom'}(:)            = 0.01;
nc{'microzooplankton'}(:)  = 0.01;
nc{'mesozooplankton'}(:)   = 0.01;
nc{'detritus'}(:)          = 0.01;
nc{'opal'}(:)              = 0.01; 
nc{'chlorophyll1'}(:)      = 0.01;
nc{'chlorophyll2'}(:)      = 0.01;
nc{'oxyg'}(:)              = 233.15;
nc{'Talk'}(:)              = 2353;
nc{'TIC'}(:)               = 2111;

%
% Synchronize on disk
%
close(nc);
return


