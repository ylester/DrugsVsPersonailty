% Filter data set only people that are young 18-24
function [data_ya] = filter_young_age(data)
    data_ya = filterc(data, 2, [0]);
end