function  create_Frc(frcname,grdname,title,sstt,ssst,sstc,sssc,IF_mkSST)

nc=netcdf(grdname);
L=length(nc('xi_psi'));
M=length(nc('eta_psi'));
result=close(nc);
Lp=L+1;
Mp=M+1;

nw = netcdf(frcname, 'clobber');
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
nw('sst_time') = length(sstt);
nw('sss_time') = length(ssst);

nw{'sst_time'} = ncdouble('sst_time');
nw{'sst_time'}.long_name = ncchar('sea surface temperature time');
nw{'sst_time'}.long_name = 'sea surface temperature time';
nw{'sst_time'}.units = ncchar('days');
nw{'sst_time'}.units = 'days';
nw{'sst_time'}.cycle_length = sstc;

nw{'sss_time'} = ncdouble('sss_time');
nw{'sss_time'}.long_name = ncchar('sea surface salinity time');
nw{'sss_time'}.long_name = 'sea surface salinity time';
nw{'sss_time'}.units = ncchar('days');
nw{'sss_time'}.units = 'days';
nw{'sss_time'}.cycle_length = sssc;

nw{'SSS'} = ncdouble('sss_time', 'eta_rho', 'xi_rho');
nw{'SSS'}.long_name = ncchar('sea surface salinity');
nw{'SSS'}.long_name = 'sea surface salinity';
nw{'SSS'}.units = ncchar('PSU');
nw{'SSS'}.units = 'PSU';

nw{'dQdSST'} = ncdouble('sst_time', 'eta_rho', 'xi_rho');
nw{'dQdSST'}.long_name = ncchar('surface net heat flux sensitivity to SST');
nw{'dQdSST'}.long_name = 'surface net heat flux sensitivity to SST';
nw{'dQdSST'}.units = ncchar('Watts meter-2 Celsius-1');
nw{'dQdSST'}.units = 'Watts meter-2 Celsius-1';

if IF_mkSST
nw{'SST'} = ncdouble('sst_time', 'eta_rho', 'xi_rho');
nw{'SST'}.long_name = ncchar('sea surface temperature');
nw{'SST'}.long_name = 'sea surface temperature';
nw{'SST'}.units = ncchar('Celsius');
nw{'SST'}.units = 'Celsius';
end

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
nw{'sst_time'}(:) = sstt;
nw{'sss_time'}(:) = ssst;

close(nw);
