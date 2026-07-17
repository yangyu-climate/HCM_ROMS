function add_river_dye(inifile,clobber)
disp(' ')
disp([' Adding dye data in file : ',inifile])

%  Create the initial file
nc = netcdf(inifile,clobber);
result = redef(nc);

%  Create variables
nc{'river_dye_01'}     = ncdouble('river_time', 's_rho','river') ;
nc{'river_dye_02'}     = ncdouble('river_time', 's_rho','river') ;

%  Create attributes
nc{'river_dye_01'}.long_name = ncchar('Dye 01');
nc{'river_dye_01'}.long_name = 'Dye 01';
nc{'river_dye_01'}.units = ncchar('1');
nc{'river_dye_01'}.units = '1';

nc{'river_dye_02'}.long_name = ncchar('Dye 02');
nc{'river_dye_02'}.long_name = 'Dye 02';
nc{'river_dye_02'}.units = ncchar('1');
nc{'river_dye_02'}.units = '1';

% Leave define mode
result = endef(nc);

% Write variables
nc{'river_dye_01'}(:)     = 100;
nc{'river_dye_02'}(:)     = 0;
% nc{'river_dye_01'}(:,:,1) = 100;

% Synchronize on disk
close(nc);


