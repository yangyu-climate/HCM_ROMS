%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Add the paths of the different toolboxes
%
%  Copyright (c) 
%  e-mail: clarkyuchina@live.com
%
%  Updated    11-Apr-2015 by Clark
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Add the paths of the different toolboxes'])
mypath   = [Run_dir,'/Tool_box/'];
addpath([mypath])
OS_Linux = 1;
%
% Other software directories
%
if OS_Linux
    start_linux
else
    start_windows
end
