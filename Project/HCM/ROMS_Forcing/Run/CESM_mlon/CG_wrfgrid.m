clear
clc

fileO = 'wrfinput_d01';
fileN = 'wrfinput_d01N';

delete(fileN)
copyfile(fileO,fileN)

lon=ncread(fileO,'XLONG')+360;
ncwrite(fileN,'XLONG',lon);
