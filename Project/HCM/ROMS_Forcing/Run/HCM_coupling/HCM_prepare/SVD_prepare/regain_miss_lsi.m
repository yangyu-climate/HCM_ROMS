function redata=regain_miss(data,nx,ny,row)
% Regaining Missing Point   将剔除的缺测点复原，并标记为NaN
% 输入参数：
%     data：输入数据
%     row：缺测点所在的位置
%     nx
%     ny
% 输出参数：
%     redata：输出数据

redata=zeros(nx*ny,size(data,2));
count=0;
for i=1:nx*ny
    if ~ismember(i,row)
        redata(i,:)=NaN;
        %unique
    else
        count=count+1;
        redata(i,:)=data(count,:);
        %end
    end
end
redata=reshape(redata,nx,ny,size(data,2));