function creat_met_fileT(frcname,varname,Lm,Mm)

Lu = Lm-1;
Mu = Mm;
Lv = Lm;
Mv = Mm-1;

nccreate(frcname,'time'        ,'Dimensions',{                'T',1},'Datatype','double')
nccreate(frcname,'lon_r'       ,'Dimensions',{'Xm',Lm,'Ym',Mm,'T',1},'Datatype','double')
nccreate(frcname,'lat_r'       ,'Dimensions',{'Xm',Lm,'Ym',Mm,'T',1},'Datatype','double')
nccreate(frcname,[varname,'_r'],'Dimensions',{'Xm',Lm,'Ym',Mm,'T',1},'Datatype','double')

end