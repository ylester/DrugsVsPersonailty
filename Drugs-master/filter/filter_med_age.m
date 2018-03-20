% Filter data set only people that are young 18-24
function [data_ma] = filter_med_age(data)
    data_ma = filterc(data, 2, [1:2]');
end