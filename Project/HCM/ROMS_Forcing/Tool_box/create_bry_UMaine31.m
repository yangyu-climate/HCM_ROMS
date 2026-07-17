function create_bry_UMaine31(bryname,grdname,title,obc,...
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
nc('S1_N_time')           = length(time);
nc('S1_C_time')           = length(time);
nc('S1CH_time')           = length(time);
nc('S2_N_time')           = length(time);
nc('S2_C_time')           = length(time);
nc('S2CH_time')           = length(time);
nc('S3_N_time')           = length(time);
nc('S3_C_time')           = length(time);
nc('S3CH_time')           = length(time);
nc('Z1_N_time')           = length(time);
nc('Z1_C_time')           = length(time);
nc('Z2_N_time')           = length(time);
nc('Z2_C_time')           = length(time);
nc('DD_N_time')           = length(time);
nc('DD_C_time')           = length(time);
nc('DDCA_time')           = length(time);
nc('DDSi_time')           = length(time);
nc('BAC_time')            = length(time);
nc('LDON_time')           = length(time);
nc('LDOC_time')           = length(time);
nc('SDON_time')           = length(time);
nc('SDOC_time')           = length(time);
nc('CLDC_time')           = length(time);
nc('CSDC_time')           = length(time);
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
nc{'S1_N_time'} = ncdouble('S1_N_time') ;
nc{'S1_N_time'}.units = 'day';
nc{'S1_N_time'}.cycle_length = cycle;%
%
nc{'S1_C_time'} = ncdouble('S1_C_time') ;
nc{'S1_C_time'}.units = 'day';
nc{'S1_C_time'}.cycle_length = cycle;%
%
nc{'S1CH_time'} = ncdouble('S1CH_time') ;
nc{'S1CH_time'}.units = 'day';
nc{'S1CH_time'}.cycle_length = cycle;%
%
nc{'S2_N_time'} = ncdouble('S2_N_time') ;
nc{'S2_N_time'}.units = 'day';
nc{'S2_N_time'}.cycle_length = cycle;%
%
nc{'S2_C_time'} = ncdouble('S2_C_time') ;
nc{'S2_C_time'}.units = 'day';
nc{'S2_C_time'}.cycle_length = cycle;%
%
nc{'S2CH_time'} = ncdouble('S2CH_time') ;
nc{'S2CH_time'}.units = 'day';
nc{'S2CH_time'}.cycle_length = cycle;%
%
nc{'S3_N_time'} = ncdouble('S3_N_time') ;
nc{'S3_N_time'}.units = 'day';
nc{'S3_N_time'}.cycle_length = cycle;%
%
nc{'S3_C_time'} = ncdouble('S3_C_time') ;
nc{'S3_C_time'}.units = 'day';
nc{'S3_C_time'}.cycle_length = cycle;%
%
nc{'S3CH_time'} = ncdouble('S3CH_time') ;
nc{'S3CH_time'}.units = 'day';
nc{'S3CH_time'}.cycle_length = cycle;%
%
nc{'Z1_N_time'} = ncdouble('Z1_N_time') ;
nc{'Z1_N_time'}.units = 'day';
nc{'Z1_N_time'}.cycle_length = cycle;%
%
nc{'Z1_C_time'} = ncdouble('Z1_C_time') ;
nc{'Z1_C_time'}.units = 'day';
nc{'Z1_C_time'}.cycle_length = cycle;%
%
nc{'Z2_N_time'} = ncdouble('Z2_N_time') ;
nc{'Z2_N_time'}.units = 'day';
nc{'Z2_N_time'}.cycle_length = cycle;%
%
nc{'Z2_C_time'} = ncdouble('Z2_C_time') ;
nc{'Z2_C_time'}.units = 'day';
nc{'Z2_C_time'}.cycle_length = cycle;%
%
nc{'DD_N_time'} = ncdouble('DD_N_time') ;
nc{'DD_N_time'}.units = 'day';
nc{'DD_N_time'}.cycle_length = cycle;%
%
nc{'DD_C_time'} = ncdouble('DD_C_time') ;
nc{'DD_C_time'}.units = 'day';
nc{'DD_C_time'}.cycle_length = cycle;%
%
nc{'DDCA_time'} = ncdouble('DDCA_time') ;
nc{'DDCA_time'}.units = 'day';
nc{'DDCA_time'}.cycle_length = cycle;%
%
nc{'DDSi_time'} = ncdouble('DDSi_time') ;
nc{'DDSi_time'}.units = 'day';
nc{'DDSi_time'}.cycle_length = cycle;%
%
nc{'BAC_time'} = ncdouble('BAC_time') ;
nc{'BAC_time'}.units = 'day';
nc{'BAC_time'}.cycle_length = cycle;%
%
nc{'LDON_time'} = ncdouble('LDON_time') ;
nc{'LDON_time'}.units = 'day';
nc{'LDON_time'}.cycle_length = cycle;%
%
nc{'LDOC_time'} = ncdouble('LDOC_time') ;
nc{'LDOC_time'}.units = 'day';
nc{'LDOC_time'}.cycle_length = cycle;%
%
nc{'SDON_time'} = ncdouble('SDON_time') ;
nc{'SDON_time'}.units = 'day';
nc{'SDON_time'}.cycle_length = cycle;%
%
nc{'SDOC_time'} = ncdouble('SDOC_time') ;
nc{'SDOC_time'}.units = 'day';
nc{'SDOC_time'}.cycle_length = cycle;%
%
nc{'CLDC_time'} = ncdouble('CLDC_time') ;
nc{'CLDC_time'}.units = 'day';
nc{'CLDC_time'}.cycle_length = cycle;%
%
nc{'CSDC_time'} = ncdouble('CSDC_time') ;
nc{'CSDC_time'}.units = 'day';
nc{'CSDC_time'}.cycle_length = cycle;%
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
  nc{'S1_N_south'}          = ncdouble('S1_N_time','s_rho','xi_rho') ;
  nc{'S1_C_south'}          = ncdouble('S1_C_time','s_rho','xi_rho') ;
  nc{'S1CH_south'}          = ncdouble('S1CH_time','s_rho','xi_rho') ;
  nc{'S2_N_south'}          = ncdouble('S2_N_time','s_rho','xi_rho') ;
  nc{'S2_C_south'}          = ncdouble('S2_C_time','s_rho','xi_rho') ;
  nc{'S2CH_south'}          = ncdouble('S2CH_time','s_rho','xi_rho') ;
  nc{'S3_N_south'}          = ncdouble('S3_N_time','s_rho','xi_rho') ;
  nc{'S3_C_south'}          = ncdouble('S3_C_time','s_rho','xi_rho') ;
  nc{'S3CH_south'}          = ncdouble('S3CH_time','s_rho','xi_rho') ;
  nc{'Z1_N_south'}          = ncdouble('Z1_N_time','s_rho','xi_rho') ;
  nc{'Z1_C_south'}          = ncdouble('Z1_C_time','s_rho','xi_rho') ;
  nc{'Z2_N_south'}          = ncdouble('Z2_N_time','s_rho','xi_rho') ;
  nc{'Z2_C_south'}          = ncdouble('Z2_C_time','s_rho','xi_rho') ;
  nc{'BAC_south'}           = ncdouble('BAC_time','s_rho','xi_rho') ;
  nc{'DD_N_south'}          = ncdouble('DD_N_time','s_rho','xi_rho') ;
  nc{'DD_C_south'}          = ncdouble('DD_C_time','s_rho','xi_rho') ;
  nc{'DDCA_south'}          = ncdouble('DDCA_time','s_rho','xi_rho') ;
  nc{'DDSi_south'}          = ncdouble('DDSi_time','s_rho','xi_rho') ;
  nc{'LDON_south'}          = ncdouble('LDON_time','s_rho','xi_rho') ;
  nc{'LDOC_south'}          = ncdouble('LDOC_time','s_rho','xi_rho') ;
  nc{'SDON_south'}          = ncdouble('SDON_time','s_rho','xi_rho') ;
  nc{'SDOC_south'}          = ncdouble('SDOC_time','s_rho','xi_rho') ;
  nc{'CLDC_south'}          = ncdouble('CLDC_time','s_rho','xi_rho') ;
  nc{'CSDC_south'}          = ncdouble('CSDC_time','s_rho','xi_rho') ;
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
  nc{'S1_N_east'}          = ncdouble('S1_N_time','s_rho','eta_rho') ;
  nc{'S1_C_east'}          = ncdouble('S1_C_time','s_rho','eta_rho') ;
  nc{'S1CH_east'}          = ncdouble('S1CH_time','s_rho','eta_rho') ;
  nc{'S2_N_east'}          = ncdouble('S2_N_time','s_rho','eta_rho') ;
  nc{'S2_C_east'}          = ncdouble('S2_C_time','s_rho','eta_rho') ;
  nc{'S2CH_east'}          = ncdouble('S2CH_time','s_rho','eta_rho') ;
  nc{'S3_N_east'}          = ncdouble('S3_N_time','s_rho','eta_rho') ;
  nc{'S3_C_east'}          = ncdouble('S3_C_time','s_rho','eta_rho') ;
  nc{'S3CH_east'}          = ncdouble('S3CH_time','s_rho','eta_rho') ;
  nc{'Z1_N_east'}          = ncdouble('Z1_N_time','s_rho','eta_rho') ;
  nc{'Z1_C_east'}          = ncdouble('Z1_C_time','s_rho','eta_rho') ;
  nc{'Z2_N_east'}          = ncdouble('Z2_N_time','s_rho','eta_rho') ;
  nc{'Z2_C_east'}          = ncdouble('Z2_C_time','s_rho','eta_rho') ;
  nc{'BAC_east'}           = ncdouble('BAC_time','s_rho','eta_rho') ;
  nc{'DD_N_east'}          = ncdouble('DD_N_time','s_rho','eta_rho') ;
  nc{'DD_C_east'}          = ncdouble('DD_C_time','s_rho','eta_rho') ;
  nc{'DDCA_east'}          = ncdouble('DDCA_time','s_rho','eta_rho') ;
  nc{'DDSi_east'}          = ncdouble('DDSi_time','s_rho','eta_rho') ;
  nc{'LDON_east'}          = ncdouble('LDON_time','s_rho','eta_rho') ;
  nc{'LDOC_east'}          = ncdouble('LDOC_time','s_rho','eta_rho') ;
  nc{'SDON_east'}          = ncdouble('SDON_time','s_rho','eta_rho') ;
  nc{'SDOC_east'}          = ncdouble('SDOC_time','s_rho','eta_rho') ;
  nc{'CLDC_east'}          = ncdouble('CLDC_time','s_rho','eta_rho') ;
  nc{'CSDC_east'}          = ncdouble('CSDC_time','s_rho','eta_rho') ;
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
  nc{'S1_N_north'}          = ncdouble('S1_N_time','s_rho','xi_rho') ;
  nc{'S1_C_north'}          = ncdouble('S1_C_time','s_rho','xi_rho') ;
  nc{'S1CH_north'}          = ncdouble('S1CH_time','s_rho','xi_rho') ;
  nc{'S2_N_north'}          = ncdouble('S2_N_time','s_rho','xi_rho') ;
  nc{'S2_C_north'}          = ncdouble('S2_C_time','s_rho','xi_rho') ;
  nc{'S2CH_north'}          = ncdouble('S2CH_time','s_rho','xi_rho') ;
  nc{'S3_N_north'}          = ncdouble('S3_N_time','s_rho','xi_rho') ;
  nc{'S3_C_north'}          = ncdouble('S3_C_time','s_rho','xi_rho') ;
  nc{'S3CH_north'}          = ncdouble('S3CH_time','s_rho','xi_rho') ;
  nc{'Z1_N_north'}          = ncdouble('Z1_N_time','s_rho','xi_rho') ;
  nc{'Z1_C_north'}          = ncdouble('Z1_C_time','s_rho','xi_rho') ;
  nc{'Z2_N_north'}          = ncdouble('Z2_N_time','s_rho','xi_rho') ;
  nc{'Z2_C_north'}          = ncdouble('Z2_C_time','s_rho','xi_rho') ;
  nc{'BAC_north'}           = ncdouble('BAC_time','s_rho','xi_rho') ;
  nc{'DD_N_north'}          = ncdouble('DD_N_time','s_rho','xi_rho') ;
  nc{'DD_C_north'}          = ncdouble('DD_C_time','s_rho','xi_rho') ;
  nc{'DDCA_north'}          = ncdouble('DDCA_time','s_rho','xi_rho') ;
  nc{'DDSi_north'}          = ncdouble('DDSi_time','s_rho','xi_rho') ;
  nc{'LDON_north'}          = ncdouble('LDON_time','s_rho','xi_rho') ;
  nc{'LDOC_north'}          = ncdouble('LDOC_time','s_rho','xi_rho') ;
  nc{'SDON_north'}          = ncdouble('SDON_time','s_rho','xi_rho') ;
  nc{'SDOC_north'}          = ncdouble('SDOC_time','s_rho','xi_rho') ;
  nc{'CLDC_north'}          = ncdouble('CLDC_time','s_rho','xi_rho') ;
  nc{'CSDC_north'}          = ncdouble('CSDC_time','s_rho','xi_rho') ;
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
  nc{'S1_N_west'}          = ncdouble('S1_N_time','s_rho','eta_rho') ;
  nc{'S1_C_west'}          = ncdouble('S1_C_time','s_rho','eta_rho') ;
  nc{'S1CH_west'}          = ncdouble('S1CH_time','s_rho','eta_rho') ;
  nc{'S2_N_west'}          = ncdouble('S2_N_time','s_rho','eta_rho') ;
  nc{'S2_C_west'}          = ncdouble('S2_C_time','s_rho','eta_rho') ;
  nc{'S2CH_west'}          = ncdouble('S2CH_time','s_rho','eta_rho') ;
  nc{'S3_N_west'}          = ncdouble('S3_N_time','s_rho','eta_rho') ;
  nc{'S3_C_west'}          = ncdouble('S3_C_time','s_rho','eta_rho') ;
  nc{'S3CH_west'}          = ncdouble('S3CH_time','s_rho','eta_rho') ;
  nc{'Z1_N_west'}          = ncdouble('Z1_N_time','s_rho','eta_rho') ;
  nc{'Z1_C_west'}          = ncdouble('Z1_C_time','s_rho','eta_rho') ;
  nc{'Z2_N_west'}          = ncdouble('Z2_N_time','s_rho','eta_rho') ;
  nc{'Z2_C_west'}          = ncdouble('Z2_C_time','s_rho','eta_rho') ;
  nc{'BAC_west'}           = ncdouble('BAC_time','s_rho','eta_rho') ;
  nc{'DD_N_west'}          = ncdouble('DD_N_time','s_rho','eta_rho') ;
  nc{'DD_C_west'}          = ncdouble('DD_C_time','s_rho','eta_rho') ;
  nc{'DDCA_west'}          = ncdouble('DDCA_time','s_rho','eta_rho') ;
  nc{'DDSi_west'}          = ncdouble('DDSi_time','s_rho','eta_rho') ;
  nc{'LDON_west'}          = ncdouble('LDON_time','s_rho','eta_rho') ;
  nc{'LDOC_west'}          = ncdouble('LDOC_time','s_rho','eta_rho') ;
  nc{'SDON_west'}          = ncdouble('SDON_time','s_rho','eta_rho') ;
  nc{'SDOC_west'}          = ncdouble('SDOC_time','s_rho','eta_rho') ;
  nc{'CLDC_west'}          = ncdouble('CLDC_time','s_rho','eta_rho') ;
  nc{'CSDC_west'}          = ncdouble('CSDC_time','s_rho','eta_rho') ;
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
nc{'S1_N_time'}(:)           = time;
nc{'S1_C_time'}(:)           = time;
nc{'S1CH_time'}(:)           = time;
nc{'S2_N_time'}(:)           = time;
nc{'S2_C_time'}(:)           = time;
nc{'S2CH_time'}(:)           = time;
nc{'S3_N_time'}(:)           = time;
nc{'S3_C_time'}(:)           = time;
nc{'S3CH_time'}(:)           = time;
nc{'Z1_N_time'}(:)           = time;
nc{'Z1_C_time'}(:)           = time;
nc{'Z2_N_time'}(:)           = time;
nc{'Z2_C_time'}(:)           = time;
nc{'DD_N_time'}(:)           = time;
nc{'DD_C_time'}(:)           = time;
nc{'DDCA_time'}(:)           = time;
nc{'DDSi_time'}(:)           = time;
nc{'BAC_time'}(:)            = time;
nc{'LDON_time'}(:)           = time;
nc{'LDOC_time'}(:)           = time;
nc{'SDON_time'}(:)           = time;
nc{'SDOC_time'}(:)           = time;
nc{'CLDC_time'}(:)           = time;
nc{'CSDC_time'}(:)           = time;
nc{'TIC_time'}(:)            = time;
nc{'alkalinity_time'}(:)     = time;
nc{'oxygen_time'}(:)         = time;


if obc(1)==1
  nc{'NO3_south'}(:)           =  15;
  nc{'NH4_south'}(:)           =  0.2;
  nc{'PO4_south'}(:)           =  10;
  nc{'SiOH_south'}(:)          =  20; 
  nc{'S1_N_south'}(:)          =  0.01;
  nc{'S1_C_south'}(:)          =  0.01;
  nc{'S1CH_south'}(:)          =  0.01;
  nc{'S2_N_south'}(:)          =  0.01;
  nc{'S2_C_south'}(:)          =  0.01;
  nc{'S2CH_south'}(:)          =  0.01;
  nc{'S3_N_south'}(:)          =  0.01;
  nc{'S3_C_south'}(:)          =  0.01;
  nc{'S3CH_south'}(:)          =  0.01;
  nc{'Z1_N_south'}(:)          =  0.01;
  nc{'Z1_C_south'}(:)          =  0.01;
  nc{'Z2_N_south'}(:)          =  0.01;
  nc{'Z2_C_south'}(:)          =  0.01;
  nc{'BAC_south'}(:)           =  0.01;
  nc{'DD_N_south'}(:)          =  0.01;
  nc{'DD_C_south'}(:)          =  0.01;
  nc{'DDCA_south'}(:)          =  0.01;
  nc{'DDSi_south'}(:)          =  0.01;
  nc{'LDON_south'}(:)          =  0.01;
  nc{'LDOC_south'}(:)          =  0.01;
  nc{'SDON_south'}(:)          =  0.01;
  nc{'SDOC_south'}(:)          =  0.01;
  nc{'CLDC_south'}(:)          =  0.01;
  nc{'CSDC_south'}(:)          =  0.01;
  nc{'TIC_south'}(:)           =  2111;
  nc{'Talk_south'}(:)          =  2353;
  nc{'Oxyg_south'}(:)          =  233.15;
end 
if obc(2)==1
  nc{'NO3_east'}(:)           =  15;
  nc{'NH4_east'}(:)           =  0.2;
  nc{'PO4_east'}(:)           =  10;
  nc{'SiOH_east'}(:)          =  20;
  nc{'S1_N_east'}(:)          =  0.01;
  nc{'S1_C_east'}(:)          =  0.01;
  nc{'S1CH_east'}(:)          =  0.01;
  nc{'S2_N_east'}(:)          =  0.01;
  nc{'S2_C_east'}(:)          =  0.01;
  nc{'S2CH_east'}(:)          =  0.01;
  nc{'S3_N_east'}(:)          =  0.01;
  nc{'S3_C_east'}(:)          =  0.01;
  nc{'S3CH_east'}(:)          =  0.01;
  nc{'Z1_N_east'}(:)          =  0.01;
  nc{'Z1_C_east'}(:)          =  0.01;
  nc{'Z2_N_east'}(:)          =  0.01;
  nc{'Z2_C_east'}(:)          =  0.01;
  nc{'BAC_east'}(:)           =  0.01;
  nc{'DD_N_east'}(:)          =  0.01;
  nc{'DD_C_east'}(:)          =  0.01;
  nc{'DDCA_east'}(:)          =  0.01;
  nc{'DDSi_east'}(:)          =  0.01;
  nc{'LDON_east'}(:)          =  0.01;
  nc{'LDOC_east'}(:)          =  0.01;
  nc{'SDON_east'}(:)          =  0.01;
  nc{'SDOC_east'}(:)          =  0.01;
  nc{'CLDC_east'}(:)          =  0.01;
  nc{'CSDC_east'}(:)          =  0.01;
  nc{'TIC_east'}(:)           =  2111;
  nc{'Talk_east'}(:)          =  2353;
  nc{'Oxyg_east'}(:)          =  233.15;
end 
if obc(3)==1
  nc{'NO3_north'}(:)           =  15;
  nc{'NH4_north'}(:)           =  0.2;
  nc{'PO4_north'}(:)           =  10;
  nc{'SiOH_north'}(:)          =  20;
  nc{'S1_N_north'}(:)          =  0.01;
  nc{'S1_C_north'}(:)          =  0.01;
  nc{'S1CH_north'}(:)          =  0.01;
  nc{'S2_N_north'}(:)          =  0.01;
  nc{'S2_C_north'}(:)          =  0.01;
  nc{'S2CH_north'}(:)          =  0.01;
  nc{'S3_N_north'}(:)          =  0.01;
  nc{'S3_C_north'}(:)          =  0.01;
  nc{'S3CH_north'}(:)          =  0.01;
  nc{'Z1_N_north'}(:)          =  0.01;
  nc{'Z1_C_north'}(:)          =  0.01;
  nc{'Z2_N_north'}(:)          =  0.01;
  nc{'Z2_C_north'}(:)          =  0.01;
  nc{'BAC_north'}(:)           =  0.01;
  nc{'DD_N_north'}(:)          =  0.01;
  nc{'DD_C_north'}(:)          =  0.01;
  nc{'DDCA_north'}(:)          =  0.01;
  nc{'DDSi_north'}(:)          =  0.01;
  nc{'LDON_north'}(:)          =  0.01;
  nc{'LDOC_north'}(:)          =  0.01;
  nc{'SDON_north'}(:)          =  0.01;
  nc{'SDOC_north'}(:)          =  0.01;
  nc{'CLDC_north'}(:)          =  0.01;
  nc{'CSDC_north'}(:)          =  0.01;
  nc{'TIC_north'}(:)           =  2111;
  nc{'Talk_north'}(:)          =  2353;
  nc{'Oxyg_north'}(:)          =  233.15;
end 
if obc(4)==1
  nc{'NO3_west'}(:)           =  15;
  nc{'NH4_west'}(:)           =  0.2;
  nc{'PO4_west'}(:)           =  10;
  nc{'SiOH_west'}(:)          =  20;
  nc{'S1_N_west'}(:)          =  0.01;
  nc{'S1_C_west'}(:)          =  0.01;
  nc{'S1CH_west'}(:)          =  0.01;
  nc{'S2_N_west'}(:)          =  0.01;
  nc{'S2_C_west'}(:)          =  0.01;
  nc{'S2CH_west'}(:)          =  0.01;
  nc{'S3_N_west'}(:)          =  0.01;
  nc{'S3_C_west'}(:)          =  0.01;
  nc{'S3CH_west'}(:)          =  0.01;
  nc{'Z1_N_west'}(:)          =  0.01;
  nc{'Z1_C_west'}(:)          =  0.01;
  nc{'Z2_N_west'}(:)          =  0.01;
  nc{'Z2_C_west'}(:)          =  0.01;
  nc{'BAC_west'}(:)           =  0.01;
  nc{'DD_N_west'}(:)          =  0.01;
  nc{'DD_C_west'}(:)          =  0.01;
  nc{'DDCA_west'}(:)          =  0.01;
  nc{'DDSi_west'}(:)          =  0.01;
  nc{'LDON_west'}(:)          =  0.01;
  nc{'LDOC_west'}(:)          =  0.01;
  nc{'SDON_west'}(:)          =  0.01;
  nc{'SDOC_west'}(:)          =  0.01;
  nc{'CLDC_west'}(:)          =  0.01;
  nc{'CSDC_west'}(:)          =  0.01;
  nc{'TIC_west'}(:)           =  2111;
  nc{'Talk_west'}(:)          =  2353;
  nc{'Oxyg_west'}(:)          =  233.15;
end 
close(nc)
return


