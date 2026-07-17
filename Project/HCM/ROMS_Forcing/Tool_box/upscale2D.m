function [x,y,var]=upscale2D(x,y,var,dx_roms)

R=6367442.76;
deg2rad=pi/180;
dg=mean(x(2:end)-x(1:end-1));
dphi=y(2:end)-y(1:end-1);
dy=R*deg2rad*dphi;
dx=R*deg2rad*dg*cos(deg2rad*y);
dx_data=mean([dx ;dy]);
disp([' Input data resolution : ',num2str(dx_data/1000,3),' km'])

%
% Degrade data resolution
%
n=0;
while dx_roms>2*dx_data
  n=n+1;
%  
  x=0.5*(x(2:end)+x(1:end-1));
  x=x(1:2:end);
  y=0.5*(y(2:end)+y(1:end-1));
  y=y(1:2:end);

  V(1,:,:) = var(2:end,1:end-1);
  V(2,:,:) = var(2:end,2:end);
  V(3,:,:) = var(1:end-1,1:end-1);
  V(4,:,:) = var(1:end-1,2:end);
  var = squeeze(nanmean(V));
  clear V
  
  var = var(1:2:end,1:2:end);   
%  
  dg=mean(x(2:end)-x(1:end-1));
  dphi=y(2:end)-y(1:end-1);
  dy=R*deg2rad*dphi;
  dx=R*deg2rad*dg*cos(deg2rad*y);
  dx_data=mean([dx ;dy]);
end
disp([' Data resolution halved ',num2str(n),' times'])
disp([' New data resolution : ',num2str(dx_data/1000,3),' km'])



