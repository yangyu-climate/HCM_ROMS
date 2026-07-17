function add_river_dye(inifile,clobber)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2000 IRD                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                 %
%                                                                 %
%  function nc=add_ini_pisces(inifile,clobber)                    %
%                                                                 %
%   This function create the header of a Netcdf climatology       %
%   file.                                                         %
%                                                                 %
%   Input:                                                        %
%                                                                 %
%   inifile      Netcdf initial file name (character string).     %
%   clobber      Switch to allow or not writing over an existing  %
%                file.(character string)                          %
%                                                                 %
%   Output                                                        %
%                                                                 %
%   nc       Output netcdf object.                                %
%                                                                 %
%   Pierrick Penven, IRD, 2005.                                   %
%   Olivier Aumont, IRD, 2006.                                    %
%   Patricio Marchesiello, IRD 2007                               %
%   Christophe Eugene Raoul Menkes, IRD 2007                      %
%                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
disp([' Adding dye data in file : ',inifile])
%
%  Create the initial file
%
nc = netcdf(inifile,clobber);
result = redef(nc);
%
%  Create variables
%
nc{'river_dye_01'}     = ncdouble('river_time', 's_rho','river') ;
nc{'river_dye_02'}     = ncdouble('river_time', 's_rho','river') ;

%
%  Create attributes
%
nc{'river_dye_01'}.long_name = ncchar('Dye 01');
nc{'river_dye_01'}.long_name = 'Dye 01';
nc{'river_dye_01'}.units = ncchar('1');
nc{'river_dye_01'}.units = '1';
%
%
nc{'river_dye_02'}.long_name = ncchar('Dye 02');
nc{'river_dye_02'}.long_name = 'Dye 02';
nc{'river_dye_02'}.units = ncchar('1');
nc{'river_dye_02'}.units = '1';
%
% Leave define mode
%
result = endef(nc);
%
% Write variables
%
nc{'river_dye_01'}(:)     = 0;
nc{'river_dye_02'}(:)     = 0;
nc{'river_dye_01'}(:,:,1) = 100;

%
% Synchronize on disk
%
close(nc);
return


