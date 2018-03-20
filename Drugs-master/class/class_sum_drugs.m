% Class data set to have sum of drug usage
% Normalize does not score drug usage
function [classes] = class_sum_drugs(data, normalize)
    if (normalize == 1)
       data(:,14:32) = data(:,14:32) > 0; 
    end
    classes = zeros(size(data,1),1);
    for i = 1:size(data,1)
        score = sum(data(i,14:32));
        classes(i,1) = score;
    end
end