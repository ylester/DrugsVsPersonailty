% Filter data set only people have used semer
function [data_s] = filter_semer(data)
    data_s = filterc(data, 31, [1:6]');
end