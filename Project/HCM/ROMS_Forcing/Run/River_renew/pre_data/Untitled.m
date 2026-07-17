clear
clc

load('利津.mat')

Save_dir = [pwd,'/Result'];
mkdir(Save_dir)

Year = [2002:2020];

for Y_N = 1:length(Year)
    year = Year(Y_N);
    Y_num = num2str(year);

    eval(['D=Runoff',Y_num]);

    for M=1:12
        Data(M,1) = year;
        Data(M,2) = M;
        Data(M,3) = D(M,2); 
    end

    SaveN = [Save_dir,'/',Y_num,'.mat'];
    save(SaveN,'Data')
end
