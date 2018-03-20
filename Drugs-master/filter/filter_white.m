% Filter data set only people that are white
function [data_w] = filter_white(data)
    data_w = filterc(data, 6, [6]);
end