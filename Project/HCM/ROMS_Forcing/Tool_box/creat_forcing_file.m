function creat_forcing_file(frcname,VI_name,TI_name,CI_name,Lm,Mm,Tm)

nccreate(frcname,TI_name,'Dimensions',{                                        TI_name,Tm},'Datatype','double')
nccreate(frcname,VI_name,'Dimensions',{['xi_',CI_name],Lm ,['eta_',CI_name],Mm,TI_name,Tm},'Datatype','double')
    