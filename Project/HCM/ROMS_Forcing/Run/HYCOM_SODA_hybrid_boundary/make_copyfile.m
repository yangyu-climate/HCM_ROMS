clear
clc
warning off 

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

Data_dir    = ['../HYCOM_boundary/Data'];
Save_dir    = [pwd,'/Data'];
mkdir(Save_dir)

time_beg    = [1980 12 28];
time_end    = [2021  1  1];
time_frq    = 5;

T_beg       = datenum(time_beg);
T_end       = datenum(time_end);
T_frq       = time_frq;

for T = T_beg:T_frq:T_end
    [year_num,month_num,day_num,...
     hour_num,minu_num,seco_num] = date2str(T);
    T_name = [year_num,'-',month_num,'-',day_num];
    S_name = [year_num,'-',month_num,'-',day_num];
    disp(T_name)
    file_name = ['*',S_name,'*'];       
    filename  = dir([Data_dir,'/',file_name]);
    if ~isempty(filename)
        file_name = filename.name;
        fileN     = [Data_dir,'/',file_name];
        fileO     = [Save_dir,'/',file_name];
        disp(['file name: ',fileN])
        copyfile(fileN,fileO)
    end
end

