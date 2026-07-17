clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

Data_dir  = [pwd,'/PRE'];

fileI = [Data_dir,'/SSH.nc'];
fileO = [Data_dir,'/SSH_modify.nc'];

if exist(fileO,'file')
    delete(fileO)
end

copyfile(fileI,fileO)

lon = ncread(fileO,'lon');
lat = ncread(fileO,'lat');
SSH = ncread(fileO,'SSH');



% Modify SSH field
%--------------------------------------------------------------------------
for time=1:12
    SSH_new(:,:,time) = squeeze(SSH(:,:,time));
end
%--------------------------------------------------------------------------




% Write out new SSH field
ncwrite(fileO,'SSH',SSH_new)






