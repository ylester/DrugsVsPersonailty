% Filter data set only people that are young 18-24
function [data_oa] = filter_old_age(data)
    data_oa = filterc(data, 2, [3:5]');
end