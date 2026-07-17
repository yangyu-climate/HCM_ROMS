clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start

ERA5_forcing_parameter

Data_dir  = ERA_dir;
Save_dir  = [pwd,'/MET'];
mkdir(Save_dir)

H_file    = ['ERA5'];
ref_time  = [1900 1 1 0 0 0];
time_rat  = 1/24; %hour to day
time_frq  = 1/24; %data frequency (days)

T_beg     = datenum(Time_beg);
T_end     = datenum(Time_end);
T_frq     = Time_frq/time_frq;

file_name = [H_file,'*.nc'];            
filename  = dir([Data_dir,'/',file_name]);

grd_file  = [Run_dir,'/Data/Grd.nc'];
h         = ncread(grd_file,'h');
lonr      = ncread(grd_file,'lon_rho');
latr      = ncread(grd_file,'lat_rho');
% lonu      = ncread(grd_file,'lon_u');
% latu      = ncread(grd_file,'lat_u');
% lonv      = ncread(grd_file,'lon_v');
% latv      = ncread(grd_file,'lat_v');
mask      = ncread(grd_file,'mask_rho');
L         = size(mask,1);
M         = size(mask,2);

if min(min(lonr))<0
    Xchange = 1;
else
    Xchange = 0;
end

if ~isempty(filename)
  for N = 1:length(filename)  
    file_name = filename(N).name;
    fileN     = [Data_dir,'/',file_name];
    tim_name  = 'time';
    lon_name  = 'longitude';
    lat_name  = 'latitude';
    T = double(ncread(fileN,tim_name))*time_rat + datenum(ref_time);
    X = double(ncread(fileN,lon_name));
    Y = double(ncread(fileN,lat_name));
    Time_test = find(T>=T_beg&T<=T_end);
    if ~isempty(Time_test)
      [X,Y] = meshgrid(X,Y);
      X     = X';
      Y     = Y';
      X(X<0)= X(X<0)+360;
      if Xchange==1
        X=[X-360;X];
        Y=[Y;Y];
      end
    
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
        
          for NUM = 1:T_frq:length(T)
            TIME  = T(NUM);
            if TIME>=T_beg&&TIME<=T_end
            [year_num,month_num,day_num,...
             hour_num,minu_num,seco_num] = date2str(TIME);
            T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':00:00'];
            S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-00-00'];
            S_file = [Out_dir,'/',var_name,'_',S_name,'.nc'];
            delete(S_file)
            creat_met_fileR(S_file,var_name,L,M)
            disp(['Date: ',T_name])
            var  = squeeze(VAR(:,:,NUM));
            if Xchange==1
                var=[var;var];
            end
            loc  = find(X>=min(min(lonr))-1 ...
                      & X<=max(max(lonr))+1 ...
                      & Y>=min(min(latr))-1 ...
                      & Y<=max(max(latr))+1 );
            var  = var(loc);
            Xx   = X(loc);
            Yy   = Y(loc);
            loc  = find(~isnan(var));
            var  = var(loc);
            Xx   = Xx(loc);
            Yy   = Yy(loc);
            varR = griddata(Xx,Yy,var,lonr,latr);
%             varU = griddata(Xx,Yy,var,lonu,latu);
%             varV = griddata(Xx,Yy,var,lonv,latv);
            
            ncwrite(S_file,'time'         ,TIME)
            ncwrite(S_file,'lon_r'        ,lonr)
            ncwrite(S_file,'lat_r'        ,latr)
            ncwrite(S_file,[var_name,'_r'],varR)
            
%             ncwrite(S_file,'lon_u'        ,lonu)
%             ncwrite(S_file,'lat_u'        ,latu)
%             ncwrite(S_file,[var_name,'_u'],varU)
% 
%             ncwrite(S_file,'lon_v'        ,lonv)
%             ncwrite(S_file,'lat_v'        ,latv)
%             ncwrite(S_file,[var_name,'_v'],varV)
            
            fileattrib(S_file,'+w');
            ncwriteatt(S_file,'time','long name','Time');
            ncwriteatt(S_file,'time','unit','days since 0000-00-00');
            ncwriteatt(S_file,'lon_r','long name','longitude');
            ncwriteatt(S_file,'lon_r','unit','degrees east');
            ncwriteatt(S_file,'lat_r','long name','latitude');
            ncwriteatt(S_file,'lat_r','unit','degrees north');
            ncwriteatt(S_file,[var_name,'_r'],'long name',LN);
            ncwriteatt(S_file,[var_name,'_r'],'unit',UT);
            ncwriteatt(S_file,'/','creation_date',datestr(now));
            
            clear varR varU varV
            end       
          end
        
        end
      end 
  
    end
    
  end
end
