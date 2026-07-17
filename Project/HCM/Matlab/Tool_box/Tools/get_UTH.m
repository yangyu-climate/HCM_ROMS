function UTH = get_UTH(z,w)
z    = z/1000;
loc1 = find(z<=5 &z>=1);
loc2 = find(z<=14&z>=1);
if nanmean(w(loc1))>0&&nanmax(w(loc1))>1              
  loc  = find(w>=0.5);
  UTH  = nanmax(z(loc));
  if UTH>3
    loc = find(z>=3&z<=UTH);
    if min(w(loc))<=0
       UTH = NaN;
    end
  end
else
  UTH  = NaN;
end
