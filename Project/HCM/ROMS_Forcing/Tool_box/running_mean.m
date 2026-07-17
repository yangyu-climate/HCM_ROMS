function data_out = running_mean(data_in,smooth_num)
    if nargin == 1
        smooth_num = 1;
    end
    if length(size(data_in))==3
        var   = data_in;
        for i =1:size(var,1)
            var_2d                  = squeeze(var(i,:,:));
            for con_num =1:smooth_num
                var_ex                  = NaN*ones(size(var_2d,1)+2,size(var_2d,2)+2);
                var_ex(2:end-1,2:end-1) = var_2d;
                var_ex(1,2:end-1)       = var_2d(1,:);
                var_ex(end,2:end-1)     = var_2d(end,:);
                var_ex(2:end-1,1)       = var_2d(:,1);
                var_ex(2:end-1,end)     = var_2d(:,end);
                for j = 1:size(var_2d,1)
                    for k = 1:size(var_2d,2)
                            var_2d(j,k) = nanmean(nanmean(var_ex(j+1-1:j+1+1,k+1-1:k+1+1)));
                    end
                end
            end                
        var(i,:,:) = var_2d;     
        end
        data_out = var;
    elseif length(size(data_in))==2
        var    = data_in;
        var_2d = squeeze(var);
        for con_num =1:smooth_num
            var_ex                  = NaN*ones(size(var_2d,1)+2,size(var_2d,2)+2);
            var_ex(2:end-1,2:end-1) = var_2d;
            var_ex(1,2:end-1)       = var_2d(1,:);
            var_ex(end,2:end-1)     = var_2d(end,:);
            var_ex(2:end-1,1)       = var_2d(:,1);
            var_ex(2:end-1,end)     = var_2d(:,end);
            for j = 1:size(var_2d,1)
                for k = 1:size(var_2d,2)
                    var_2d(j,k) = nanmean(nanmean(var_ex(j+1-1:j+1+1,k+1-1:k+1+1)));
                end
            end
        end                
        var      = var_2d;     
        data_out = var;
    end

