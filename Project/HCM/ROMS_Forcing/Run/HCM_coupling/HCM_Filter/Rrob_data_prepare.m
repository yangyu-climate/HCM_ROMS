clear
clc

Data_dir  = [pwd,'/Data'];
Save_dir  = [pwd,'/PRE']; 
Save_nam  = 'Rrob.nc';

if ~exist(Save_dir,'dir')
mkdir(Save_dir)
end

fileF = [Data_dir,'/rossrad.dat'];

lon=0.5:1:359.5;
lat=-75.5:1:89.5;
[xx,yy]=meshgrid(lon,lat);

if exist(fileF,'file')
    D = load(fileF);
    X = D(:,2);
    Y = D(:,1);
    R = D(:,4)*1000;
    R = griddata(X,Y,R,xx,yy);
    for TT=1:12
        Rrob(:,:,TT)=R';
    end
end


    
frcname = [Save_dir,'/',Save_nam];
if exist(frcname)
delete(frcname)
end

XT=length(lon);
YT=length(lat);

nccreate(frcname,'time','Dimensions',{'time',12},'Datatype','double')
nccreate(frcname,'lon' ,'Dimensions',{'lon',XT},'Datatype','double')
nccreate(frcname,'lat' ,'Dimensions',{'lat',YT},'Datatype','double')  
nccreate(frcname,'Rrob','Dimensions',{'lon',XT,'lat',YT,'time',12},'Datatype','double')
ncwrite(frcname,'time',[1:12]);
ncwrite(frcname,'lon' ,lon);
ncwrite(frcname,'lat' ,lat);
ncwrite(frcname,'Rrob',Rrob);


S_file = frcname;
fileattrib(S_file,'+w');           
ncwriteatt(S_file,'time','long_name','Time');
ncwriteatt(S_file,'time','units','month'); 
ncwriteatt(S_file,'lon','long_name','longitude');
ncwriteatt(S_file,'lon','units','degrees east');        
ncwriteatt(S_file,'lat','long_name','latitude');
ncwriteatt(S_file,'lat','units','degrees north'); 
ncwriteatt(S_file,'Rrob','long_name','Rossby radius of deformation');
ncwriteatt(S_file,'Rrob','units','m');
ncwriteatt(S_file,'/','creation_date',datestr(now));
    
