function [varZ,varT,varS,varU,varV,Ubar,Vbar] = get_roms_bry_value_clim(zeta,H,depth,dep,temp,salt,u,v,...
                                                   theta_s,theta_b,hc,layer_N,type,vtransform,zeta0)    
varZ = zeta;
% depth= depth+zeta0;
H    = H+zeta0;
          
for loc = 1:length(varZ)
    HH = H(loc);    
    ZZ = varZ(loc);   
    if isnan(ZZ)   
        ZZ = 0;        
    end    
    D    = -zlevs(HH,ZZ,theta_s,theta_b,hc,layer_N,type,vtransform);    
    varT(:,loc) = interp1(depth,temp(:,loc),D);    
    varS(:,loc) = interp1(depth,salt(:,loc),D);
    varT(find(D<min(depth)),loc) = temp(1,loc);
    varS(find(D<min(depth)),loc) = salt(1,loc);
end
varT = remove_misvalue(varT);
varS = remove_misvalue(varS);

for loc = 1:size(u,2)
    if length(varZ)==size(u,2)   
        HH = H(loc);        
        ZZ = varZ(loc);       
    else       
        HH = (H(loc)+H(loc+1))/2;        
        ZZ = (varZ(loc)+varZ(loc+1))/2;        
    end    
    if isnan(ZZ)    
        ZZ = 0;       
    end    
    D    = -zlevs(HH,ZZ,theta_s,theta_b,hc,layer_N,type,vtransform);
    varU(:,loc) = interp1(depth,u(:,loc),D);
    varU(find(D<min(depth)),loc) = u(1,loc);
    uu   = varU(:,loc);
    uu(isnan(uu)) = 0;
    vv   = (uu(2:end)+uu(1:end-1))/2;
    dd   = D(1:end-1) - D(2:end);
    Ubar(loc) = nansum(vv.*dd)/nansum(dd);
end
varU = remove_misvalue(varU);

for loc = 1:size(v,2)
    if length(varZ)==size(v,2)
        HH = H(loc);
        ZZ = varZ(loc);
    else    
        HH = (H(loc)+H(loc+1))/2;
        ZZ = (varZ(loc)+varZ(loc+1))/2;
    end
    if isnan(ZZ)  
        ZZ = 0;  
    end 
    D    = -zlevs(HH,ZZ,theta_s,theta_b,hc,layer_N,type,vtransform); 
    varV(:,loc) = interp1(depth,v(:,loc),D);
    varV(find(D<min(depth)),loc) = v(1,loc);
    uu   = varV(:,loc);
    uu(isnan(uu)) = 0;
    vv   = (uu(2:end)+uu(1:end-1))/2;
    dd   = D(1:end-1) - D(2:end);
    Vbar(loc) = nansum(vv.*dd)/nansum(dd);
end
varV = remove_misvalue(varV);

Ubar(isnan(Ubar)) = 0;
Vbar(isnan(Vbar)) = 0;
