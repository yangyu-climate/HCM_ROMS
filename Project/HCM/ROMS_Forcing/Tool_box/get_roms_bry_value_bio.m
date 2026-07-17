function [varT] = get_roms_bry_value_bio(zeta,H,depth,dep,Trac,...
                                        theta_s,theta_b,hc,layer_N,type,vtransform)    
varZ = zeta;
          
for loc = 1:length(varZ)
    HH = H(loc);    
    ZZ = varZ(loc);   
    if isnan(ZZ)   
        ZZ = 0;        
    end    
    D    = -zlevs(HH,ZZ,theta_s,theta_b,hc,layer_N,type,vtransform);    
    varT(:,loc) = interp1(depth,Trac(:,loc),D);    
    varT(find(D<min(depth)),loc) = Trac(1,loc);
end
varT = remove_misvalue(varT);
