% Filter data set for people who never went to college
function [data_nc] = filter_no_college(data)
    data_nc = filterc(data, 4, [0:3]');
end