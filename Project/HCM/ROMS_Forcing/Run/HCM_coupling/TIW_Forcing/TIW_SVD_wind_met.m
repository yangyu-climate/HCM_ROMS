clear
clc
warning off 

Run_dir = ['../../../'];
addpath(Run_dir)
start
% warning off

Data_dir  = [pwd,'/TIW_SVD'];
file_name = 'SVD_wind.mat';
Save_dir  = [pwd,'/MET'];
mkdir(Save_dir)

grd_file  = [Run_dir,'/Data/Grd.nc'];
h         = ncread(grd_file,'h');
lonr      = ncread(grd_file,'lon_rho');
latr      = ncread(grd_file,'lat_rho');
lonu      = ncread(grd_file,'lon_u');
latu      = ncread(grd_file,'lat_u');
lonv      = ncread(grd_file,'lon_v');
latv      = ncread(grd_file,'lat_v');
mask      = ncread(grd_file,'mask_rho');
L         = size(mask,1);
M         = size(mask,2);


fileN     = [Data_dir,'/',file_name];
lon_svd   = load_data(fileN,'lon');
lat_svd   = load_data(fileN,'lat');
mask_svd  = load_data(fileN,'mask');
A_svd     = load_data(fileN,'A');
U_svd     = load_data(fileN,'U');
V_svd     = load_data(fileN,'V');
SD12      = load_data(fileN,'SD12');
UD12      = load_data(fileN,'UD12');
VD12      = load_data(fileN,'VD12');
STD12     = load_data(fileN,'STD12');

mask(find(mask==0)) = NaN;
mask_svd(find(mask_svd==0)) = NaN;

MASK = griddata(lonr,latr,mask,lon_svd,lat_svd);
MASK = MASK.*mask_svd;
MASK(~isnan(MASK))=1;
count_SVD  = ceil(sum_2D(MASK));
MASK = griddata(lon_svd,lat_svd,mask_svd,lonr,latr);
MASK = MASK.*mask;
MASK(~isnan(MASK))=1;
count_ROMS = ceil(sum_2D(MASK));
Ratio = count_SVD/count_ROMS;

for month =1:12
    disp(['Month: ',num2str(month)])
for ModeN =1:10
    disp(['ModeN: ',num2str(ModeN)])
    MASK    = griddata(lonr,latr,mask,lon_svd,lat_svd);
    MASK_SVD= zeros(size(mask));
    for i=1:size(A_svd,1)
        for j=1:size(A_svd,2)
            if ~isnan(MASK(i,j))
                x    = lon_svd(i,j);
                y    = lat_svd(i,j);
                dist = sqrt((lonr-x).^2+(latr-y).^2);
                loc = find(dist==nanmin(nanmin(dist)));
                MASK_SVD(loc) = 1;
            end
        end
    end

    dSST_M(:,:,ModeN) = griddata(lon_svd,lat_svd,squeeze(A_svd(:,:,ModeN,month)),lonr,latr).*MASK_SVD;
    dSST_W(:,:,ModeN) = dSST_M(:,:,ModeN)/SD12(month)/STD12(ModeN,month)/STD12(ModeN,month);

    % weight
    dTdT_W(:,:,ModeN,month) = dSST_W(:,:,ModeN);

    % pattern
    dUdT_M(:,:,ModeN,month) = griddata(lon_svd,lat_svd,squeeze(U_svd(:,:,ModeN,month)),lonr,latr)*UD12(month);
    dVdT_M(:,:,ModeN,month) = griddata(lon_svd,lat_svd,squeeze(V_svd(:,:,ModeN,month)),lonr,latr)*VD12(month);
end
end

save([Save_dir,'/MET.mat'],'lonr','latr','dTdT_W','dUdT_M','dVdT_M')

