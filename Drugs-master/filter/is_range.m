% Determine if value is in between [x,y] value >= x & value <= y
function [is] = is_range(range, value)

    is = 0; % False

    if (value >= range(1,1) && value <= range(1,2))
       is = 1; 
    end

end