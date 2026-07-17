function [x,y,var] = ncload_2D_select(fileN,var_nam,lon_nam,lat_nam,lon_lim,lat_lim)

lonmin  = min(lon_lim);
lonmax  = max(lon_lim);
latmin  = min(lat_lim);
latmax  = max(lat_lim);

nc      = netcdf(fileN);        
tlon    = nc{lon_nam}(:);
tlat    = nc{lat_nam}(:);

locZero = find(tlat==0);
locMin  = min(find(tlat==min(tlat)));
locRem  = locZero(locZero<=locMin);
tlat(locRem)=NaN;

j=find(tlat>=latmin & tlat<=latmax);
i1=find(tlon-360>=lonmin & tlon-360<=lonmax);
i2=find(tlon>=lonmin & tlon<=lonmax);
i3=find(tlon+360>=lonmin & tlon+360<=lonmax);
x=cat(1,tlon(i1)-360,tlon(i2),tlon(i3)+360);
y=tlat(j);

if ~isempty(i2)    
    staN = [min(i2) min(j) 1];   
    endN = [max(i2) max(j) 1];    
    couN = endN - staN + 1;    
    strN = ones(size(couN));   
    VARS = ncread(fileN,var_nam,staN,couN,strN);  
    VAR  = VARS;  
else
    VAR  = []; 
end

if ~isempty(i1)
    staN = [min(i1) min(j) 1];  
    endN = [max(i1) max(j) 1];    
    couN = endN - staN + 1;
    strN = ones(size(couN));  
    VARS = ncread(fileN,var_nam,staN,couN,strN);  
    VAR  = cat(1,VARS,VAR);   
end

if ~isempty(i3)
    staN = [min(i3) min(j) 1];    
    endN = [max(i3) max(j) 1];     
    couN = endN - staN + 1;   
    strN = ones(size(couN));
    VARS = ncread(fileN,var_nam,staN,couN,strN);
    VAR  = cat(1,VAR,VARS);     
end

var = VAR';