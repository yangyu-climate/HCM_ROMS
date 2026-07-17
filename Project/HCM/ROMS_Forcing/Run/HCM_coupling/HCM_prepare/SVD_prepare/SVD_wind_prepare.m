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

fileID = fopen('lsi.dta','rb');
lsi = fread(fileID,'integer*4');
lsi=reshape(lsi(2:end-1),[nx,ny]);
fclose(fileID);
mask=lsi;
% figure;contourf(lon,lat,mask);colorbar;axis equal


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

ist2=ist1;


fileID = fopen('fort.97-month','r','b');
fread(fileID,1,'real*4'); 
arr12 = fread(fileID,m1*20*np*12,'real*4'); arr12 = reshape(arr12 ,m1,20,np,12);
brr12 = fread(fileID,m2*20*np*12,'real*4'); brr12 = reshape(brr12 ,m2,20,np,12);
stdv12= fread(fileID,20*np*12,'real*4');    stdv12= reshape(stdv12,   20,np,12);
sd12  = fread(fileID,12,'real*4');          
ud12  = fread(fileID,np*12,'real*4');       ud12  = reshape(ud12,        np,12);
fread(fileID,1,'real*4');
feof(fileID);
fclose(fileID);


for Mod_num = 1:5
    for month =1:12
        A(:,:,Mod_num,month)=regain_miss_lsi(squeeze(arr12(:,Mod_num,1,month)),nx,ny,ist1);
        U(:,:,Mod_num,month)=regain_miss_lsi(squeeze(brr12(:,Mod_num,1,month)),nx,ny,ist1);
        V(:,:,Mod_num,month)=regain_miss_lsi(squeeze(brr12(:,Mod_num,2,month)),nx,ny,ist1);
        STD12(Mod_num,month)=stdv12(Mod_num,1,month);
    end
end

SD12=sd12;
UD12=ud12(1,:);
VD12=ud12(2,:);
%dyn cm-2 to N m-2
% U=U/10; 
% V=V/10;

save('SVD_wind.mat','lon','lat','mask','A','U','V','SD12','UD12','VD12','STD12')

