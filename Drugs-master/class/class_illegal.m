% Class data set to have illegal users
function [data_il] = class_illegal(data)
    illegal = [2,3,4,6,8,9,10,11,12,14,15,16];
    %legal = [1,5,7,13,17,18,19]'+13;
    data_il = zeros(size(data,1),1);
    drugs = data(:,14:32);
    drugs_log = double(drugs >= 1);
    for i = 1:size(drugs_log,1)
        use = 0;
        for ii = illegal
            use = use + drugs_log(i,ii);
        end
        use = double(use >= 1);
        data_il(i,1) = use;
    end
end