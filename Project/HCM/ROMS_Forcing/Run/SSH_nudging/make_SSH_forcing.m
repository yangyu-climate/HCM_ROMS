clear
clc
warning off 

Run_dir = ['../../../'];
addpath(Run_dir)
start

fileT   = [pwd,'/*parameter.m'];         
fileT   = dir(fileT);

if ~isempty(fileT)
    
    P_file = fileT.name;
    run(P_file)

    Data_dir  = [pwd,'/MET'];
    Save_dir  = [pwd,'/Result'];
    mkdir(Save_dir)

    for var_num = 1:variable_number
    
        IN_name      = variable_input_name{var_num};
        OUT_name     = variable_output_name{var_num};
        TIM_name     = variable_time_name{var_num};
        COD_name     = variable_coordinate{var_num};
        LN_name      = variable_longname{var_num};
        UNIT_name    = variable_unit{var_num};
        scale_factor = variable_scale_factor{var_num};
        add_offset   = variable_add_offset{var_num};
    
        disp([ ])
        disp(['Variavle Name: ',OUT_name])
    
        num     = 0;
        varTest = [];
        for T = 1:12
            if T<10
                T_name = ['0',num2str(T)];
                S_name = ['0',num2str(T)];
            else
                T_name = [num2str(T)];
                S_name = [num2str(T)];
            end
            fileD = [Data_dir,'/',IN_name];
            fileN = [IN_name,'_',S_name,'.nc'];
            fileF = [fileD,'/',fileN];
            fileT = dir(fileF);
            if ~isempty(fileT)
                num = num+1;
                if num==1
                    if strcmp(COD_name,'rho')
                        varTest = ncread(fileF,[IN_name,'_r']);
                    elseif strcmp(COD_name,'u')
                        varTest = ncread(fileF,[IN_name,'_u']);
                    elseif strcmp(COD_name,'v')
                        varTest = ncread(fileF,[IN_name,'_v']);
                    end
                end
            end
        end
        Lm  = size(varTest,1);
        Mm  = size(varTest,2);
        Tm  = num;
        clear varTest
    
        FI_name = [OUT_name,'.nc'];
        VI_name = OUT_name;
        TI_name = TIM_name;
        CI_name = COD_name;
        S_file = [Save_dir,'/',FI_name];
        delete(S_file)
        creat_forcing_file(S_file,VI_name,TI_name,CI_name,Lm,Mm,Tm)
        
        disp('Writes into file ...')
        num = 0;
        nc  = netcdf(S_file,'write');
        for T = 1:12
            if T<10
                T_name = ['0',num2str(T)];
                S_name = ['0',num2str(T)];
            else
                T_name = [num2str(T)];
                S_name = [num2str(T)];
            end
            disp(['Date: ',T_name])
            fileD = [Data_dir,'/',IN_name];
            fileN = [IN_name,'_',S_name,'.nc'];
            fileF = [fileD,'/',fileN];
            fileT = dir(fileF);
            if ~isempty(fileT)
                num  = num+1;
                time = Frc_time(T);
                if strcmp(COD_name,'rho')
                    var = ncload_2D(fileF,[IN_name,'_r']);
                elseif strcmp(COD_name,'u')
                    var = ncload_2D(fileF,[IN_name,'_u']);
                elseif strcmp(COD_name,'v')
                    var = ncload_2D(fileF,[IN_name,'_v']);
                end
                nc{TI_name}(num)     = time;
                nc{VI_name}(num,:,:) = var*scale_factor + add_offset; 
            end
        end
        close(nc)

        fileattrib(S_file,'+w');
        ncwriteatt(S_file,TI_name,'long_name',['day in a year with ',num2str(Frc_cycle),' days']);
        ncwriteatt(S_file,TI_name,'units','days');
        ncwriteatt(S_file,TI_name,'cycle_length',Frc_cycle);
        ncwriteatt(S_file,VI_name,'long_name',LN_name);
        ncwriteatt(S_file,VI_name,'units',UNIT_name);
        ncwriteatt(S_file,'/','creation_date',datestr(now));
    
    end
    
else

    disp(['NO PARAMETER FILE: STOP!'])
    
end
