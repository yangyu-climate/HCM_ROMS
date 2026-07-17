%%%%%%%%%%%%%%%%%%%%% USERS DEFINED VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%
Riv_parameter

River_dir = [pwd,'/River'];
[DD,TT,NN]= xlsread([River_dir ,'/River_estuary.xlsx']);
location  = xlsread([River_dir ,'/River_location.xlsx']);
discharge = xlsread([River_dir ,'/River_discharge.xlsx']);

C_Xposition=location(3,:);
C_Eposition=location(4,:);
C_direction=location(5,:); % 0: west-east direction 1: south-north direction
C_rivercase=location(6,:); % 1: west to east .or. south to north   direction
                           % 2: east to west .or. north to south   direction                           
number     =length(C_direction);
X          = C_Xposition+1;
Y          = C_Eposition+1;
C_transport=discharge(3:14,:);
clear location discharge

C_Vshape(1:layer_N,1:number)=1/layer_N;

nc=netcdf(clmname);
TEMP = nc{'temp'}(:);
result=close(nc);
for river_num = 1:number
    C_temp(:,:,river_num) = squeeze(...
        TEMP(:,:,C_Eposition(river_num)+1,C_Xposition(river_num)+1)...
        );
end
clear TEMP

C_salt(1:12,1:layer_N,1:number)=0;
C_flag(1:number)=3;

for river_num = 1:number
    Direction = C_direction(river_num);
    Rivercase = C_rivercase(river_num);
    Xposition = C_Xposition(river_num);
    Eposition = C_Eposition(river_num);
    Transport = C_transport(:,river_num);
    if Direction==0&&Rivercase==2
        Xposition =  Xposition+1;
        Transport = -Transport;
    elseif Direction==1&&Rivercase==2
        Eposition =  Eposition+1; 
        Transport = -Transport;
    end
    C_Xposition(river_num)   = Xposition;
    C_Eposition(river_num)   = Eposition;
    C_transport(:,river_num) = Transport;
end

save([pwd,'/river.mat'],'number',...
    'C_Xposition','C_Eposition',...
    'C_direction','C_transport',...
    'C_Vshape','C_temp','C_salt','C_flag')

[lat,lon,mask]=read_latlonmask(grdname,'r');

RIV = TT;
for river_num = 1:number
    lon_loc   = X(river_num);
    lat_loc   = Y(river_num);
    x         = lon(lat_loc,lon_loc);
    y         = lat(lat_loc,lon_loc);
    RIV{1,river_num+1} = river_num;
    RIV{3,river_num+1} = x;
    RIV{4,river_num+1} = y;
end
xlswrite([River_dir,'/River_estuary.xlsx']  ,RIV)


% plot
[L,M] = size(mask);
lonmin=min(lon(:));
lonmax=max(lon(:));
latmin=min(lat(:));
latmax=max(lat(:));
disp(' ')
disp(['Second guess:'])
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
  
 
  for river_num=1:number
    Direction = C_direction(river_num);
    Rivercase = C_rivercase(river_num);
    lon_loc   = X(river_num);
    lat_loc   = Y(river_num);
    x         = lon(lat_loc,lon_loc);
    y         = lat(lat_loc,lon_loc);
    if     Direction==0&&Rivercase==1
        x_line = [x  ,x+1];
        y_line = [y  ,y  ];
    elseif Direction==0&&Rivercase==2
        x_line = [x  ,x-1];
        y_line = [y  ,y  ];
    elseif Direction==1&&Rivercase==1
        x_line = [x  ,x  ];
        y_line = [y  ,y+1];    
    elseif Direction==1&&Rivercase==2
        x_line = [x  ,x  ];
        y_line = [y  ,y-1];  
    end
    h1=m_plot(x_line,y_line,'r');
    h2=m_plot(x,y,'r.');
%     set(h1,'Clipping','off')
%     legend(h1,'first guess position');
  end
end

mkdir([pwd,'/River/Fig'])
fig_file = [pwd,'/River/Fig/second_guess_position.pdf'];
saveas(gcf,fig_file)
close all






