clear
clc

fileO = 'Grd.nc';
fileN = 'GrdN.nc';

delete(fileN)
copyfile(fileO,fileN)

lon=ncread(fileO,'lon_rho')+360;
ncwrite(fileN,'lon_rho',lon);

lon=ncread(fileO,'lon_psi')+360;
ncwrite(fileN,'lon_psi',lon);
