% Filter data set at column with this value
function [fdata] = filterc(data, column, values)
    fdata = [];
    ii = 1;
    for i = 1:size(data,1)
       val = data(i,column);
       if (has_one(values, val) == 1)
          fdata(ii,:) = data(i,:); 
          ii = ii+1;
       end
    end
end