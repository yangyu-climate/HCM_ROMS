close all

disp(' ')
disp([' Parent grid: ',Grid_file])

nc=netcdf(Grid_file);
lon_rho=nc{'lon_rho'}(:);
lat_rho=nc{'lat_rho'}(:);
h_rho  =nc{'h'}(:);
mask   =nc{'mask_rho'}(:);
mask(find(mask==0)) = NaN;
result=close(nc);
Gnames={Grid_file};

for i = 1:max_dom-1
    parent_name = cell2mat(Gnames(parent_id(i+1)));
    child_grid  = [Grid_file(1:end-3),'_nest',num2str(i),'.nc'];
    F  = coarse2fine(parent_name,child_grid, ...
         grid_ratio(i+1),Istr(i+1),Iend(i+1),Jstr(i+1),Jend(i+1));

    x  = ncload_2D(child_grid,'lon_rho');
    y  = ncload_2D(child_grid,'lat_rho');
    hs = ncload_2D(child_grid,'h');
    
    % Create the grid file
    disp(' ')
    disp(' Check Grid Size...')
    [M,L]=size(x);
    disp([' LLm = ',num2str(L-1)])
    disp([' MMm = ',num2str(M-1)])    
    
    h  = add_topo(child_grid,Topo_file,Topo_lon,Topo_lat,Topo_var);
    wtype = ones(size(h));
    wtype(find(h<200)) = 4;
    
    maskr=h>0;
%     maskr=process_mask(maskr);
    [masku,maskv,maskp]=uvp_mask(maskr);
    
    nc=netcdf(child_grid,'write');
    nc{'h'}(:)=h;
    nc{'wtype_grid'}(:) = wtype;
    nc{'mask_u'}(:)=masku;
    nc{'mask_v'}(:)=maskv;
    nc{'mask_psi'}(:)=maskp;
    nc{'mask_rho'}(:)=maskr;
    close(nc);
    
    r=input('Do you want to use editmask ? y,[n]','s');
    if strcmp(r,'y')
        disp(' Editmask:')
        disp(' Edit manually the land mask.')
        disp(' Press enter when finished.')
        disp(' ')
        if ~isempty(coastfileplot)
            editmask(child_grid,coastfilemask)
        else
            editmask(child_grid)
        end
        r=input(' Finished with edit mask ? [press enter when finished]','s');
    end
    
    make_sponge(child_grid)
    close all
    
    % Smooth the topography
    nc=netcdf(child_grid,'write');
    h=nc{'h'}(:);
    maskr=nc{'mask_rho'}(:);

    h  =smoothgrid(h,maskr,hmin,hmax,hmax,...
               rtarget,n_filter_deep_topo,n_filter_final);
    hf = h;   
    
    h_new = nan*ones(size(h));  
    loose_zone_b           = 2;
    loose_zone_e           = 7;
    h_new(1:loose_zone_b,:)         = hs(1:loose_zone_b,:);
    h_new(end-loose_zone_b+1:end,:) = hs(end-loose_zone_b+1:end,:);
    h_new(:,1:loose_zone_b)         = hs(:,1:loose_zone_b);
    h_new(:,end-loose_zone_b+1:end) = hs(:,end-loose_zone_b+1:end);
    
    h_new(loose_zone_e:end-loose_zone_e+1,loose_zone_e:end-loose_zone_e+1)=...
       hf(loose_zone_e:end-loose_zone_e+1,loose_zone_e:end-loose_zone_e+1);


    for LOOSE_NUM = 1:(loose_zone_e-loose_zone_b-1)
        LOOSE_F   = loose_zone_e-loose_zone_b;
        F_loose_f = LOOSE_NUM/LOOSE_F;
        F_loose_c = 1 - F_loose_f;
        
        h_new(loose_zone_b+LOOSE_NUM,:)=...
           hf(loose_zone_b+LOOSE_NUM,:)*F_loose_f +...
           hs(loose_zone_b+LOOSE_NUM,:)*F_loose_c;
       
        h_new(end-loose_zone_b-LOOSE_NUM+1,:)=...
           hf(end-loose_zone_b-LOOSE_NUM+1,:)*F_loose_f +...
           hs(end-loose_zone_b-LOOSE_NUM+1,:)*F_loose_c;
        
        h_new(:,loose_zone_b+LOOSE_NUM)=...
           hf(:,loose_zone_b+LOOSE_NUM)*F_loose_f +...
           hs(:,loose_zone_b+LOOSE_NUM)*F_loose_c;
       
        h_new(:,end-loose_zone_b-LOOSE_NUM+1)=...
           hf(:,end-loose_zone_b-LOOSE_NUM+1)*F_loose_f +...
           hs(:,end-loose_zone_b-LOOSE_NUM+1)*F_loose_c;
    end

    h = h_new;
    %
    %  Write it down
    %
    disp(' ')
    disp(' Write it down...')
    nc{'h'}(:)=h;
    close(nc);
    
    Gnames=[Gnames,child_grid];
end

[S,G]=contact(Gnames,contactname);

close all

figure
project = 'miller';
m_proj(project,...
'lon',[min(min(lon_rho)) max(max(lon_rho))],...
'lat',[min(min(lat_rho)) max(max(lat_rho))])
m_pcolor(lon_rho,lat_rho,mask.*h_rho)                
shading flat
hold on
m_plot(lon_rho(1,:),lat_rho(1,:),'k'); 
m_plot(lon_rho(end,:),lat_rho(end,:),'k');
m_plot(lon_rho(:,1),lat_rho(:,1),'k'); 
m_plot(lon_rho(:,end),lat_rho(:,end),'k')
colorbar
% cm = ncl_colormap('cmocean_deep',20);
cm = m_colmap('jet',50);
colormap(cm)

caxis([0 hmax])

m_grid('linestyle','none','box','none',...
          'xtick',[-360:20:360],...
          'ytick',[-90:10:90],...
          'tickdir','in','fontsize',10);
m_coast('line','color','w','LineWidth',1);

for i = 1:max_dom-1
    nc=netcdf(cell2mat(Gnames(i+1)));
    lon_rho=nc{'lon_rho'}(:);
    lat_rho=nc{'lat_rho'}(:);
    h      =nc{'h'}(:);
    mask   =nc{'mask_rho'}(:);
    mask(find(mask==0)) = NaN;
    result=close(nc);
    m_pcolor(lon_rho,lat_rho,mask.*h)                
    shading flat
    m_plot(lon_rho(1,:),lat_rho(1,:),'-','color','k','LineWidth',2); 
    m_plot(lon_rho(end,:),lat_rho(end,:),'-','color','k','LineWidth',2);
    m_plot(lon_rho(:,1),lat_rho(:,1),'-','color','k','LineWidth',2); 
    m_plot(lon_rho(:,end),lat_rho(:,end),'-','color','k','LineWidth',2)
end

