% Determine in a vector of values has a value
function [has] = has_one(values, value)

    has = 0; % False

    for i = 1:size(values)
        val = values(i,1);
        if (val == value)
           has = 1; % True
           break;
        end
    end

end