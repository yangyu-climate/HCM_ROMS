clear
clc
warning off 

Run_dir = ['../../../../'];
addpath(Run_dir)
start
% warning off

Data_dir   = ['../../Data'];
Save_dir   = [pwd,'/Result'];
mkdir(Save_dir)

DYN_IniF   = ['D:\ROMS_Forcing\Data\Ini.nc'];
BIO_IniF   = [Save_dir,'/Ini_Bio.nc'];

delete(BIO_IniF)
copyfile(DYN_IniF,BIO_IniF)
add_ini_UMaine31Fe(BIO_IniF,'write')

grd_file   = [Run_dir,'/Data/Grd.nc'];
h          = ncread(grd_file,'h');
lon        = ncread(grd_file,'lon_rho');
lat        = ncread(grd_file,'lat_rho');

zeta       = ncread(BIO_IniF,'zeta');
theta_s    = ncread(BIO_IniF,'theta_s');
theta_b    = ncread(BIO_IniF,'theta_b');
vtransform = ncread(BIO_IniF,'Vtransform');
hc         = ncread(BIO_IniF,'hc');
s_rho      = ncread(BIO_IniF,'sc_r');
layerN     = length(s_rho);

for Name_num = 1:7
    R_factor = 1029/1000;
    if Name_num == 1
        H_dir = 'nitrate';
        V_nam = 'NO3';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 2
        H_dir = 'phosphate';
        V_nam = 'PO4';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 3
        H_dir = 'silicate';
        V_nam = 'SiOH';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 4
        H_dir = 'oxygen';
        V_nam = 'oxyg';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 5
        H_dir = 'dic';
        V_nam = 'TIC';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 6
        H_dir = 'alkalinity';
        V_nam = 'Talk';
        Fscale= 1;
        Fadd  = 0;
    elseif Name_num == 7
        H_dir = 'iron';
        V_nam = 'FeD';
        Fscale= 1000;
        Fadd  = 0;
    end
    disp(['Nutrition components: ',H_dir])

    for Month = 1
        if Month<10
            NN = ['0',num2str(Month)];
        else
            NN = [num2str(Month)];
        end
        disp(['Month: ',NN])
        filename = [Data_dir,'/*', H_dir,'_',NN,'.nc'];
        fileF    = dir(filename);
        if ~isempty(fileF)
            fileN  = [Data_dir,'/',fileF.name];
            disp(['Load data from: ',fileN])
            depth  = ncread(fileN,'depth');
            varT   = ncread(fileN,'var')*R_factor;
            dd     = -depth;
            z      = zlevs(h,zeta*0,theta_s,theta_b,hc,layerN,'r',vtransform);
            var    = zeros(size(z));
            for i=1:size(h,1)
                for j=1:size(h,2)
                    var(i,j,:) = interp1(dd,squeeze(varT(i,j,:)),squeeze(z(i,j,:)));
                end
            end
            var(isnan(var)) = 0;
            var = Fscale*var+Fadd;
            ncwrite(BIO_IniF,V_nam,var);
            clear var
        end
    end
end
