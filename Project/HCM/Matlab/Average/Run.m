clear
clc

Run_dir = ['../'];
addpath(Run_dir);
start
warning off
%----------------------------------------------------------------
IF_DIAGNOSTICS = 1;
IF_SALINITY    = 1;
HCM_DIA_OUTPUT = 1;

Y_limit  = [21:30];
M_limit  = [1:12];

Data_dir = ['../Zcoordinate/Result'];
fil_hard = 'DIA';
out_hard = 'CLM';

Save_dir = [pwd,'/Result'];
if ~exist(Save_dir,'dir')
mkdir(Save_dir)
end

for Mnum = 1:length(M_limit)
    month = mod(M_limit(Mnum),12);
    if month==0
        month=12;
    end
    if month<10
        month_num = ['0',num2str(month)];
    else
        month_num = [num2str(month)];
    end
    disp([' '])
    disp(['Month :',month_num])

    num = 0;
    for Ynum = 1:length(Y_limit)
        num = num+1;
        year = Y_limit(Ynum);
        if year<10
            year_num = ['000',num2str(year)];
        elseif year<100
            year_num = ['00',num2str(year)];
        elseif year<1000
            year_num = ['0',num2str(year)];
        else
            year_num = [num2str(year)];
        end
        T_name = [year_num,'-',month_num];
        fileN = [Data_dir,'/',fil_hard,'_',T_name,'.nc'];
        disp(['Model Time: ',T_name]);
        disp(['File: ',fileN]);
        if num==1
            % coordinate parameters
            TIME              = ncread(fileN,'time');
            Z                 = ncread(fileN,'z');
            lon               = ncread(fileN,'lon');
            lat               = ncread(fileN,'lat');
            % 2D variables
            zeta              = ncread(fileN,'zeta');
            sustr             = ncread(fileN,'sustr');
            svstr             = ncread(fileN,'svstr');
            shflux            = ncread(fileN,'shflux');
            ssflux            = ncread(fileN,'ssflux');
            swrad             = ncread(fileN,'swrad');
            lwrad             = ncread(fileN,'lwrad');
            latent            = ncread(fileN,'latent');
            sensible          = ncread(fileN,'sensible');
            evap              = ncread(fileN,'evap');
            rain              = ncread(fileN,'rain');
            % 3D variables
            u                 = ncread(fileN,'u');
            v                 = ncread(fileN,'v');
            w                 = ncread(fileN,'w');
            temp              = ncread(fileN,'temp');
            salt              = ncread(fileN,'salt');
            rho               = ncread(fileN,'rho');
            % Budget terms
            if IF_DIAGNOSTICS
            temp_rate         = ncread(fileN,'temp_rate');
            temp_hadv         = ncread(fileN,'temp_hadv');
            temp_vadv         = ncread(fileN,'temp_vadv');
            temp_hdiff        = ncread(fileN,'temp_hdiff');
            temp_vdiff        = ncread(fileN,'temp_vdiff');
            if IF_SALINITY
            salt_rate         = ncread(fileN,'salt_rate');
            salt_hadv         = ncread(fileN,'salt_hadv');
            salt_vadv         = ncread(fileN,'salt_vadv');
            salt_hdiff        = ncread(fileN,'salt_hdiff');
            salt_vdiff        = ncread(fileN,'salt_vdiff');
            end
            if HCM_DIA_OUTPUT
            temp_rhr          = ncread(fileN,'temp_rhr');
            temp_shr          = ncread(fileN,'temp_shr');
            end
            end
        else
            % coordinate parameters
            TIME              = ncread(fileN,'time')+TIME;
            Z                 = ncread(fileN,'z')   +Z;
            lon               = ncread(fileN,'lon') +lon;
            lat               = ncread(fileN,'lat') +lat;
            % 2D variables
            zeta              = ncread(fileN,'zeta')    +zeta;
            sustr             = ncread(fileN,'sustr')   +sustr;
            svstr             = ncread(fileN,'svstr')   +svstr;
            shflux            = ncread(fileN,'shflux')  +shflux;
            ssflux            = ncread(fileN,'ssflux')  +ssflux;
            swrad             = ncread(fileN,'swrad')   +swrad;
            lwrad             = ncread(fileN,'lwrad')   +lwrad;
            latent            = ncread(fileN,'latent')  +latent;
            sensible          = ncread(fileN,'sensible')+sensible;
            evap              = ncread(fileN,'evap')    +evap;
            rain              = ncread(fileN,'rain')    +rain;
            % 3D variables
            u                 = ncread(fileN,'u')   +u;
            v                 = ncread(fileN,'v')   +v;
            w                 = ncread(fileN,'w')   +w;
            temp              = ncread(fileN,'temp')+temp;
            salt              = ncread(fileN,'salt')+salt;
            rho               = ncread(fileN,'rho') +rho;
            % Budget terms
            if IF_DIAGNOSTICS
            temp_rate         = ncread(fileN,'temp_rate') +temp_rate;
            temp_hadv         = ncread(fileN,'temp_hadv') +temp_hadv;
            temp_vadv         = ncread(fileN,'temp_vadv') +temp_vadv;
            temp_hdiff        = ncread(fileN,'temp_hdiff')+temp_hdiff;
            temp_vdiff        = ncread(fileN,'temp_vdiff')+temp_vdiff;
            if IF_SALINITY
            salt_rate         = ncread(fileN,'salt_rate') +salt_rate;
            salt_hadv         = ncread(fileN,'salt_hadv') +salt_hadv;
            salt_vadv         = ncread(fileN,'salt_vadv') +salt_vadv;
            salt_hdiff        = ncread(fileN,'salt_hdiff')+salt_hdiff;
            salt_vdiff        = ncread(fileN,'salt_vdiff')+salt_vdiff;
            end
            if HCM_DIA_OUTPUT
            temp_rhr          = ncread(fileN,'temp_rhr')+temp_rhr;
            temp_shr          = ncread(fileN,'temp_shr')+temp_shr;
            end
            end
        end
    end

    if num>1
        TIME     = TIME/num;
        Z        = Z   /num;
        lon      = lon /num;
        lat      = lat /num;
        % 2D variables
        zeta     = zeta    /num;
        sustr    = sustr   /num;
        svstr    = svstr   /num;
        shflux   = shflux  /num;
        ssflux   = ssflux  /num;
        swrad    = swrad   /num;
        lwrad    = lwrad   /num;
        latent   = latent  /num;
        sensible = sensible/num;
        evap     = evap    /num;
        rain     = rain    /num;
        % 3D variables
        u        = u   /num;
        v        = v   /num;
        w        = w   /num;
        temp     = temp/num;
        salt     = salt/num;
        rho      = rho /num;
        % Budget terms
        if IF_DIAGNOSTICS
        temp_rate  = temp_rate /num;
        temp_hadv  = temp_hadv /num;
        temp_vadv  = temp_vadv /num;
        temp_hdiff = temp_hdiff/num;
        temp_vdiff = temp_vdiff/num;
        if IF_SALINITY
        salt_rate  = salt_rate /num;
        salt_hadv  = salt_hadv /num;
        salt_vadv  = salt_vadv /num;
        salt_hdiff = salt_hdiff/num;
        salt_vdiff = salt_vdiff/num;
        end
        if HCM_DIA_OUTPUT
        temp_rhr   = temp_rhr/num;
        temp_shr   = temp_shr/num;
        end
        end
    else
        disp(['Error time dimention'])
        stop
    end

    % Save data
    fileO = [Save_dir,'/',out_hard,'_',month_num,'.nc'];
    if exist(fileO,'file')
        delete(fileO)
    end
    Lm = size(lon.*lat,1);
    Mm = size(lon.*lat,2);
    Nm = length(Z);
    nccreate(fileO,'time','Dimensions',{'time',1}     ,'Datatype','double')
    nccreate(fileO,'z'   ,'Dimensions',{'Z',Nm}       ,'Datatype','double')
    nccreate(fileO,'lon' ,'Dimensions',{'X',Lm,'Y',Mm},'Datatype','double')
    nccreate(fileO,'lat' ,'Dimensions',{'X',Lm,'Y',Mm},'Datatype','double')

    nccreate(fileO,'zeta'  ,'Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'sustr' ,'Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'svstr' ,'Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'shflux','Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'ssflux','Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'swrad'   ,'Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'lwrad'   ,'Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'latent'  ,'Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'sensible','Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'evap','Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')
    nccreate(fileO,'rain','Dimensions',{'X',Lm,'Y',Mm,'time',1},'Datatype','double')

    nccreate(fileO,'u'   ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'v'   ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'w'   ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'temp','Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'salt','Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'rho' ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')

    if IF_DIAGNOSTICS
    nccreate(fileO,'temp_rate' ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'temp_hadv' ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'temp_vadv' ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'temp_hdiff','Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'temp_vdiff','Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    if IF_SALINITY
    nccreate(fileO,'salt_rate' ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'salt_hadv' ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'salt_vadv' ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'salt_hdiff','Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'salt_vdiff','Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    end
    if HCM_DIA_OUTPUT
    nccreate(fileO,'temp_rhr'  ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    nccreate(fileO,'temp_shr'  ,'Dimensions',{'X',Lm,'Y',Mm,'Z',Nm,'time',1},'Datatype','double')
    end
    end

    ncwrite(fileO,'time',TIME)
    ncwrite(fileO,'z'   ,Z)
    ncwrite(fileO,'lon' ,lon)
    ncwrite(fileO,'lat' ,lat)

    ncwrite(fileO,'zeta'    ,zeta)
    ncwrite(fileO,'sustr'   ,sustr)
    ncwrite(fileO,'svstr'   ,svstr)
    ncwrite(fileO,'shflux'  ,shflux)
    ncwrite(fileO,'ssflux'  ,ssflux)
    ncwrite(fileO,'swrad'   ,swrad)
    ncwrite(fileO,'lwrad'   ,lwrad)
    ncwrite(fileO,'latent'  ,latent)
    ncwrite(fileO,'sensible',sensible)
    ncwrite(fileO,'evap'    ,evap)
    ncwrite(fileO,'rain'    ,rain)

    ncwrite(fileO,'u'   ,u)
    ncwrite(fileO,'v'   ,v)
    ncwrite(fileO,'w'   ,w)
    ncwrite(fileO,'temp',temp)
    ncwrite(fileO,'salt',salt)
    ncwrite(fileO,'rho' ,rho)

    if IF_DIAGNOSTICS
    ncwrite(fileO,'temp_rate' ,temp_rate)
    ncwrite(fileO,'temp_hadv' ,temp_hadv)
    ncwrite(fileO,'temp_vadv' ,temp_vadv)
    ncwrite(fileO,'temp_hdiff',temp_hdiff)
    ncwrite(fileO,'temp_vdiff',temp_vdiff)
    if IF_SALINITY
    ncwrite(fileO,'salt_rate' ,salt_rate)
    ncwrite(fileO,'salt_hadv' ,salt_hadv)
    ncwrite(fileO,'salt_vadv' ,salt_vadv)
    ncwrite(fileO,'salt_hdiff',salt_hdiff)
    ncwrite(fileO,'salt_vdiff',salt_vdiff)
    end
    if HCM_DIA_OUTPUT
    ncwrite(fileO,'temp_rhr'  ,temp_rhr)
    ncwrite(fileO,'temp_shr'  ,temp_shr)
    end
    end

    fileattrib(fileO,'+w');
    ncwriteatt(fileO,'time','long name','Time');
    ncwriteatt(fileO,'time','unit','days since 0000-00-00');
    ncwriteatt(fileO,'z','long name','Depth');
    ncwriteatt(fileO,'z','unit','meter');
    ncwriteatt(fileO,'lon','long name','longitude');
    ncwriteatt(fileO,'lon','unit','degrees east');
    ncwriteatt(fileO,'lat','long name','latitude');
    ncwriteatt(fileO,'lat','unit','degrees north');

    ncwriteatt(fileO,'zeta','long name','time-averaged free-surface');
    ncwriteatt(fileO,'zeta','unit','meter');
    ncwriteatt(fileO,'sustr','long name','time-averaged surface u-momentum stress');
    ncwriteatt(fileO,'sustr','unit','newton meter-2');
    ncwriteatt(fileO,'svstr','long name','time-averaged surface v-momentum stress');
    ncwriteatt(fileO,'svstr','unit','newton meter-2');
    ncwriteatt(fileO,'shflux','long name','time-averaged surface net heat flux');
    ncwriteatt(fileO,'shflux','unit','watt meter-2');
    ncwriteatt(fileO,'ssflux','long name','time-averaged surface net salt flux, (E-P)*SALT');
    ncwriteatt(fileO,'ssflux','unit','meter second-1');
    ncwriteatt(fileO,'ssflux','negative_value','upward flux, freshening (net precipitation)');
    ncwriteatt(fileO,'ssflux','positive_value','downward flux, salting (net evaporation)');
    ncwriteatt(fileO,'swrad','long name','time-averaged solar shortwave radiation flux');
    ncwriteatt(fileO,'swrad','unit','watt meter-2');
    ncwriteatt(fileO,'lwrad','long name','net longwave radiation flux');
    ncwriteatt(fileO,'lwrad','unit','watt meter-2');
    ncwriteatt(fileO,'latent','long name','latent heat flux');
    ncwriteatt(fileO,'latent','unit','watt meter-2');
    ncwriteatt(fileO,'sensible','long name','sensible heat flux');
    ncwriteatt(fileO,'sensible','unit','watt meter-2');
    ncwriteatt(fileO,'evap','long name','evaporation rate');
    ncwriteatt(fileO,'evap','unit','kilogram meter-2 second-1');
    ncwriteatt(fileO,'rain','long name','rain fall rate');
    ncwriteatt(fileO,'rain','unit','kilogram meter-2 second-1');

    ncwriteatt(fileO,'u','long name','time-averaged eastward momentum component');
    ncwriteatt(fileO,'u','unit','meter second-1');
    ncwriteatt(fileO,'v','long name','time-averaged northward momentum component');
    ncwriteatt(fileO,'v','unit','meter second-1');
    ncwriteatt(fileO,'w','long name','time-averaged vertical momentum component');
    ncwriteatt(fileO,'w','unit','meter second-1');
    ncwriteatt(fileO,'temp','long name','time-averaged potential temperature');
    ncwriteatt(fileO,'temp','unit','Celsius');
    ncwriteatt(fileO,'salt','long name','time-averaged salinity');
    ncwriteatt(fileO,'rho','long name','time-averaged density anomaly');
    ncwriteatt(fileO,'rho','unit','kilogram meter-3');

    if IF_DIAGNOSTICS
    ncwriteatt(fileO,'temp_rate','long name','time-averaged potential temperature, time rate of change');
    ncwriteatt(fileO,'temp_rate','unit','Celsius second-1');
    ncwriteatt(fileO,'temp_hadv','long name','time-averaged potential temperature, horizontal advection term');
    ncwriteatt(fileO,'temp_hadv','unit','Celsius second-1');
    ncwriteatt(fileO,'temp_vadv','long name','time-averaged potential temperature, vertical advection term');
    ncwriteatt(fileO,'temp_vadv','unit','Celsius second-1');
    ncwriteatt(fileO,'temp_hdiff','long name','time-averaged potential temperature, horizontal diffusion term');
    ncwriteatt(fileO,'temp_hdiff','unit','Celsius second-1');
    ncwriteatt(fileO,'temp_vdiff','long name','time-averaged potential temperature, vertical diffusion term');
    ncwriteatt(fileO,'temp_vdiff','unit','Celsius second-1');
    if IF_SALINITY
    ncwriteatt(fileO,'salt_rate','long name','time-averaged salinity, time rate of change');
    ncwriteatt(fileO,'salt_rate','unit','nondimensional second-1');
    ncwriteatt(fileO,'salt_hadv','long name','time-averaged salinity, horizontal advection term');
    ncwriteatt(fileO,'salt_hadv','unit','nondimensional second-1');
    ncwriteatt(fileO,'salt_vadv','long name','time-averaged salinity, vertical advection term');
    ncwriteatt(fileO,'salt_vadv','unit','nondimensional second-1');
    ncwriteatt(fileO,'salt_hdiff','long name','time-averaged salinity, horizontal diffusion term');
    ncwriteatt(fileO,'salt_hdiff','unit','nondimensional second-1');
    ncwriteatt(fileO,'salt_vdiff','long name','time-averaged salinity, vertical diffusion term');
    ncwriteatt(fileO,'salt_vdiff','unit','nondimensional second-1');
    end
    if HCM_DIA_OUTPUT
    ncwriteatt(fileO,'temp_rhr','long name','time-averaged radation heating rate');
    ncwriteatt(fileO,'temp_rhr','unit','Celsius second-1');
    ncwriteatt(fileO,'temp_shr','long name','time-averaged surface flux heating rate');
    ncwriteatt(fileO,'temp_shr','unit','Celsius second-1');
    end
    end

    disp(['Output File: ',fileO]);
    ncwriteatt(fileO,'/','creation_date',datestr(now));

    % Clear data
    clear TIME Z lon lat
    clear zeta sustr svstr shflux ssflux 
    clear swrad lwrad latent sensible evap rain
    clear u v w temp salt rho
    clear temp_* salt_*

end

