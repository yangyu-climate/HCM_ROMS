%%%%%%%%%%%%%%%%%%%%% USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%
Riv_parameter

ROMS_title=title;

disp(['Make River Input BIO Condition for:'])
disp(ROMS_title)
add_river_bio(rivname,'write')

RvBio_dir = [pwd,'/River/River_BIO'];
RV_NO3    = xlsread([RvBio_dir ,'/River_NO3.xlsx']);
RV_NH4    = xlsread([RvBio_dir ,'/River_NH4.xlsx']);
RV_SiOH   = xlsread([RvBio_dir ,'/River_SiOH.xlsx']);
RV_PO4    = xlsread([RvBio_dir ,'/River_PO4.xlsx']);
RV_OXY    = xlsread([RvBio_dir ,'/River_OXY.xlsx']);
RV_TIC    = xlsread([RvBio_dir ,'/River_TIC.xlsx']);
RV_ALK    = xlsread([RvBio_dir ,'/River_ALK.xlsx']);

for layerN = 1:layer_N
    C_NO3(:,layerN,:)  = RV_NO3(3:14,:);
    C_NH4(:,layerN,:)  = RV_NH4(3:14,:);
    C_SiOH(:,layerN,:) = RV_SiOH(3:14,:);
    C_PO4(:,layerN,:)  = RV_PO4(3:14,:);
    C_OXY(:,layerN,:)  = RV_OXY(3:14,:);
    C_TIC(:,layerN,:)  = RV_TIC(3:14,:);
    C_ALK(:,layerN,:)  = RV_ALK(3:14,:);
end

nc        = netcdf(rivname,'write');
disp('Writes BIO data into river file ...')
nc{'river_NO3'}(:)  = C_NO3;
nc{'river_NH4'}(:)  = C_NH4;
nc{'river_SiOH'}(:) = C_SiOH;
nc{'river_PO4_'}(:) = C_PO4;
nc{'river_Oxyg'}(:) = C_OXY;
nc{'river_TIC'}(:)  = C_TIC;
nc{'river_Talk'}(:) = C_ALK;
close(nc)     
