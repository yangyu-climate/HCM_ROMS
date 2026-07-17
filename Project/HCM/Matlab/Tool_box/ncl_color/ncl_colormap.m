function color = ncl_colormap(colorname,m)

if nargin ==1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end

% temp = import_ascii([colorname '.rgb']);
% temp(1:2) = [];
% temp = split(temp,'#');
% temp = temp(:,1);
% color = deblank(color);
% temp = strtrim(temp);
% temp = regexp(temp, '\s+', 'split');
% for i=1:size(temp,1)
%     color(i,:) = str2double(temp{i});    
% end
temp = distilldata_read([colorname '.rgb']);
for i=1:size(temp,1)
    color(i,:) = temp(i,:);    
end
color = color/255;


P = size(color,1);
color = interp1(1:size(color,1), color, linspace(1,P,m), 'linear');
end