clear
clc

Run_dir = ['../../../'];
addpath(Run_dir)
start
warning off


Data_dir = [pwd,'/ChangjiangRiverRunoff'];
Save_dir = [pwd,'/Result'];
mkdir(Save_dir)

Year = [2000:2019];

for Y_N = 1:length(Year)
    year = Year(Y_N);
    Y_num = num2str(year);
    fileN = [Data_dir,'/',Y_num,'Runoff_CJ.txt'];
    D = textread(fileN);
    clear Time DISC Data
    for num = 1:size(D,1)
        Time(num) = datenum([D(num,1),D(num,2),D(num,3)]);
        DISC(num) = D(num,4);
    end
    
    for month = 1:12
        T_beg = datenum([year month   1]);
        T_end = datenum([year month+1 0]);
        loc = find(Time>=T_beg&Time<=T_end);
        Data(month,1) = year;
        Data(month,2) = month;
        Data(month,3) = nanmean(DISC(loc));
    end
    
    SaveN = [Save_dir,'/',Y_num,'.mat'];
    save(SaveN,'Data')

end