function [x,y,var] = ncload_3D_select(fileN,var_nam,lon_nam,lat_nam,dep_nam,lon_lim,lat_lim)

lonmin  = min(lon_lim);
lonmax  = max(lon_lim);
latmin  = min(lat_lim);
latmax  = max(lat_lim);

nc = netcdf(fileN);       
X  = nc{lon_nam}(:);
Y  = nc{lat_nam}(:);
Z  = nc{dep_nam}(:);

locZero = find(Y==0);
locMin  = min(find(Y==min(Y)));
locRem  = locZero(locZero<=locMin);
Y(locRem)=NaN;

j  = find(Y>=latmin & Y<=latmax);
i1 = find(X-360>=lonmin & X-360<=lonmax);
i2 = find(X>=lonmin & X<=lonmax);
i3 = find(X+360>=lonmin & X+360<=lonmax);
x  = cat(1,X(i1)-360,X(i2),X(i3)+360);
y  = Y(j);            
close(nc);

if ~isempty(i2)
    staN = [min(i2) min(j) 1         1];    
    endN = [max(i2) max(j) length(Z) 1];    
    couN = endN - staN + 1;    
    strN = ones(size(couN));  
    VARS = ncread(fileN,var_nam,staN,couN,strN);    
    VAR  = VARS;    
else   
    VAR  = [];    
end
if ~isempty(i1)
    staN = [min(i1) min(j) 1         1];    
    endN = [max(i1) max(j) length(Z) 1];     
    couN = endN - staN + 1;    
    strN = ones(size(couN));
    VARS = ncread(fileN,var_nam,staN,couN,strN);
    VAR  = cat(1,VARS,VAR); 
end
if ~isempty(i3)
    staN = [min(i3) min(j) 1         1];
    endN = [max(i3) max(j) length(Z) 1]; 
    couN = endN - staN + 1;
    strN = ones(size(couN));
    VARS = ncread(fileN,var_nam,staN,couN,strN);
    VAR  = cat(1,VAR,VARS); 
end

for i = 1:size(VAR,3)
    var(i,:,:) = squeeze(VAR(:,:,i)');
end