function add_ini_UMaine31Fe(inifile,clobber)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Adding Bio UMaine Data in: ',inifile])
%
%Create the initial file
nc = netcdf(inifile,clobber);
result = redef(nc);
%
%Create variables

%UMaine 31
nc{'NO3'}              = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'NH4'}              = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'SiOH'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'PO4'}              = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S1_N'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S1_C'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S1CH'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S2_N'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S2_C'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S2CH'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S3_N'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S3_C'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S3CH'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'Z1_N'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'Z1_C'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'Z2_N'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'Z2_C'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'BAC_'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'DD_N'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'DD_C'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'DDCA'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'DDSi'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'LDON'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'LDOC'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'SDON'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'SDOC'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'CLDC'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'CSDC'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'oxyg'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'Talk'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'TIC'}              = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S1Fe'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S2Fe'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'S3Fe'}             = ncdouble('time','s_rho','eta_rho','xi_rho') ;
nc{'FeD'}              = ncdouble('time','s_rho','eta_rho','xi_rho') ;

%
% Leave define mode
%
result = endef(nc);
%
% Write variables

%UMaine 31
nc{'NO3'}(:)               = 15;
nc{'NH4'}(:)               = 0.2;
nc{'SiOH'}(:)              = 20;
nc{'PO4'}(:)               = 10;
nc{'S1_N'}(:)              = 0.01;
nc{'S1_C'}(:)              = 0.01;
nc{'S1CH'}(:)              = 0.01;
nc{'S2_N'}(:)              = 0.01;
nc{'S2_C'}(:)              = 0.01;
nc{'S2CH'}(:)              = 0.01;
nc{'S3_N'}(:)              = 0.01;
nc{'S3_C'}(:)              = 0.01;
nc{'S3CH'}(:)              = 0.01;
nc{'Z1_N'}(:)              = 0.01;
nc{'Z1_C'}(:)              = 0.01;
nc{'Z2_N'}(:)              = 0.01;
nc{'Z2_C'}(:)              = 0.01;
nc{'BAC_'}(:)              = 0.01;
nc{'DD_N'}(:)              = 0.01;
nc{'DD_C'}(:)              = 0.01;
nc{'DDCA'}(:)              = 0.01;
nc{'DDSi'}(:)              = 0.01;
nc{'LDON'}(:)              = 0.01;
nc{'LDOC'}(:)              = 0.01;
nc{'SDON'}(:)              = 0.01;
nc{'SDOC'}(:)              = 0.01;
nc{'CLDC'}(:)              = 0.01;
nc{'CSDC'}(:)              = 0.01;
nc{'oxyg'}(:)              = 233.15;
nc{'Talk'}(:)              = 2353;
nc{'TIC'}(:)               = 2111;
nc{'S1Fe'}(:)              = 0.01;
nc{'S2Fe'}(:)              = 0.01;
nc{'S3Fe'}(:)              = 0.01;
nc{'FeD'}(:)               = 0.05;

%
% Synchronize on disk
%
close(nc);
return


