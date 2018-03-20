% Filter data set to include only males
function [data_m] = filter_males(data)
    data_m = filterc(data, 3, [1]);
end