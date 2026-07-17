function  create_river_forcing(rivname,grdname,ininame,title,smst,smsc,river_num)
% ȥ�� river_time  smsc,
% % % function  create_forcing(frcname,grdname,title,...
% % %                          shft,swft,srft,sstt,ssst,...
% % %                          shfc,swfc,srfc,sstc,sssc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nc=netcdf(grdname);
L=length(nc('xi_psi'));
M=length(nc('eta_psi'));
result=close(nc);
Lp=L+1;
Mp=M+1;
nc=netcdf(ininame); 
s_rho=length(nc('s_rho'));
result=close(nc);

nw = netcdf(rivname, 'clobber');
result = redef(nw);
   
%
%  Create dimensions
% 

nw('xi_u') = L;
nw('eta_u') = Mp;
nw('xi_v') = Lp;
nw('eta_v') = M;
nw('xi_rho') = Lp; 
nw('eta_rho') = Mp;
nw('xi_psi') = L;
nw('eta_psi') = M;
nw('river') = river_num; % river number
nw('river_time') = length(smst);
nw('s_rho') = s_rho;

%
%  Create variables and attributes
%
nw{'river_time'} = ncdouble('river_time');
nw{'river_time'}.long_name = ncchar('river runoff time');
nw{'river_time'}.long_name = 'river runoff time';
nw{'river_time'}.units = ncchar('days since 1991-01-01 00:00:00');
% nw{'river_time'}.add_offset = '2448623';
nw{'river_time'}.units = 'days';
nw{'river_time'}.cycle_length = smsc;

nw{'river'} = ncdouble('river') ;
nw{'river'}.long_name = ncchar('river runoff identification number') ;

nw{'river_Xposition'} = ncdouble('river') ;
nw{'river_Xposition'}.long_name = ncchar('river XI-position at RHO-points') ;
nw{'river_Xposition'}.valid_min = 1.;
nw{'river_Xposition'}.valid_max = 485.;

nw{'river_Eposition'} = ncdouble('river') ;
nw{'river_Eposition'}.long_name = ncchar('river ETA-position at RHO-points') ;
nw{'river_Eposition'}.valid_min = 1.;
nw{'river_Eposition'}.valid_max = 429.;

nw{'river_direction'} = ncdouble('river') ;
nw{'river_direction'}.long_name = ncchar('river runoff direction') ;

nw{'river_Vshape'} = ncdouble('s_rho', 'river') ;
nw{'river_Vshape'}.long_name = ncchar('river runoff mass transport vertical profile') ;

nw{'river_transport'} = ncdouble('river_time', 'river') ;
nw{'river_transport'}.long_name = ncchar('river runoff vertically integrated mass transport') ;
nw{'river_transport'}.units = ncchar('meter3 second-1') ;
nw{'river_transport'}.time = smst ;

nw{'river_temp'} = ncdouble('river_time', 's_rho', 'river') ;
nw{'river_temp'}.long_name = ncchar('river runoff potential temperature') ;
nw{'river_temp'}.units = ncchar('Celsius') ;
nw{'river_temp'}.time = smst ;

nw{'river_salt'} = ncdouble('river_time', 's_rho','river') ;
nw{'river_salt'}.long_name = ncchar('river runoff salinity') ;
nw{'river_salt'}.units = ncchar('PSU') ;
nw{'river_salt'}.time = smst ;


result = endef(nw);

%
% Create global attributes
%

nw.title = ncchar(title);
nw.title = title;
nw.date = ncchar(date);
nw.date = date;
nw.grd_file = ncchar(grdname);
nw.grd_file = grdname;
nw.type = ncchar('ROMS forcing file');
nw.type = 'ROMS forcing file';

%
% Write time variables
%
nw{'river_time'}(:) = smst;
nw{'river'}(:) =1;

close(nw);
