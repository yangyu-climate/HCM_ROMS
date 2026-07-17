clear
clc

Run_dir = ['../../'];
addpath(Run_dir)
start
% warning off

SODA_parameter


H_file      = 'SODA';
G_file      = [Run_dir,'Data/Grd.nc'];
S_file      = 'Ini'; 
clobber     = 'write';      
vtransform  = 2;
type        = 'r';

Data_dir    = [pwd,'/Data'];
Save_dir    = [pwd,'/Result'];
mkdir(Save_dir)

grd_file    = G_file;
h           = ncload_2D(grd_file,'h');
lonr        = ncload_2D(grd_file,'lon_rho');
latr        = ncload_2D(grd_file,'lat_rho');
lonu        = ncload_2D(grd_file,'lon_u');
latu        = ncload_2D(grd_file,'lat_u');
lonv        = ncload_2D(grd_file,'lon_v');
latv        = ncload_2D(grd_file,'lat_v');
maskr       = ncload_2D(grd_file,'mask_rho');

maskr(h+zeta0<hc)=0;
[masku,maskv,maskp]=uvp_mask(maskr);
h(h+zeta0<hc)=hc-zeta0;
h=smoothgrid(h,maskr,hmin-zeta0,hmax,hmax,...
             rtarget,n_filter_deep_topo,n_filter_final);

grd_new = [Save_dir,'/Grd.nc'];
copyfile(grd_file,grd_new)
nc=netcdf(grd_new,'write');
nc{'h'}(:)=h;
nc{'mask_u'}(:)=masku;
nc{'mask_v'}(:)=maskv;
nc{'mask_psi'}(:)=maskp;
nc{'mask_rho'}(:)=maskr;
close(nc);

tini    = 0;
ininame = [Save_dir,'/',S_file,'.nc'];
grdname = G_file;
delete(ininame)
create_inifile(ininame,grdname,title,...
               theta_s,theta_b,hc,layer_N,...
               tini,clobber,vtransform)

T_num = ['01'];         
S_num = ['01'];

T_file    = S_num;          
file_name = [H_file,'*',T_file,'*'];             
filename  = dir([Data_dir,'/',file_name]);
 
if ~isempty(filename)     
    disp(T_num)
    file_name = filename.name;
    fileN = [Data_dir,'/',file_name];           
    disp(['Load data from: ',fileN])
    depth = ncload_0D(fileN,'depth');
    
    depth= depth+zeta0;
    h    = h+zeta0;

    dep   = [0;depth];    
    dep   = dep(2:end)-dep(1:end-1); 
    
    nc    = netcdf(fileN);  
    zeta  = squeeze(nc{'ssh'}(:));
    TEMP  = squeeze(nc{'temp'}(:));
    SALT  = squeeze(nc{'salt'}(:));
    U     = squeeze(nc{'u'}(:));
    V     = squeeze(nc{'v'}(:));
    close(nc)
    
    Z_U   = interp2(lonr,latr,zeta,lonu,latu);
    Z_V   = interp2(lonr,latr,zeta,lonv,latv);
    H_U   = interp2(lonr,latr,h   ,lonu,latu);
    H_V   = interp2(lonr,latr,h   ,lonv,latv);
    
    % Temp & Salt
    for i=1:size(zeta,1)
        for j=1:size(zeta,2)
            HH   = h(i,j);
            ZZ   = zeta(i,j);
            D    = -zlevs(HH,ZZ,theta_s,theta_b,hc,layer_N,type,vtransform);
            varT = interp1(depth,squeeze(TEMP(:,i,j)),D);
            varS = interp1(depth,squeeze(SALT(:,i,j)),D);
            varT(D<min(dep)) = TEMP(1,i,j);
            varS(D<min(dep)) = SALT(1,i,j);
            locT = find(~isnan(varT));
            locS = find(~isnan(varS));
            if ~isempty(locT)&&~isempty(locS)
            varT(isnan(varT)&D>5) = varT(min(locT));
            varS(isnan(varS)&D>5) = varS(min(locS));
            end
            temp(:,i,j) = varT;
            salt(:,i,j) = varS;  
        end
    end
    temp(isnan(temp)) = 14;
    salt(isnan(salt)) = 35;
    
    % U & Ubar
    for i=1:size(Z_U,1)
        for j=1:size(Z_U,2)
            HH   = H_U(i,j);
            ZZ   = Z_U(i,j);
            D    = -zlevs(HH,ZZ,theta_s,theta_b,hc,layer_N,type,vtransform);
            varU = interp1(depth,squeeze(U(:,i,j)),D);
            varU(D<min(dep)) = U(1,i,j);
            u(:,i,j)  = varU;
            ubar(i,j) = trapz(D,squeeze(u(:,i,j)))...
                      / trapz(D,ones(size(D)));
        end
    end
    u(isnan(u))       = 0;
    ubar(isnan(ubar)) = 0;
        
    % V & Vbar
    for i=1:size(Z_V,1)
        for j=1:size(Z_V,2)
            HH   = H_V(i,j);
            ZZ   = Z_V(i,j);
            D    = -zlevs(HH,ZZ,theta_s,theta_b,hc,layer_N,type,vtransform);
            varV = interp1(depth,squeeze(V(:,i,j)),D);
            varV(D<min(dep)) = V(1,i,j);
            v(:,i,j)  = varV;
            vbar(i,j) = trapz(D,squeeze(v(:,i,j)))...
                      / trapz(D,ones(size(D)));
        end
    end
    v(isnan(v))       = 0;
    vbar(isnan(vbar)) = 0;
    
    % Save data
    nc  = netcdf(ininame,'write');
    disp('Writes into Ini file ...')
    nc{'zeta'}(:) = squeeze(zeta)+zeta0;
    nc{'ubar'}(:) = squeeze(ubar);
    nc{'vbar'}(:) = squeeze(vbar);
    nc{'temp'}(:) = squeeze(temp);
    nc{'salt'}(:) = squeeze(salt);
    nc{'u'}(:)    = squeeze(u);
    nc{'v'}(:)    = squeeze(v);
    close(nc)
end

           
           
           
