nx=134;
ny=61;

m1=4425;
m2=4425;
np=2;

xt0=zeros(1,nx);
for i=1:nx
    xt0(i)=124+(i-1)*2;
end

yt0=[-31. -28. -25. -22. -19. -16. -13.75 -12.25 -11.25 -10.5 ...
-10. -9.5 -9. -8.5 -8. -7.5 -7. -6.5 -6. -5.5 -5. -4.5 ...
-4. -3.5 -3. -2.5 -2. -1.5  -1. -0.5  0. 0.5 1. 1.5 ...
2. 2.5 3. 3.5 4. 4.5 5. 5.5 6. 6.5 7. ...
7.5 8. 8.5 9. 9.5 10. 10.5 11.25 12.25 ...
13.75 16. 19. 22. 25. 28. 31.];

lon=xt0;
lat=yt0;
[lon,lat]=meshgrid(lon,lat);
lon = lon';
lat = lat';

fid = fopen('ist1to.dat','r','b');
ist1to = fread(fid,'int32'); ist1to = ist1to(2:end-1);
fclose(fid);
clear fid

lsi = zeros(nx,ny);
for i = 1:length(ist1to)
lsi(ist1to(i)) = 1;
end
mask=lsi;

ist1=zeros(m1,1);
ij0=0;
for i=1:nx
    for j=1:ny
        if lsi(i,j) == 1
            ij0=ij0+1;
            ist1(ij0)=i+(j-1)*nx;
        end
    end
end

fid = fopen('fort.243','r','b');
data = fread(fid,'float32');
fclose(fid);
data = data(2:end-1);
clear fid
sdt = data(4425*20*2+4425+1:4425*20*2+4425+40);
sdt = reshape(sdt,[20 2]);%standard deviation of first 20 modes time series
stdt1=squeeze(sdt(:,1));
stdt2=squeeze(sdt(:,2));
stdv12=sqrt(stdt1.*stdt2);

fid = fopen('fort.87','r','b');
data = fread(fid,'float32');
fclose(fid);
data = data(2:end-1);

arr0 = data(8851:97350);arr0 = reshape(arr0,[4425 20]);
brr0 = data(97351:185850);brr0 = reshape(brr0,[4425 20]);
clear fid data


for Mod_num = 1:5
    for month =1:12
        A(:,:,Mod_num,month)=regain_miss_lsi(squeeze(arr0(:,Mod_num)),nx,ny,ist1);
        W(:,:,Mod_num,month)=regain_miss_lsi(squeeze(brr0(:,Mod_num)),nx,ny,ist1);
        STD12(Mod_num,month)=stdv12(Mod_num);
    end
end

for month =1:12
    SD12(month)=0.5551;
    WD12(month)=2.1399;
end
% mm day-1 to cm day-1
 W=-W/10; 

save('SVD_fwf.mat','lon','lat','mask','A','W','SD12','WD12','STD12')

