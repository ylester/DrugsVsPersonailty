% Filter data set to include only males
function [data_f] = filter_females(data)
    data_f = filterc(data, 3, [0]);
end