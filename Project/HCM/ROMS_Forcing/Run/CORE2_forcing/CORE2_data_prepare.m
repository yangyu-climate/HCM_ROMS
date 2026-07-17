clear
clc

Save_dir  = [pwd,'/PRE']; 
Save_nam  = 'CORE2.nc';
Dir       = '\\169.254.1.3\Home\Data\CORE2\';
fileH     = [Dir,'*.nc'];
fileF     = dir(fileH);
mkdir(Save_dir)

rhoW      = 1000;
ms_to_cmd = 24*60*60*100;


if ~isempty(fileF)
    for N =1:size(fileF,1)
        fileN = [Dir,fileF(N).name];
        disp(['File: ',fileN])
        if N>1
            F_evap = F_evap + ncread(fileN,'F_evap');
            F_prec = F_prec + ncread(fileN,'F_prec');
            Q_lat  = Q_lat  + ncread(fileN,'Q_lat');
            Q_sen  = Q_sen  + ncread(fileN,'Q_sen');
            Q_lwdn = Q_lwdn + ncread(fileN,'Q_lwdn');
            Q_lwup = Q_lwup + ncread(fileN,'Q_lwup');
            Q_swnet= Q_swnet+ ncread(fileN,'Q_swnet');
            taux   = taux   + ncread(fileN,'taux');
            tauy   = tauy   + ncread(fileN,'tauy');
        else
            F_evap = ncread(fileN,'F_evap');
            F_prec = ncread(fileN,'F_prec');
            Q_lat  = ncread(fileN,'Q_lat');
            Q_sen  = ncread(fileN,'Q_sen');
            Q_lwdn = ncread(fileN,'Q_lwdn');
            Q_lwup = ncread(fileN,'Q_lwup');
            Q_swnet= ncread(fileN,'Q_swnet');
            taux   = ncread(fileN,'taux');
            tauy   = ncread(fileN,'tauy');
            lon    = ncread(fileN,'lon');
            lat    = ncread(fileN,'lat');
        end
    end
    
    F_evap = F_evap /N;
    F_prec = F_prec /N;
    Q_lat  = Q_lat  /N;
    Q_sen  = Q_sen  /N;
    Q_lwdn = Q_lwdn /N;
    Q_lwup = Q_lwup /N;
    Q_lwnet= Q_lwup+Q_lwdn;
    Q_swnet= Q_swnet/N;
    taux   = taux   /N;
    tauy   = tauy   /N;

    swflux = -(F_evap+F_prec)/rhoW*ms_to_cmd;
    shflux = Q_swnet+Q_lwnet+Q_lat+Q_sen;
    swrad  = Q_swnet;
    sustr  = taux;
    svstr  = tauy;

    swflux(isnan(swflux)) = 0;
    shflux(isnan(shflux)) = 0;
    swrad(isnan(swrad)) = 0;
    sustr(isnan(sustr)) = 0;
    svstr(isnan(svstr)) = 0;
        
    XT=length(lon);
    YT=length(lat);
  
    frcname = [Save_dir,'/',Save_nam];
    delete(frcname)
    nccreate(frcname,'time','Dimensions',{'time',12},'Datatype','double')
    nccreate(frcname,'lon' ,'Dimensions',{'lon' ,XT},'Datatype','double')
    nccreate(frcname,'lat' ,'Dimensions',{'lat' ,YT},'Datatype','double')
    
    nccreate(frcname,'swflux','Dimensions',{'lon',XT,'lat',YT,'time',12},'Datatype','double')
    nccreate(frcname,'shflux','Dimensions',{'lon',XT,'lat',YT,'time',12},'Datatype','double')
    nccreate(frcname,'swrad' ,'Dimensions',{'lon',XT,'lat',YT,'time',12},'Datatype','double')
    nccreate(frcname,'sustr' ,'Dimensions',{'lon',XT,'lat',YT,'time',12},'Datatype','double')
    nccreate(frcname,'svstr' ,'Dimensions',{'lon',XT,'lat',YT,'time',12},'Datatype','double')
    
    ncwrite(frcname,'time',[1:12]);
    ncwrite(frcname,'lon' ,lon);
    ncwrite(frcname,'lat' ,lat);

    ncwrite(frcname,'swflux',swflux);
    ncwrite(frcname,'shflux',shflux);
    ncwrite(frcname,'swrad' ,swrad);
    ncwrite(frcname,'sustr' ,sustr);
    ncwrite(frcname,'svstr' ,svstr);

end


S_file = frcname;
fileattrib(S_file,'+w');           
ncwriteatt(S_file,'time','long_name','Time');
ncwriteatt(S_file,'time','units','month'); 
ncwriteatt(S_file,'lon','long_name','longitude');
ncwriteatt(S_file,'lon','units','degrees east');        
ncwriteatt(S_file,'lat','long_name','latitude');
ncwriteatt(S_file,'lat','units','degrees north'); 
ncwriteatt(S_file,'swflux','long_name','surface net freswater flux (E-P)');
ncwriteatt(S_file,'swflux','units','centimeter day-1');
ncwriteatt(S_file,'shflux','long_name','surface net heat flux');
ncwriteatt(S_file,'shflux','units','watt meter-2');
ncwriteatt(S_file,'swrad','long_name','solar shortwave radiation flux');
ncwriteatt(S_file,'swrad','units','watt meter-2');
ncwriteatt(S_file,'sustr','long_name','surface u-momentum stress');
ncwriteatt(S_file,'sustr','units','newton meter-2');
ncwriteatt(S_file,'svstr','long_name','surface v-momentum stress');
ncwriteatt(S_file,'svstr','units','newton meter-2');
ncwriteatt(S_file,'/','creation_date',datestr(now));
    