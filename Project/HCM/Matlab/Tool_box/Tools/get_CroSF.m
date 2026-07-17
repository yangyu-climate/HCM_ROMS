function Flux = get_CroSF(lon,lat,uflux,vflux,Posit_1,Posit_2)

P1_lon   = Posit_1(1);
P1_lat   = Posit_1(2);
P2_lon   = Posit_2(1);
P2_lat   = Posit_2(2);

mask     = sqrt( uflux.^2 + vflux.^2 );
mask(~isnan(mask)) = 1;

dist_P1  = sqrt( (lon-P1_lon).^2 + (lat-P1_lat).^2 );
dist_P2  = sqrt( (lon-P2_lon).^2 + (lat-P2_lat).^2 );
index    = find(dist_P1==nanmin(nanmin(dist_P1)));
[y1,x1]  = ind2sub(size(mask),index);
index    = find(dist_P2==nanmin(nanmin(dist_P2)));
[y2,x2]  = ind2sub(size(mask),index);

XX= [lon(y1,x1) lon(y2,x2)];
YY= [lat(y1,x1) lat(y2,x2)];
%X = diff(XX);
%Y = diff(YY);
X = distbear(XX,[mean(YY) mean(YY)],'wgs84','ellipsoid')*sign(diff(XX));
Y = distbear([mean(XX) mean(XX)],YY,'wgs84','ellipsoid')*sign(diff(YY));
L = sqrt(X^2+Y^2);
COSF =  Y/L;
SINF = -X/L;
F = (uflux*COSF + vflux*SINF);

dy= y2-y1;
dx= x2-x1;
num = 0;
if abs(dx)>abs(dy)
  dydx = dy/dx;
  for x = x1:sign(x2-x1):x2
    num = num+1;
    y = y1+ floor((x-x1)*dydx);
    flux(num) = F(y,x);
  end
else
  dxdy = dx/dy;
  for y = y1:sign(y2-y1):y2
    num = num+1;
    x = x1+ floor((y-y1)*dxdy);
    flux(num) = F(y,x);
  end
end

Flux = nansum(flux);
