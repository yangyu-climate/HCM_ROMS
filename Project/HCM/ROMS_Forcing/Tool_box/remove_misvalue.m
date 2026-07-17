function VAR = remove_misvalue(VAR)
            
NN = 0;
while sum(sum(isnan(VAR)))>0&&NN<10
    NN       = NN + 1;
    VAR_S    = running_mean(VAR);
    loc      = find(isnan(VAR));
    VAR(loc) = VAR_S(loc);    
end

loc      = find(isnan(VAR));    
VAR(loc) = nanmean(nanmean(VAR)); 
loc      = find(isnan(VAR));    
VAR(loc) = 0; 
