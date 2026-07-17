function creat_woa_file(filename,varname,lon,lat,dep,var)

[L,M,N] = size(var);


nccreate(filename,varname,'Dimensions',{'lon',L,'lat',M,'depth',N},'Datatype','double')
ncwrite(filename,varname,var)

nccreate(filename,'lon'  ,'Dimensions',{'lon',L},'Datatype','double')
ncwrite(filename,'lon',lon)

nccreate(filename,'lat'  ,'Dimensions',{'lat',M},'Datatype','double')
ncwrite(filename,'lat',lat)

nccreate(filename,'depth','Dimensions',{'depth',N},'Datatype','double')
ncwrite(filename,'depth',dep)
