% Class data set to have extremes users
function [classes] = class_scores(data, columns)
    if size(columns) == 0
        columns = 7:13;
    end
    rows = size(data,1);
    classes = ones(rows, 1)*-1;
    quantiles = cell(1,6);
    for i = 7:13
        x = data(:,i);
        x25 = quantile(x,0.25);
        x75 = quantile(x,0.75);
        quantiles(1,i-6) = {[x25,x75]};
    end
    for i = 1:rows
        is_high = 0;
        is_low = 0;
        is_norm = 0;
        for ii = columns
            quans = quantiles{1,ii-6};
            x25 = quans(1,1);
            x75 = quans(1,2);
            score = data(i,ii);
            if score > x75
                is_high = 1;
            elseif score < x25
                is_low = 1;
            else 
                is_norm = 1;
            end
        end
        class = -1;
        if is_norm == 1 && (is_high == 1 || is_low == 1)
            class = 1; %Range of scores
        elseif is_norm == 1
            class = 0; %All normal
        elseif is_norm == 0 && is_high == 1 && is_low == 0
            class = 2; %Is high only
        elseif is_norm == 0 && is_high == 0 && is_low == 1
            class = 3; % Is low only
        end
        classes(i,1) = class;
    end
end