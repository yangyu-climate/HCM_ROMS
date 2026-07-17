clear
clc

Run_dir = ['../../../'];
addpath(Run_dir)
start
warning off


file_old  = [pwd,'/Riv.nc'];
file_new  = [pwd,'/Riv_test.nc'];

river_num = length(ncread(file_old,'river'));

T_beg = [1950 1 1];
T_end = [2021 1 1];
T_ref = datenum(T_beg);
num   = 0;
for Y = T_beg(1):T_end(1)-1
    Dis_Yangtze = load_data([pwd,'/Yangtze/',num2str(Y)]);
    Dis_Hanghe  = load_data([pwd,'/Huanghe/',num2str(Y)]);
    
    for M = 1:12
        num       = num+1;
        T1        = datenum([Y,M  ,1])-T_ref;
        T2        = datenum([Y,M+1,1])-T_ref;
        smst(num) = (T1+T2)/2; 
        disY(num) = Dis_Yangtze(M,3);
        disH(num) = Dis_Hanghe(M,3);
    end
end
smsc = datenum(T_end) - datenum(T_beg);


rivname = file_new;
grdname = 'Grd.nc';
ininame = 'Ini.nc';
title   = 'BYECS_6km';


create_river_forcing(rivname,grdname,ininame,title,smst,smsc,river_num)

ncload(file_old);
for i=1:num/12
    R_V(12*(i-1)+1:12*i,:)   = river_transport;
    R_T(12*(i-1)+1:12*i,:,:) = river_temp;
    R_S(12*(i-1)+1:12*i,:,:) = river_salt;
end
river_transport = R_V;
river_temp      = R_T;
river_salt      = R_S;

river_transport(:,1) = disY;
river_transport(:,2) = disH;

R_TEST = river_transport-R_V;
R_NEW  = river_transport;

ncsave(rivname,river_Xposition,river_Eposition,river_direction,river_Vshape, ...
    river_transport,river_temp,river_salt);

add_river_dye(rivname,'write')


