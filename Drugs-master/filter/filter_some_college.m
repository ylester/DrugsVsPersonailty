% Filter data set for people who never went to college
function [data_pc] = filter_past_college(data)
    data_pc = filterc(data, 4, [4:6]');
end