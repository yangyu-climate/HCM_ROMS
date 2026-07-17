clear
clc
warning off 

Run_dir = ['../../../'];
addpath(Run_dir)
start

fileT   = [pwd,'/*parameter.m'];         
fileT   = dir(fileT);

if ~isempty(fileT) 
    P_file = fileT.name;
    run(P_file)
end

Save_dir= [pwd,'/Result'];
mkdir(Save_dir)
fileS   = [Save_dir,'/',Frc_name];
if exist(fileS,'file')
delete(fileS)
end

TIM_name = variable_time_name;
COD_name = variable_coordinate;
Tm       = length(Frc_time);

nccreate(fileS,TIM_name,'Dimensions',{TIM_name,Tm},'Datatype','double')
ncwriteatt(fileS,TIM_name,'long_name',['day in a year with ',num2str(Frc_cycle),' days']); 
ncwriteatt(fileS,TIM_name,'units','days');
ncwriteatt(fileS,TIM_name,'cycle_length',Frc_cycle);
nc  = netcdf(fileS,'write');
for num=1:length(Frc_time)
time = Frc_time(num);
nc{TIM_name}(num) = time;  
end
close(nc)

LON    = load_data(Met_file,'lonr');
LAT    = load_data(Met_file,'latr');
dUdT_M = load_data(Met_file,'dUdT_M');
dVdT_M = load_data(Met_file,'dVdT_M');
dTdT_W = load_data(Met_file,'dTdT_W');

dUdT_M(isnan(dUdT_M))=0;
dVdT_M(isnan(dVdT_M))=0;
dTdT_W(isnan(dTdT_W))=0;

for modeN = 1:Mode_N
    if modeN<10
    mode_num=['0',num2str(modeN)];
    else
    mode_num=[num2str(modeN)];
    end

    dUdTm = squeeze(dUdT_M(:,:,modeN,:));
    dVdTm = squeeze(dVdT_M(:,:,modeN,:));
    dTdTw = squeeze(dTdT_W(:,:,modeN,:));

    varTest=dUdTm.*dVdTm.*dTdTw;
    Lm  = size(varTest,1);
    Mm  = size(varTest,2);
    clear varTest

    for var_num = 1:variable_number
    if var_num == 1
    var      = dUdTm;
    var_name = ['TIW_U',mode_num];
    elseif var_num == 2
    var      = dVdTm;
    var_name = ['TIW_V',mode_num];
    elseif var_num == 3
    var      = dTdTw;
    var_name = ['TIW_T',mode_num];
    end

    LN_name      = ['Mode ',mode_num,' ',variable_longname{var_num}];
    UNIT_name    = variable_unit{var_num};
    scale_factor = variable_scale_factor{var_num};
    add_offset   = variable_add_offset{var_num};

    disp(LN_name)
    var = var*scale_factor+add_offset;

    nccreate(fileS,var_name,'Dimensions',{['xi_',COD_name],Lm ,['eta_',COD_name],Mm,TIM_name,Tm},'Datatype','double')
    ncwriteatt(fileS,var_name,'long_name',LN_name);
    ncwriteatt(fileS,var_name,'units',UNIT_name);

    nc  = netcdf(fileS,'write');
    for num=1:length(Frc_time)
    nc{var_name}(num,:,:) = squeeze(var(:,:,num))'; 
    end
    close(nc)

    end
end

% empty sustrTIW & svstrTIW
%--------------------------------------------------------------------------
TIM_name = 'hcm_time';
Tm       = length(Frc_time);
nccreate(fileS,TIM_name,'Dimensions',{TIM_name,Tm},'Datatype','double')
ncwriteatt(fileS,TIM_name,'long_name',['day in a year with ',num2str(Frc_cycle),' days']); 
ncwriteatt(fileS,TIM_name,'units','days');
ncwriteatt(fileS,TIM_name,'cycle_length',Frc_cycle);
nc  = netcdf(fileS,'write');
for num=1:length(Frc_time)
time = Frc_time(num);
nc{TIM_name}(num) = time;  
end
close(nc)
var_name  = 'sustrTIW';
COD_name  = 'u';
Lm        = size(LON,1)-1;
Mm        = size(LON,2);
LN_name   = 'TIW east-west surface stress anomaly';
UNIT_name = 'N m-2';
disp(var_name)
nccreate(fileS,var_name,'Dimensions',{['xi_',COD_name],Lm ,['eta_',COD_name],Mm,TIM_name,Tm},'Datatype','double')
ncwriteatt(fileS,var_name,'long_name',LN_name);
ncwriteatt(fileS,var_name,'units',UNIT_name);
nc  = netcdf(fileS,'write');
for num=1:length(Frc_time)
nc{var_name}(num,:,:) = 0*ones(size(Lm,Mm)); 
end
close(nc)
var_name  = 'svstrTIW';
COD_name  = 'v';
Lm        = size(LAT,1);
Mm        = size(LAT,2)-1;
LN_name   = 'TIW north-south surface stress anomaly';
UNIT_name = 'N m-2';
disp(var_name)
nccreate(fileS,var_name,'Dimensions',{['xi_',COD_name],Lm ,['eta_',COD_name],Mm,TIM_name,Tm},'Datatype','double')
ncwriteatt(fileS,var_name,'long_name',LN_name);
ncwriteatt(fileS,var_name,'units',UNIT_name);
nc  = netcdf(fileS,'write');
for num=1:length(Frc_time)
nc{var_name}(num,:,:) = 0*ones(size(Lm,Mm)); 
end
close(nc)
%--------------------------------------------------------------------------

fileattrib(fileS,'+w');
ncwriteatt(fileS,'/','creation_date',datestr(now));

% 
