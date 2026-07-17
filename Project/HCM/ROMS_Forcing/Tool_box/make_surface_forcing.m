clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start

fileT   = [pwd,'/*parameter.m'];         
fileT   = dir(fileT);

if ~isempty(fileT) 

    P_file = fileT.name;
    run(P_file)

    if ~exist('IF_Separate','var')
        IF_Separate=0;
    end

    Data_dir  = [pwd,'/MET'];
    Save_dir  = [pwd,'/Result'];
    mkdir(Save_dir)

    if IF_Separate==1
        TRL = Time_end(1)-Time_beg(1)+1;
        YSE = Time_beg(1):Time_end(1);
        MFG = 0;
        if Time_end(2)==1&&Time_end(3)==1&&...
           Time_end(4)==0&&Time_end(5)==0&&...
           Time_end(6)==0
        TRL = TRL-1;
        MFG = 1;
        end
        for TranN = 1:TRL
            if TranN==1
                Tbeg=datenum(Time_beg);
              if TRL>1
                Yend=YSE(TranN+1);
                Tend=datenum([Yend,1,1,0,0,0])-Time_frq;
              else
                Tend=datenum(Time_end);
              end
                T_range(TranN,1) = Tbeg;
                T_range(TranN,2) = Tend;
            elseif TranN<TRL
                Ybeg=YSE(TranN);
                Yend=YSE(TranN+1);
                Tbeg=datenum([Ybeg,1,1,0,0,0]);
                Tend=datenum([Yend,1,1,0,0,0])-Time_frq;
                T_range(TranN,1) = Tbeg;
                T_range(TranN,2) = Tend;
            else
                Ybeg=YSE(TranN);
                Tbeg=datenum([Ybeg,1,1,0,0,0]);
              if MFG==1
                Yend=YSE(TranN+1);
                Tend=datenum([Yend,1,1,0,0,0]);
              else
                Tend=datenum(Time_end);
              end
                T_range(TranN,1) = Tbeg;
                T_range(TranN,2) = Tend; 
            end
        end
    else
        T_range(1,1) = datenum(Time_beg);
        T_range(1,2) = datenum(Time_end);
    end

    for TranN=1:size(T_range,1)

        T_beg = T_range(TranN,1);
        T_end = T_range(TranN,2);
        T_ref = datenum(Time_ref);
        if IF_Separate==1
            [year_num,month_num,day_num,...
             hour_num,minu_num,seco_num] = date2str(T_beg);
            fileE = ['_',year_num];
        else
            fileE = '';
        end

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
            for T = T_beg:Time_frq:T_end
                [year_num,month_num,day_num,...
                 hour_num,minu_num,seco_num] = date2str(T);
                T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':00:00'];
                S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-00-00'];
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
    
            FI_name = [OUT_name,fileE,'.nc'];
            VI_name = OUT_name;
            TI_name = TIM_name;
            CI_name = COD_name;
            S_file = [Save_dir,'/',FI_name];
            delete(S_file)
            creat_forcing_file(S_file,VI_name,TI_name,CI_name,Lm,Mm,Tm)
        
            disp('Writes into file ...')
            num = 0;
            nc  = netcdf(S_file,'write');
            for T = T_beg:Time_frq:T_end
                [year_num,month_num,day_num,...
                 hour_num,minu_num,seco_num] = date2str(T);
                T_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,':00:00'];
                S_name = [year_num,'-',month_num,'-',day_num,'-',hour_num,'-00-00'];
                disp(['Date: ',T_name])
                fileD = [Data_dir,'/',IN_name];
                fileN = [IN_name,'_',S_name,'.nc'];
                fileF = [fileD,'/',fileN];
                fileT = dir(fileF);
                if ~isempty(fileT)
                    num  = num+1;
                    time = T - T_ref;
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
            ncwriteatt(S_file,TI_name,'long_name',['days since ',datestr(T_ref,31)]);
            ncwriteatt(S_file,TI_name,'units','days');
            ncwriteatt(S_file,VI_name,'long_name',LN_name);
            ncwriteatt(S_file,VI_name,'units',UNIT_name);
            ncwriteatt(S_file,'/','creation_date',datestr(now));
        end
    
    end

    
else

    disp(['NO PARAMETER FILE: STOP!'])
    
end
