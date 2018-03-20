function [data] = mapc(data, column, keys)
    in = data(:,column);
    out = map(in, keys);
    data(:,column) = out;
end