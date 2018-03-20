function [data] = normc(data, column)
    x = data(:,column);
    data(:, column) = (x-min(x))/(max(x)-min(x));
end