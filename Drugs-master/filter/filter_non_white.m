% Filter data set only people that are non-white
function [data_nw] = filter_non_white(data)
    data_nw = filterc(data, 6, [0:5]');
end