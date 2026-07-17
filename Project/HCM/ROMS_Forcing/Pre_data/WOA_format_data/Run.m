clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

Data_dir    = ['Z:\Data\WOAPISCES'];
S_dir       = [pwd,'/WOA18_PISCES'];


for Name_num = 1:3
    if Name_num == 1
        H_dir = 'dic';
        V_nam = 'c_an';
        D_nam = 'dic';
    elseif Name_num == 2
        H_dir = 'alkalinity';
        V_nam = 'k_an';
        D_nam = 'talk';
    elseif Name_num == 3
        H_dir = 'iron';
        V_nam = 'f_an';
        D_nam = 'fer';
    end
    disp([' '])
    disp(['Var name: ',H_dir])
    Save_dir  = [S_dir,'/',H_dir];
    mkdir(Save_dir)
    
    for month = 0:12
        if month<10
            month_num = ['0',num2str(month)];	
        else
            month_num = [num2str(month)];
        end
        H_file = ['woa_pisces_all_',V_nam(1),month_num,'_','01.nc'];
        F_name = [Save_dir,'/',H_file];
        disp(['File name: ',H_file])
        T_dir  = Data_dir;
        if month==0
            file_name = [D_nam,'_ann*'];            
            filename  = dir([T_dir,'/',file_name]);
            file_name = filename(1).name;
            fileN     = [T_dir,'/',file_name];
            disp(['Load file: ',fileN])
            lon       = ncread(fileN,'X');
            lat       = ncread(fileN,'Y');
            dep       = ncread(fileN,'Z');
            var       = ncread(fileN,D_nam);
            delete(F_name)
            creat_woa_file(F_name,V_nam,lon,lat,dep,var);
        else
            file_name = [D_nam,'_seas*'];            
            filename  = dir([T_dir,'/',file_name]);
            file_name = filename(1).name;
            fileN     = [T_dir,'/',file_name];
            disp(['Load file: ',fileN])    
            lon       = ncread(fileN,'X');
            lat       = ncread(fileN,'Y');
            dep       = ncread(fileN,'Z');
            var       = ncread(fileN,D_nam);
            var       = squeeze(var(:,:,:,month));
            delete(F_name)
            creat_woa_file(F_name,V_nam,lon,lat,dep,var);
        end
    end
end
