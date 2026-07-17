clear
clc
warning off 

Run_dir = ['../../../../'];
addpath(Run_dir)
start
% warning off
time_beg    = [2011 7 28 0 0 0];
time_end    = [2011 8  9 0 0 0];
time_ref    = [2011 1  0 0 0 0];
time_frq    = 1;

T_beg    = datenum(time_beg);
T_end    = datenum(time_end);
T_frq    = time_frq;
bry_time = (T_beg:T_frq:T_end)-T_beg;

S_file      = 'Bry_Bio.nc';       
title       = 'Muifa_BIO';
obc         = [1 1 1 1];
theta_s     = 4.5;
theta_b     = 1.5;
hc          = 5;
layer_N     = 40;       
clobber     = 'clobber';      
vtransform  = 2;
type        = 'r';

Ycycle      = 365.25;

Data_dir    = [pwd,'/Data'];
Save_dir    = [pwd,'/Result'];
mkdir(Save_dir)

G_file      = [Run_dir,'Data/Grd.nc'];
grd_file    = G_file;
h           = ncload_2D(grd_file,'h');
lonr        = ncload_2D(grd_file,'lon_rho');
latr        = ncload_2D(grd_file,'lat_rho');
lonu        = ncload_2D(grd_file,'lon_u');
latu        = ncload_2D(grd_file,'lat_u');
lonv        = ncload_2D(grd_file,'lon_v');
latv        = ncload_2D(grd_file,'lat_v');

bryname = [Save_dir,'/',S_file];
grdname = G_file;
delete(bryname)
time = bry_time;
create_bry_UMaine15(bryname,grdname,title,obc,...
                    theta_s,theta_b,hc,layer_N,...
                    time,Ycycle,clobber,vtransform)
                    
for Name_num = 1:13
    if Name_num == 1
        H_name = 'NO3';
        V_name = 'NO3';
    elseif Name_num == 2
        H_name = 'NH4';
        V_name = 'NH4';
    elseif Name_num == 3
        H_name = 'SiOH';
        V_name = 'SiOH';
    elseif Name_num == 4
        H_name = 'PO4';
        V_name = 'PO4';
    elseif Name_num == 5
        H_name = 'nanophytoplankton';
        V_name = 'nanophy';
    elseif Name_num == 6
        H_name = 'diatom';
        V_name = 'diatom';
    elseif Name_num == 7
        H_name = 'microzooplankton';
        V_name = 'microzoo';
    elseif Name_num == 8
        H_name = 'mesozooplankton';
        V_name = 'mesozoo';
    elseif Name_num == 9
        H_name = 'detritus';
        V_name = 'detritus';
    elseif Name_num == 10
        H_name = 'opal';
        V_name = 'opal';
    elseif Name_num == 11
        H_name = 'Oxyg';
        V_name = 'Oxyg';
    elseif Name_num == 12
        H_name = 'Talk';
        V_name = 'Talk';
    elseif Name_num == 13
        H_name = 'TIC';
        V_name = 'TIC';
    end
    disp([' '])
    disp(['Nutrition components: ',H_name])
    TIME   = [];
    H_file = [H_name,'_*'];
    file_name = [H_file,'.nc'];            
    filename  = dir([Data_dir,'/',file_name]);
            
    if ~isempty(filename)
        for FN =1:length(filename)
            file_name = filename(FN).name;
            fileN     = [Data_dir,'/',file_name];
            TIME(FN)  = ncread(fileN,'time');
        end
    
        num = 0;
        for T=T_beg:T_frq:T_end
            num = num+1;
            var = [];
            [year_num,month_num,day_num,...
            hour_num,minu_num,seco_num] = date2str(T);
            T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':',minu_num,':',seco_num];
            disp(['Date: ',T_name])
            TT = TIME-T;
            loc = find((abs(TT)==min(abs(TIME-T))));
            for NN =1:length(loc)
                Tloc  = loc(NN);
                fileN = [Data_dir,'/',filename(Tloc).name];
                disp(['Load data form:',fileN])
                var(NN,:,:,:) = ncload_3D(fileN,'var');
            end
            if length(loc)>1
                var = squeeze(nanmean(var));
            else
                var = squeeze(var);
            end
            
            for k=1:size(var,1)
                VAR = squeeze(var(k,:,:));
                VAR(isnan(VAR)) = nanmean(nanmean(VAR));
                var(k,:,:) = VAR;
            end
            var(isnan(var)) = 0;
            
            varT_south = squeeze(var(:,1,:));
            varT_east  = squeeze(var(:,:,end));
            varT_north = squeeze(var(:,end,:));
            varT_west  = squeeze(var(:,:,1));
            
            nc = netcdf(bryname,'write');  
            disp('Writes into broundary file ...')
            for obc_num = 1:4
            if obc_num==1
                suffix ='_south';
                varT   = varT_south;
            elseif obc_num==2
                suffix ='_east';
                varT   = varT_east;
            elseif obc_num==3
                suffix ='_north';
                varT   = varT_north;  
            elseif obc_num==4
                suffix ='_west';
                varT   = varT_west;
            end
            nc{[V_name,suffix]}(num,:,:) =squeeze(varT);
            end
            close(nc)

        end
    end


end


