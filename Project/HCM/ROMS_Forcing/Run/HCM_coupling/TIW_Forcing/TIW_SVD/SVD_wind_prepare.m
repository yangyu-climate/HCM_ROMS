fid = fopen('tau_svd_tiw.96','r','b');
icm_svd  = fread(fid,'int32');
fclose(fid);
icm_svd = icm_svd(2:end-1);

m1   = 4383;
ist1 = icm_svd(1:m1);
ist2 = icm_svd(m1+1:m1*2);

fid     = fopen('tau_svd_tiw.96','r','b');
icm_svd = fread(fid,'float32');
fclose(fid);
icm_svd = icm_svd(2:end-1);

arr  = icm_svd(m1*2+1:m1*2+m1*20*2);
arr  = reshape(arr,m1,20,2);
brr  = icm_svd(m1*2+m1*20*2+1:m1*2+m1*20*2+m1*20*2);
brr  = reshape(brr,m1,20,2);
stdv = icm_svd(m1*2+m1*20*2+m1*20*2+1:m1*2+m1*20*2+m1*20*2+20*2);
stdv = reshape(stdv,20,2);
sd   = icm_svd(m1*2+m1*20*2+m1*20*2+20*2+1);
ud   = icm_svd(m1*2+m1*20*2+m1*20*2+20*2+2:end);

lon_icm=124:2:332;
lat_icm=[-31 -28 -25 -22 -19. -16. -13.75 -12.25 -11.25 -10.5 ...
    -10. -9.5 -9. -8.5 -8. -7.5 -7. -6.5 -6. -5.5 -5. -4.5 ...
    -4. -3.5 -3. -2.5 -2. -1.5  -1. -0.5  0. 0.5 1. 1.5 ...
    2. 2.5 3. 3.5 4. 4.5 5. 5.5 6. 6.5 7. ...
    7.5 8. 8.5 9. 9.5 10. 10.5 11.25 12.25 ...
    13.75 16. 19. 22 25 28 31];
mask = zeros(length(lon_icm), length(lat_icm));
mask(ist1) = 1;

lon=lon_icm;
lat=lat_icm;
[lon,lat]=meshgrid(lon,lat);
lon = lon';
lat = lat';

% figure;
% pcolor(lon_icm, lat_icm, mask');
% pcolor(lon, lat, mask);
% % shading flat;

L = nan(105*61,20,2);
R = nan(105*61,20,2);
for i = 1:20
    for j = 1:2
        L(ist1,i,j) = arr(:,i,j);
        R(ist2,i,j) = brr(:,i,j);
    end
end
L = reshape(L,105,61,20,2);
R = reshape(R,105,61,20,2);

for Mod_num = 1:20
  for month =1:12
    A(:,:,Mod_num,month) = squeeze(L(:,:,Mod_num,1));
    U(:,:,Mod_num,month) = squeeze(R(:,:,Mod_num,1));
    V(:,:,Mod_num,month) = squeeze(R(:,:,Mod_num,2));
    STD12(Mod_num,month) = stdv(Mod_num,1);
  end
end

for month =1:12
    SD12(month)=sd;
    UD12(month)=ud(1);
    VD12(month)=ud(2);
end

%dyn cm-2 to N m-2
% U=U/10; 
% V=V/10;

save('SVD_wind.mat','lon','lat','mask','A','U','V','SD12','UD12','VD12','STD12')
