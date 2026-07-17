clear
clc

Run_dir = ['../'];
addpath(Run_dir);
start
warning off
%----------------------------------------------------------------
IF_DIAGNOSTICS = 1;
IF_CORRECTION  = 1;
IF_SALINITY    = 1;
HCM_DIA_OUTPUT = 1;

INTERP_METHOD = 'linear';

Data_dir = ['/public/home/yuyang/Clark/application/HCM/Result/original/OCM/EXP_FWF/ALPHA_TAU1.5_FWF1.0'];

Y_limit  = 30;
M_limit  = [1:12*Y_limit];
Z_limit  = [0:1:50 52:2:100 105:5:300 310:10:500 550:50:5000];

AVG_hard = 'avg';
DIA_hard = 'dia';
OUT_hard = 'DIA';

Save_dir = [pwd,'/Result'];
if ~exist(Save_dir,'dir')
    mkdir(Save_dir)
end

for M = 1:length(M_limit)
    year     = ceil(M_limit(M)/12);
    month    = mod(M_limit(M),12);
    if month==0
        month=12;
    end
    if year<10
      year_num = ['000',num2str(year)];
    elseif year<100
      year_num = ['00',num2str(year)];
    elseif year<1000
      year_num = ['0',num2str(year)];
    else
      year_num = [num2str(year)];
    end
    if month<10
      month_num = ['0',num2str(month)];
    else
      month_num = [num2str(month)];
    end
    T_name = [year_num,'-',month_num];
    disp([' '])
    disp(['Date: ',T_name])
    TIME = datenum([year,month,1]);  

    NUM = M_limit(M);
    if NUM<10
      num = ['0000',num2str(NUM)];
    elseif NUM<100
      num = ['000',num2str(NUM)];
    elseif NUM<1000
      num = ['00',num2str(NUM)];
    elseif NUM<10000
      num = ['0',num2str(NUM)];
    elseif NUM<100000
      num = [num2str(NUM)];
    end
    fileN = [Data_dir,'/',AVG_hard,'_',num,'.nc'];
    disp(['File: ',fileN]);
    lon   = ncread(fileN,'lon_rho');
    lat   = ncread(fileN,'lat_rho');
    lonU  = ncread(fileN,'lon_u');
    latU  = ncread(fileN,'lat_u');
    lonV  = ncread(fileN,'lon_v');
    latV  = ncread(fileN,'lat_v');
    zeta  = ncread(fileN,'zeta');
    h     = ncread(fileN,'h');
    pm    = ncread(fileN,'pm');
    pn    = ncread(fileN,'pn');
    mask  = ncread(fileN,'mask_rho');
    mask(find(mask==0))=NaN;
    % coordinate parameters
    Vtransform = ncread(fileN,'Vtransform');
    theta_s    = ncread(fileN,'theta_s');
    theta_b    = ncread(fileN,'theta_b');
    hc         = ncread(fileN,'hc');
    layer_N    = length(ncread(fileN,'s_rho'));
    layer_type = 'r';
    % 2D variables
    sustr    = ncread(fileN,'sustr'); 
    sustr    = griddata(lonU,latU,sustr,lon,lat);
    svstr    = ncread(fileN,'svstr');
    svstr    = griddata(lonV,latV,svstr,lon,lat);
    shflux   = ncread(fileN,'shflux');
    ssflux   = ncread(fileN,'ssflux');
    swrad    = ncread(fileN,'swrad');
    lwrad    = ncread(fileN,'lwrad');
    latent   = ncread(fileN,'latent');
    sensible = ncread(fileN,'sensible');
    evap     = ncread(fileN,'evaporation');
    rain     = ncread(fileN,'rain');
    % 3D variables
    u    = ncread(fileN,'u_eastward');
    v    = ncread(fileN,'v_northward');
    w    = ncread(fileN,'w');
    w    = (w(:,:,1:end-1) + w(:,:,2:end))/2;
    temp = ncread(fileN,'temp');
    salt = ncread(fileN,'salt');
    rho  = ncread(fileN,'rho');
    if IF_DIAGNOSTICS
        fileN = [Data_dir,'/',DIA_hard,'_',num,'.nc'];
        disp(['File: ',fileN]);
        temp_rate  = ncread(fileN,'temp_rate');
        temp_hadv  = ncread(fileN,'temp_hadv');
        temp_vadv  = ncread(fileN,'temp_vadv');
        temp_hdiff = ncread(fileN,'temp_hdiff');
        temp_vdiff = ncread(fileN,'temp_vdiff');
        if IF_SALINITY
        salt_rate  = ncread(fileN,'salt_rate');
        salt_hadv  = ncread(fileN,'salt_hadv');
        salt_vadv  = ncread(fileN,'salt_vadv');
        salt_hdiff = ncread(fileN,'salt_hdiff');
        salt_vdiff = ncread(fileN,'salt_vdiff');
        end
        if HCM_DIA_OUTPUT
        fileN = [Data_dir,'/',AVG_hard,'_',num,'.nc'];
        temp_rhr   = ncread(fileN,'temp_rhr');
        temp_shr   = ncread(fileN,'temp_shr');
        temp_vdiff = temp_vdiff-temp_rhr-temp_shr;
        end
        if IF_CORRECTION
            Tadv = temp_hadv+temp_vadv;
            if IF_SALINITY
            Sadv = salt_hadv+salt_vadv;
            end
            for k=1:layer_N
                DX   = 1./pm;
                DY   = 1./pn;
                TEMP = squeeze(temp(:,:,k));
                SALT = squeeze(salt(:,:,k));
                VAR     = TEMP;
                [Fx,Fy] = gradient(VAR');
                Tx(:,:,k) = Fx'./DX;
                Ty(:,:,k) = Fy'./DY;
                if IF_SALINITY
                VAR     = SALT;
                [Fx,Fy] = gradient(VAR');
                Sx(:,:,k) = Fx'./DX;
                Sy(:,:,k) = Fy'./DY;
                end
            end
            for i=1:size(mask,1)
            for j=1:size(mask,2)
            if mask(i,j)==1
                z  = zlevs(h(i,j),zeta(i,j),theta_s,theta_b,hc,layer_N,'w',Vtransform);
                DZ = diff(z);
                TEMP = squeeze(temp(i,j,:));
                SALT = squeeze(salt(i,j,:));
                VAR       = TEMP;
                Tz(i,j,:) = gradient(VAR)./DZ;
                if IF_SALINITY
                VAR       = SALT;
                Sz(i,j,:) = gradient(VAR)./DZ;
                end
            else
                Tz(i,j,1:layer_N) = NaN;
                if IF_SALINITY
                Sz(i,j,1:layer_N) = NaN;
                end
            end
            end
            end
            Tx = u.*Tx;
            Ty = v.*Ty;
            Tz = w.*Tz;
            Ttotal = Tx+Ty+Tz;
            Tratio = Tadv./Ttotal;
            temp_hadv = Tratio.*(Tx+Ty);
            temp_vadv = Tratio.*Tz;
            Ttotal = temp_hadv+temp_vadv;
            Tdiff  = Tadv-Ttotal;
            locH   = find(abs(temp_hadv)>abs(temp_vadv));
            locV   = find(abs(temp_hadv)<abs(temp_vadv));
            locE   = find(abs(temp_hadv)==abs(temp_vadv));
            temp_hadv(locH) = temp_hadv(locH)+Tdiff(locH);
            temp_vadv(locV) = temp_vadv(locV)+Tdiff(locV);
            temp_hadv(locE) = temp_hadv(locE)+Tdiff(locE)/2;
            temp_vadv(locE) = temp_vadv(locE)+Tdiff(locE)/2;
            clear Tx Ty Tz
            if IF_SALINITY
            Sx = u.*Sx;
            Sy = v.*Sy;
            Sz = w.*Sz;
            Stotal = Sx+Sy+Sz;
            Sratio = Sadv./Stotal;
            salt_hadv = Sratio.*(Sx+Sy);
            salt_vadv = Sratio.*Sz;
            Stotal = salt_hadv+salt_vadv;
            Sdiff  = Sadv-Stotal;
            locH   = find(abs(salt_hadv)>abs(salt_vadv));
            locV   = find(abs(salt_hadv)<abs(salt_vadv));
            locE   = find(abs(salt_hadv)==abs(salt_vadv));
            salt_hadv(locH) = salt_hadv(locH)+Sdiff(locH);
            salt_vadv(locV) = salt_vadv(locV)+Sdiff(locV);
            salt_hadv(locE) = salt_hadv(locE)+Sdiff(locE)/2;
            salt_vadv(locE) = salt_vadv(locE)+Sdiff(locE)/2;
            end
        end
	if IF_CORRECTION
            Trate = temp_hadv+temp_vadv+temp_hdiff+temp_vdiff;
          if IF_SALINITY
            Srate = salt_hadv+salt_vadv+salt_hdiff+salt_vdiff;
          end
          if HCM_DIA_OUTPUT
            Trate = Trate+temp_rhr+temp_shr;
          end
            maskT = squeeze(nanmean(Trate,3));
            maskT(find(~isnan(maskT)))=1;
            maskT(find( isnan(maskT)))=0;
            mask  = mask.*maskT;
          if IF_SALINITY
            maskS = squeeze(nanmean(Srate,3));
            maskS(find(~isnan(maskS)))=1;
            maskS(find( isnan(maskS)))=0;
            mask  = mask.*maskS;
          end
        end
    end
    Z = Z_limit;
    % vertical interplation
    for i=1:size(mask,1)
        for j=1:size(mask,2)
            if mask(i,j)==1
                z = zlevs(h(i,j),zeta(i,j),theta_s,theta_b,hc,layer_N,layer_type,Vtransform);
                z = z-max(z);
                U(i,j,:) = interp1(z,   squeeze(u(i,j,:)),-Z,INTERP_METHOD);
                V(i,j,:) = interp1(z,   squeeze(v(i,j,:)),-Z,INTERP_METHOD);
                W(i,j,:) = interp1(z,   squeeze(w(i,j,:)),-Z,INTERP_METHOD);
                T(i,j,:) = interp1(z,squeeze(temp(i,j,:)),-Z,INTERP_METHOD);
                S(i,j,:) = interp1(z,squeeze(salt(i,j,:)),-Z,INTERP_METHOD);
                R(i,j,:) = interp1(z, squeeze(rho(i,j,:)),-Z,INTERP_METHOD);
                if IF_DIAGNOSTICS
                    TRR(i,j,:) = interp1(z,squeeze( temp_rate(i,j,:)),-Z,INTERP_METHOD);
                    THA(i,j,:) = interp1(z,squeeze( temp_hadv(i,j,:)),-Z,INTERP_METHOD);
                    TVA(i,j,:) = interp1(z,squeeze( temp_vadv(i,j,:)),-Z,INTERP_METHOD);
                    THD(i,j,:) = interp1(z,squeeze(temp_hdiff(i,j,:)),-Z,INTERP_METHOD);
                    TVD(i,j,:) = interp1(z,squeeze(temp_vdiff(i,j,:)),-Z,INTERP_METHOD);
                    if IF_SALINITY
                    SRR(i,j,:) = interp1(z,squeeze( salt_rate(i,j,:)),-Z,INTERP_METHOD);
                    SHA(i,j,:) = interp1(z,squeeze( salt_hadv(i,j,:)),-Z,INTERP_METHOD);
                    SVA(i,j,:) = interp1(z,squeeze( salt_vadv(i,j,:)),-Z,INTERP_METHOD);
                    SHD(i,j,:) = interp1(z,squeeze(salt_hdiff(i,j,:)),-Z,INTERP_METHOD);
                    SVD(i,j,:) = interp1(z,squeeze(salt_vdiff(i,j,:)),-Z,INTERP_METHOD);
                    end
                    if HCM_DIA_OUTPUT
                    RHR(i,j,:) = interp1(z,squeeze(  temp_rhr(i,j,:)),-Z,INTERP_METHOD);
                    SHR(i,j,:) = interp1(z,squeeze(  temp_shr(i,j,:)),-Z,INTERP_METHOD);
                    end
                end
            else
                U(i,j,1:length(Z))=NaN;
                V(i,j,1:length(Z))=NaN;
                W(i,j,1:length(Z))=NaN;
                T(i,j,1:length(Z))=NaN;
                S(i,j,1:length(Z))=NaN;
                R(i,j,1:length(Z))=NaN;
                if IF_DIAGNOSTICS
                    TRR(i,j,1:length(Z))=NaN;
                    THA(i,j,1:length(Z))=NaN;
                    TVA(i,j,1:length(Z))=NaN;
                    THD(i,j,1:length(Z))=NaN;
                    TVD(i,j,1:length(Z))=NaN;
                    if IF_SALINITY
                    SRR(i,j,1:length(Z))=NaN;
                    SHA(i,j,1:length(Z))=NaN;
                    SVA(i,j,1:length(Z))=NaN;
                    SHD(i,j,1:length(Z))=NaN;
                    SVD(i,j,1:length(Z))=NaN;
                    end
                    if HCM_DIA_OUTPUT
                    RHR(i,j,1:length(Z))=NaN;
                    SHR(i,j,1:length(Z))=NaN;
                    end
                end
            end
        end
    end
    u    = U;
    v    = V;
    w    = W;
    temp = T;
    salt = S;
    rho  = R;
    clear U V T S R
    if IF_DIAGNOSTICS
        temp_rate  = TRR;
        temp_hadv  = THA;
        temp_vadv  = TVA;
        temp_hdiff = THD;
        temp_vdiff = TVD;
        clear TRR THA TVA THD TVD
        if IF_SALINITY
        salt_rate  = SRR;
        salt_hadv  = SHA;
        salt_vadv  = SVA;
        salt_hdiff = SHD;
        salt_vdiff = SVD;
        clear SRR SHA SVA SHD SVD
        end
        if HCM_DIA_OUTPUT
        temp_rhr   = RHR;
        temp_shr   = SHR;
        clear RHR SHR
        end
    end

    % Save data
    fileO = [Save_dir,'/',OUT_hard,'_',T_name,'.nc'];
    if exist(fileO,'file')
        delete(fileO)
    end
    Lm = size(mask,1);
    Mm = size(mask,2);
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

end
