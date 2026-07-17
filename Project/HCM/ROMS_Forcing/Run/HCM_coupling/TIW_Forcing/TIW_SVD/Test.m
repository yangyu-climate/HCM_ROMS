clear
clc

load('SVD_wind.mat')

contourf(lon,lat,squeeze(U(:,:,2,1)))