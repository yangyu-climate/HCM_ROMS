%%%%%%%%%%%%%%%%%%%%% USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%
Riv_parameter

River_dir = [pwd,'/River'];
RvBio_dir = [pwd,'/River/River_BIO'];
mkdir(RvBio_dir)
[DD,TT,NN]  = xlsread([River_dir ,'/River_location.xlsx']);
rivernumber = size(NN,2);


%Set default value
DR_NO3  = 15;
DR_NH4  = 0;
DR_SiOH = 0.05;
DR_PO4  = 0.2;
DR_OXY  = 233.15;
DR_TIC  = 2111;
DR_ALK  = 2353;


DIS{1,1}    = 'Number';
DIS{2,1}    = 'Name';
DIS{2+1,1}  = 'January';
DIS{2+2,1}  = 'February';
DIS{2+3,1}  = 'March';
DIS{2+4,1}  = 'April';
DIS{2+5,1}  = 'May';
DIS{2+6,1}  = 'June';
DIS{2+7,1}  = 'July';
DIS{2+8,1}  = 'August';
DIS{2+9,1}  = 'September';
DIS{2+10,1} = 'October';
DIS{2+11,1} = 'November';
DIS{2+12,1} = 'December';

DIS_NO3     = DIS;
DIS_NH4     = DIS;
DIS_SiOH    = DIS;
DIS_PO4     = DIS;
DIS_OXY     = DIS;
DIS_TIC     = DIS;
DIS_ALK     = DIS;


for NUM = 2:rivernumber
    % NO3
    DIS_NO3{1,NUM}    = NN{1,NUM};
    DIS_NO3{2,NUM}    = NN{2,NUM};
    for M =1:12
      DIS_NO3{2+M,NUM}= DR_NO3;
    end
    % NH4
    DIS_NH4{1,NUM}    = NN{1,NUM};
    DIS_NH4{2,NUM}    = NN{2,NUM};
    for M =1:12
      DIS_NH4{2+M,NUM}= DR_NH4;
    end
    % SiOH
    DIS_SiOH{1,NUM}    = NN{1,NUM};
    DIS_SiOH{2,NUM}    = NN{2,NUM};
    for M =1:12
      DIS_SiOH{2+M,NUM}= DR_SiOH;
    end
    % PO4
    DIS_PO4{1,NUM}    = NN{1,NUM};
    DIS_PO4{2,NUM}    = NN{2,NUM};
    for M =1:12
      DIS_PO4{2+M,NUM}= DR_PO4;
    end
    % OXY
    DIS_OXY{1,NUM}    = NN{1,NUM};
    DIS_OXY{2,NUM}    = NN{2,NUM};
    for M =1:12
      DIS_OXY{2+M,NUM}= DR_OXY;
    end
    % TIC
    DIS_TIC{1,NUM}    = NN{1,NUM};
    DIS_TIC{2,NUM}    = NN{2,NUM};
    for M =1:12
      DIS_TIC{2+M,NUM}= DR_TIC;
    end
    % ALK
    DIS_ALK{1,NUM}    = NN{1,NUM};
    DIS_ALK{2,NUM}    = NN{2,NUM};
    for M =1:12
      DIS_ALK{2+M,NUM}= DR_ALK;
    end
end
xlswrite([RvBio_dir,'/River_NO3.xlsx']  ,DIS_NO3)
xlswrite([RvBio_dir,'/River_NH4.xlsx']  ,DIS_NH4)
xlswrite([RvBio_dir,'/River_SiOH.xlsx'] ,DIS_SiOH)
xlswrite([RvBio_dir,'/River_PO4.xlsx']  ,DIS_PO4)
xlswrite([RvBio_dir,'/River_OXY.xlsx']  ,DIS_OXY)
xlswrite([RvBio_dir,'/River_TIC.xlsx']  ,DIS_TIC)
xlswrite([RvBio_dir,'/River_ALK.xlsx']  ,DIS_ALK)

