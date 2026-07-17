function h=add_topo(lon,lat,pm,pn,toponame,topolon,topolat,topovar)
%
% Get ROMS averaged resolution
%
dx=mean(mean(1./pm));
dy=mean(mean(1./pn));
dx_roms=mean([dx dy]);
disp([' ROMS resolution : ',num2str(dx_roms/1000,3),' km'])

dl=max([1 2*(dx_roms/(60*1852))]);
lonmin=min(min(lon))-dl;
lonmax=max(max(lon))+dl;
latmin=min(min(lat))-dl;
latmax=max(max(lat))+dl;
%
%  open the topo file
%
nc=netcdf(toponame);
tlon=nc{topolon}(:);
tlat=nc{topolat}(:);

%
%  get a subgrid
%
j=find(tlat>=latmin & tlat<=latmax);
i1=find(tlon-360>=lonmin & tlon-360<=lonmax);
i2=find(tlon>=lonmin & tlon<=lonmax);
i3=find(tlon+360>=lonmin & tlon+360<=lonmax);
x=cat(1,tlon(i1)-360,tlon(i2),tlon(i3)+360);
y=tlat(j);
%
%  Read data
%
if ~isempty(i2)
  topo=-nc{topovar}(j,i2);
else
  topo=[];
end
if ~isempty(i1)
  topo=cat(2,-nc{topovar}(j,i1),topo);
end
if ~isempty(i3)
  topo=cat(2,topo,-nc{topovar}(j,i3));
end
result=close(nc);
%
% Get TOPO averaged resolution
%
R=6367442.76;
deg2rad=pi/180;
dg=mean(x(2:end)-x(1:end-1));
dphi=y(2:end)-y(1:end-1);
dy=R*deg2rad*dphi;
dx=R*deg2rad*dg*cos(deg2rad*y);
dx_topo=mean([dx ;dy]);
disp([' Topography data resolution : ',num2str(dx_topo/1000,3),' km'])

% h = degrade_topo(x,y,topo,lon,lat);

%
% Degrade TOPO resolution
%
n=0;
while dx_roms>5*(dx_topo)
  n=n+1;
%  
  x=0.5*(x(2:end)+x(1:end-1));
  x=x(1:2:end);
  y=0.5*(y(2:end)+y(1:end-1));
  y=y(1:2:end);
%
  topo=0.25*(topo(2:end,1:end-1)  +topo(2:end,2:end)+...
             topo(1:end-1,1:end-1)+topo(1:end-1,2:end));
  topo=topo(1:2:end,1:2:end);   
%  
  dg=mean(x(2:end)-x(1:end-1));
  dphi=y(2:end)-y(1:end-1);
  dy=R*deg2rad*dphi;
  dx=R*deg2rad*dg*cos(deg2rad*y);
  dx_topo=mean([dx ;dy]);
end
disp([' Topography resolution halved ',num2str(n),' times'])
disp([' New topography resolution : ',num2str(dx_topo/1000,3),' km'])

%  interpolate the topo
%
% h=interp2(x,y,topo,lon,lat,'cubic');
h=interp2(x,y,topo,lon,lat,'linear');

% dx = mean(mean(lon(:,2:end)-lon(:,1:end-1)));
% dy = mean(mean(lat(2:end,:)-lat(1:end-1,:)));
% dl = mean([dx dy])/2;
% [x,y] = meshgrid(x,y);
% 
% for i = 1:size(lon,1)
%     for j = 1:size(lon,2)
%         disp(['X & Y Points: ',num2str(i),'&',num2str(j)])
%         LON    = lon(i,j);
%         LAT    = lat(i,j);
%         loc    = find(x>=(LON-dl)&x<=(LON+dl)&y>=(LAT-dl)&y<=(LAT+dl));
%         h(i,j) = nanmean(topo(loc));
%     end
% end

return
