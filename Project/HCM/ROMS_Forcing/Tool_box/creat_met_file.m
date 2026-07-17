function creat_met_file(frcname,varname,Lm,Mm)

Lu = Lm-1;
Mu = Mm;
Lv = Lm;
Mv = Mm-1;

nccreate(frcname,'time'        ,'Dimensions',{                'T',1},'Datatype','double')
nccreate(frcname,'lon_r'       ,'Dimensions',{'Xm',Lm,'Ym',Mm,'T',1},'Datatype','double')
nccreate(frcname,'lat_r'       ,'Dimensions',{'Xm',Lm,'Ym',Mm,'T',1},'Datatype','double')
nccreate(frcname,[varname,'_r'],'Dimensions',{'Xm',Lm,'Ym',Mm,'T',1},'Datatype','double')

nccreate(frcname,'lon_u'       ,'Dimensions',{'Xu',Lu,'Yu',Mu,'T',1},'Datatype','double')
nccreate(frcname,'lat_u'       ,'Dimensions',{'Xu',Lu,'Yu',Mu,'T',1},'Datatype','double')
nccreate(frcname,[varname,'_u'],'Dimensions',{'Xu',Lu,'Yu',Mu,'T',1},'Datatype','double')

nccreate(frcname,'lon_v'       ,'Dimensions',{'Xv',Lv,'Yv',Mv,'T',1},'Datatype','double')
nccreate(frcname,'lat_v'       ,'Dimensions',{'Xv',Lv,'Yv',Mv,'T',1},'Datatype','double')
nccreate(frcname,[varname,'_v'],'Dimensions',{'Xv',Lv,'Yv',Mv,'T',1},'Datatype','double')


end