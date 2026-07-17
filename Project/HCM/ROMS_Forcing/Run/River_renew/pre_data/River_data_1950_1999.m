clear
clc

Run_dir = ['../../../'];
addpath(Run_dir)
start
warning off


Data_dir = [pwd,'/ChangjiangRiverRunoff'];
Save_dir = [pwd,'/Result'];
mkdir(Save_dir)

fileN = [Data_dir,'/lijin.xlsx'];

D  = xlsread(fileN);

for num = 1:size(D,1)
%     year  = 1900+D(num,1);
    year  = D(num,1);
    Y_num = num2str(year);
    for month = 1:12
        Data(month,1) = year;
        Data(month,2) = month;
        Data(month,3) = D(num,month+1);
    end
    
    SaveN = [Save_dir,'/',Y_num,'.mat'];
    save(SaveN,'Data')
end


