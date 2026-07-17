clear
clc

fileH = 'soda3.12.2_mn_ocean_reg*';
fileF = dir(fileH);

if ~isempty(fileF)
    for N =1:size(fileF,1)
        fileN = fileF(N).name;
        disp(['File: ',fileN])
        if N>1
        ssh  = ssh  + ncread(fileN,'ssh');
        temp = temp + ncread(fileN,'temp');
        salt = salt + ncread(fileN,'salt');
        u    = u    + ncread(fileN,'u');
        v    = v    + ncread(fileN,'v');
        else
        ssh  = ncread(fileN,'ssh');
        temp = ncread(fileN,'temp');
        salt = ncread(fileN,'salt');
        u    = ncread(fileN,'u');
        v    = ncread(fileN,'v');
        end
        xt_ocean = ncread(fileN,'xt_ocean');
        yt_ocean = ncread(fileN,'yt_ocean');
        st_ocean = ncread(fileN,'st_ocean'); 
        xu_ocean = ncread(fileN,'xu_ocean');
        yu_ocean = ncread(fileN,'yu_ocean');
    end
    
    ssh  = ssh /N;
    temp = temp/N;
    salt = salt/N;
    u    = u/N;
    v    = v/N;
    
    XT=length(xt_ocean);
    YT=length(yt_ocean);
    ST=length(st_ocean);
    XU=length(xu_ocean);
    YU=length(yu_ocean);
    
    frcname = 'SODA3.nc';
    
    nccreate(frcname,'time'    ,'Dimensions',{'time'    ,12},'Datatype','double')
    nccreate(frcname,'xt_ocean','Dimensions',{'xt_ocean',XT},'Datatype','double')
    nccreate(frcname,'yt_ocean','Dimensions',{'yt_ocean',YT},'Datatype','double')
    nccreate(frcname,'st_ocean','Dimensions',{'st_ocean',ST},'Datatype','double')
    nccreate(frcname,'xu_ocean','Dimensions',{'xu_ocean',XU},'Datatype','double')
    nccreate(frcname,'yu_ocean','Dimensions',{'yu_ocean',YU},'Datatype','double')
    
    nccreate(frcname,'ssh' ,'Dimensions',{'xt_ocean',XT,'yt_ocean',YT              ,'time',12},'Datatype','double')
    nccreate(frcname,'temp','Dimensions',{'xt_ocean',XT,'yt_ocean',YT,'st_ocean',ST,'time',12},'Datatype','double')
    nccreate(frcname,'salt','Dimensions',{'xt_ocean',XT,'yt_ocean',YT,'st_ocean',ST,'time',12},'Datatype','double')
    nccreate(frcname,'u'   ,'Dimensions',{'xu_ocean',XU,'yu_ocean',YU,'st_ocean',ST,'time',12},'Datatype','double')
    nccreate(frcname,'v'   ,'Dimensions',{'xu_ocean',XU,'yu_ocean',YU,'st_ocean',ST,'time',12},'Datatype','double')
    
    ncwrite(frcname,'time',[1:12]);
    ncwrite(frcname,'xt_ocean',xt_ocean);
    ncwrite(frcname,'yt_ocean',yt_ocean);
    ncwrite(frcname,'st_ocean',st_ocean);
    ncwrite(frcname,'xu_ocean',xu_ocean);
    ncwrite(frcname,'yu_ocean',yu_ocean);

    ncwrite(frcname,'ssh'  ,ssh);
    ncwrite(frcname,'temp' ,temp);
    ncwrite(frcname,'salt' ,salt);
    ncwrite(frcname,'u'    ,u);
    ncwrite(frcname,'v'    ,v);
   
end