clear
clc

Save_dir  = [pwd,'/PRE']; 
Save_nam  = 'SSH.nc';
Dir       = '/public/home/yuyang/application/HCM/SPIN_CLIM/Result/';
fileH     = [Dir,'avg*.nc'];
fileF     = dir(fileH);
mkdir(Save_dir)

if ~isempty(fileF)
    for N =1:size(fileF,1)
        fileN = [Dir,fileF(N).name];
        disp(['File: ',fileN])
        month = mod(N,12);
        if month==0
            month = 12; 
        end
        year = (N-month)/12+1;
        disp(['Year: ',num2str(year),' Month: ',num2str(month)])
        mask = ncread(fileN,'mask_rho');
        lon  = ncread(fileN,'lon_rho');
        lat  = ncread(fileN,'lat_rho');
        var  = ncread(fileN,'zeta');
        SSH(:,:,month,year) = squeeze(var).*mask;
    end
    
    SSH = squeeze(nanmean(SSH(:,:,:,end-3:end),4));  
    XT=size(SSH,1);
    YT=size(SSH,2);
  
    frcname = [Save_dir,'/',Save_nam];
    delete(frcname)
    nccreate(frcname,'time','Dimensions',{'time',12},'Datatype','double')
    nccreate(frcname,'lon' ,'Dimensions',{'lon',XT,'lat',YT},'Datatype','double')
    nccreate(frcname,'lat' ,'Dimensions',{'lon',XT,'lat',YT},'Datatype','double')  
    nccreate(frcname,'SSH' ,'Dimensions',{'lon',XT,'lat',YT,'time',12},'Datatype','double')
    ncwrite(frcname,'time',[1:12]);
    ncwrite(frcname,'lon' ,lon);
    ncwrite(frcname,'lat' ,lat);
    ncwrite(frcname,'SSH',SSH);


    S_file = frcname;
    fileattrib(S_file,'+w');           
    ncwriteatt(S_file,'time','long_name','Time');
    ncwriteatt(S_file,'time','units','month'); 
    ncwriteatt(S_file,'lon','long_name','longitude');
    ncwriteatt(S_file,'lon','units','degrees east');        
    ncwriteatt(S_file,'lat','long_name','latitude');
    ncwriteatt(S_file,'lat','units','degrees north'); 
    ncwriteatt(S_file,'SSH','long_name','sea surface height');
    ncwriteatt(S_file,'SSH','units','meter');
    ncwriteatt(S_file,'/','creation_date',datestr(now));
    
end

