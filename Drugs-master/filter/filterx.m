% Filter data set at column with this value
function [xdata] = filterx(data, column, range)
    xdata = [];
    ii = 1;
    for i = 1:size(data,1)
       val = data(i,column);
       if (is_range(range, val) == 1)
          xdata(ii,:) = data(i,:); 
          ii = ii+1;
       end
    end
end