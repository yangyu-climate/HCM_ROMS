function add_river_bio(inifile,clobber)
disp([' Adding dye data in file : ',inifile])

%  Create the initial file
nc = netcdf(inifile,clobber);
result = redef(nc);

%  Create variables
nc{'river_NO3'}  = ncdouble('river_time', 's_rho','river') ;
nc{'river_NH4'}  = ncdouble('river_time', 's_rho','river') ;
nc{'river_SiOH'} = ncdouble('river_time', 's_rho','river') ;
nc{'river_PO4_'} = ncdouble('river_time', 's_rho','river') ;
nc{'river_Oxyg'} = ncdouble('river_time', 's_rho','river') ;
nc{'river_TIC'}  = ncdouble('river_time', 's_rho','river') ;
nc{'river_Talk'} = ncdouble('river_time', 's_rho','river') ;

%  Create attributes
nc{'river_NO3'}.long_name = ncchar('river runoff NO3') ;
nc{'river_NO3'}.units = ncchar('millimole_nitrogen meter-3') ;

nc{'river_NH4'}.long_name = ncchar('river runoff NH4') ;
nc{'river_NH4'}.units = ncchar('millimole_nitrogen meter-3') ;

nc{'river_SiOH'}.long_name = ncchar('river runoff SiOH') ;
nc{'river_SiOH'}.units = ncchar('millimole_Si meter-3') ;

nc{'river_PO4_'}.long_name = ncchar('river runoff PO4') ;
nc{'river_PO4_'}.units = ncchar('millimole_P meter-3') ;

nc{'river_TIC'}.long_name = ncchar('river runoff TIC') ;
nc{'river_TIC'}.units = ncchar('millimole_carbon meter-3') ;

nc{'river_Talk'}.long_name = ncchar('river runoff alkalinity') ;
nc{'river_Talk'}.units = ncchar('milliequivalents meter-3') ;

nc{'river_Oxyg'}.long_name = ncchar('river runoff oxygen') ;
nc{'river_Oxyg'}.units = ncchar('millimole_oxygen meter-3') ;

% Leave define mode
result = endef(nc);

% Synchronize on disk
close(nc);


