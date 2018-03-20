clear all;
close all;
load('data.mat');

% Find out if all users are drug users
figure;
users = 0;
non_users = 0;
for i = 1:size(data,1)
    drug_usage = data(i,14:32);
    sdu = sum(drug_usage);
    if sdu == 0 % All drugs were 0, user does not use any
        non_users = non_users + 1;
    else
        users = users + 1;
    end
end
bar([users, non_users])
title('All drug users? (All)');
set(gca, 'XTickLabel', {sprintf('Uses any drug (%d)', users), ...
                        sprintf('Uses no drugs (%d)', non_users)});

% Find out legal from non-legal
% 1,5,7,13,17,18,19 legal but abused drugs
figure;
only_legal_users = 0;
illegal_users = 0;
for i = 1:size(data,1)
    drug_usage = data(i,14:32);
    sdu = sum(drug_usage(1,2:4)) + ...
          sum(drug_usage(1,6)) + ...
          sum(drug_usage(1,8:12)) + ...
          sum(drug_usage(1,14:16));
    if sdu == 0 % All drugs were 0, user does not use any illegal drugs
        only_legal_users = only_legal_users + 1;
    else
        illegal_users = illegal_users + 1;
    end
end
bar([only_legal_users, illegal_users])
title('Drug Usage (All)');
set(gca, 'XTickLabel', {sprintf('Only Uses Legal Drugs (%d)', only_legal_users), ...
                        sprintf('Uses Illegal Drugs (%d)', illegal_users)});

% How many people used a particular drug?
% What does drug distribution look like?
figure;
drug_usage_count = zeros(1,19);
for i = 1:size(data,1)
    drug_usage = data(i,14:32);
    usage = double(drug_usage >= 1);
    drug_usage_count = drug_usage_count + usage;
end

bar(drug_usage_count)
title('Drug Usage Count (All)');
set(gca, 'XTick', 1:19);
set(gca, 'XTickLabel', data_names(1, 14:32));