clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

Data_dir  = [pwd,'/PRE'];
file_name = 'SSH_modify.nc';
filename  = dir([Data_dir,'/',file_name]);

Save_dir  = [pwd,'/MET'];
mkdir(Save_dir)

grd_file  = [Run_dir,'/Data/Grd.nc'];
h         = ncread(grd_file,'h');
lonr      = ncread(grd_file,'lon_rho');
latr      = ncread(grd_file,'lat_rho');
lonu      = ncread(grd_file,'lon_u');
latu      = ncread(grd_file,'lat_u');
lonv      = ncread(grd_file,'lon_v');
latv      = ncread(grd_file,'lat_v');
mask      = ncread(grd_file,'mask_rho');
L         = size(mask,1);
M         = size(mask,2);


if ~isempty(filename)
    file_name = filename.name;
    fileN     = [Data_dir,'/',file_name];
    tim_name  = 'time';
    lon_name  = 'lon';
    lat_name  = 'lat';
    T = double(ncread(fileN,tim_name));
    X = double(ncread(fileN,lon_name));
    Y = double(ncread(fileN,lat_name));
    
    INFO = ncinfo(fileN);
    VARN = INFO.Variables;
        
    for varN = 1:length(VARN)
        var_name = VARN(varN).Name;
        if ~strcmp(var_name,tim_name)...
         &&~strcmp(var_name,lon_name)...
         &&~strcmp(var_name,lat_name)
            LN  = ncreadatt(fileN,var_name,'long_name');
            UT  = ncreadatt(fileN,var_name,'units');      
            VAR = double(ncread(fileN,var_name));
            disp([' '])
            disp(['File: ',fileN])
            disp(['Variable: ',var_name])
            disp(['Long Name: ',LN])
            disp(['Unit: ',UT])
        
            Out_dir = [Save_dir,'/',var_name];
            mkdir(Out_dir)
        
            for NUM = 1:length(T)
                TIME  = T(NUM);
                if TIME<10
                    T_name = ['0',num2str(TIME)];
                    S_name = ['0',num2str(TIME)];
                else
                    T_name = [num2str(TIME)];
                    S_name = [num2str(TIME)];
                end
                S_file = [Out_dir,'/',var_name,'_',S_name,'.nc'];
                delete(S_file)
                creat_met_file(S_file,var_name,L,M)
                disp(['Date: ',T_name])
                var  = squeeze(VAR(:,:,NUM));
                var(isnan(var))=0;

                loc  = find(~isnan(var));
                var  = var(loc);
                Xx   = X(loc);
                Yy   = Y(loc);

                varR = griddata(Xx,Yy,var,lonr,latr);
                varU = griddata(Xx,Yy,var,lonu,latu);
                varV = griddata(Xx,Yy,var,lonv,latv);
            
                ncwrite(S_file,'time'         ,TIME)
                ncwrite(S_file,'lon_r'        ,lonr)
                ncwrite(S_file,'lat_r'        ,latr)
                ncwrite(S_file,[var_name,'_r'],varR)
            
                ncwrite(S_file,'lon_u'        ,lonu)
                ncwrite(S_file,'lat_u'        ,latu)
                ncwrite(S_file,[var_name,'_u'],varU)

                ncwrite(S_file,'lon_v'        ,lonv)
                ncwrite(S_file,'lat_v'        ,latv)
                ncwrite(S_file,[var_name,'_v'],varV)
            
                fileattrib(S_file,'+w');
                ncwriteatt(S_file,'time','long_name','Time');
                ncwriteatt(S_file,'time','units','month');
                ncwriteatt(S_file,'lon_r','long_name','longitude');
                ncwriteatt(S_file,'lon_r','units','degrees east');
                ncwriteatt(S_file,'lat_r','long_name','latitude');
                ncwriteatt(S_file,'lat_r','units','degrees north');
                ncwriteatt(S_file,[var_name,'_r'],'long name',LN);
                ncwriteatt(S_file,[var_name,'_r'],'unit',UT);
                ncwriteatt(S_file,'/','creation_date',datestr(now));
            
                clear varR varU varV
            end       
        end
        
    end 
     
end

