%%%%%%%%%%%%%%%%%%%%% USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%
Riv_parameter

disp(' ')
disp(['Create runoff forcing from Dai and Trenberth''s global monthly climatological run-off dataset'])
disp(' ')
title_name='runoff forcing file (Dai and Trenberth, 2002 dataset)';
%%%%%%%%%%%%%%%%% END USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%
[latriv,lonriv,my_flow,myrivername,rivernumber]=runoff_glob_extract(grdname,global_clim_rivername);

[lat,lon,mask]=read_latlonmask(grdname,'r');
[L,M] = size(mask);
for k= 1:rivernumber
  indomain(k)=1;
  [j,i]=runoff_grid_pos(lon,lat,lonriv(k),latriv(k));
  if length(i.*j)>1
      i = min(i);
      j = min(j);
  end
  J    = j-1;
  I    = i-1;
  LL(k) = i;
  MM(k) = j;
  if I<bound_lim||I>M-bound_lim||J<bound_lim||J>L-bound_lim
      indomain(k)=0;
  end
end

RIV{1,1}    = 'Number';
RIV{2,1}    = 'Name';
RIV{3,1}    = 'Longitude';
RIV{4,1}    = 'Latitude';

LOC{1,1}    = 'Number';
LOC{2,1}    = 'Name';
LOC{3,1}    = 'L';
LOC{4,1}    = 'M';
LOC{5,1}    = 'Direction';
LOC{6,1}    = 'RiverCase';

DIS{1,1}    = 'Number';
DIS{2,1}    = 'Name';
DIS{2+1,1}  = 'January';
DIS{2+2,1}  = 'February';
DIS{2+3,1}  = 'March';
DIS{2+4,1}  = 'April';
DIS{2+5,1}  = 'May';
DIS{2+6,1}  = 'June';
DIS{2+7,1}  = 'July';
DIS{2+8,1}  = 'August';
DIS{2+9,1}  = 'September';
DIS{2+10,1} = 'October';
DIS{2+11,1} = 'November';
DIS{2+12,1} = 'December';


NUM = 0;
for N = 1:rivernumber
    if indomain(N)==1
        NUM            = NUM+1;
        disp(['- Process river #',num2str(NUM),': ',char(myrivername(N,:))])
        RIV{1,NUM+1}   = NUM;
        RIV{2,NUM+1}   = myrivername(N,:);
        RIV{3,NUM+1}   = lonriv(N);
        RIV{4,NUM+1}   = latriv(N);
        X(NUM)         = lonriv(N);
        Y(NUM)         = latriv(N);
        LOC{1,NUM+1}   = NUM;
        LOC{2,NUM+1}   = myrivername(N,:);
        LOC{3,NUM+1}   = LL(N);
        LOC{4,NUM+1}   = MM(N);
        LOC{5,NUM+1}   = 0;
        LOC{6,NUM+1}   = 1;
        DIS{1,NUM+1}   = NUM;
        DIS{2,NUM+1}   = myrivername(N,:);
        for M =1:12
        DIS{2+M,NUM+1} = my_flow(M,N);
        end
    end
end
S_dir = [pwd,'/River'];
mkdir(S_dir)
xlswrite([S_dir,'/River_estuary.xlsx']  ,RIV)
xlswrite([S_dir,'/River_location.xlsx'] ,LOC)
xlswrite([S_dir,'/River_discharge.xlsx'],DIS)

% plot
lonmin=min(lon(:));
lonmax=max(lon(:));
latmin=min(lat(:));
latmax=max(lat(:));
disp(' ')
disp(['First guess:'])
disp(['============'])
plotting = 1;
if plotting==1
  figure
  m_proj('mercator',...
       'lon',[lonmin lonmax],...
       'lat',[latmin latmax]);
  m_pcolor(lon,lat,mask)
  m_grid('linestyle','none','box','fancy','xtick',5,'ytick',5,'tickdir','in');
  set(findobj('tag','m_grid_color'),'facecolor','white');
  hold on
  for k0=1:NUM
    lon_src=X(k0);
    lat_src=Y(k0);
    [px,py]=m_ll2xy(lon_src,lat_src);
    h1=plot(px,py,'r.');
    set(h1,'Clipping','off')
%     legend(h1,'first guess position');
  end
end

mkdir([pwd,'/River/Fig'])
fig_file = [pwd,'/River/Fig/first_guess_position.pdf'];
saveas(gcf,fig_file)
close all









