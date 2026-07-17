function var_s = interp_ocean(x,y,var,lon,lat);

[L,M] = size(var);
X   = reshape(x  ,L*M,1);
Y   = reshape(y  ,L*M,1);
V   = reshape(var,L*M,1);
loc = find(~isnan(V));

var_s = griddata(X(loc),Y(loc),V(loc),lon,lat);
if isempty(var_s)
var_s = nan*ones(size(lon.*lat));
end
