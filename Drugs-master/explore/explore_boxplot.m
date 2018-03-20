clear all;
close all;
load('data.mat');

figure;
boxplot(data(:,14:32), data_names(1,14:32));
title('Drug vs Usage (All)');
set(gca, 'YTick', 0:6);
set(gca, 'YTickLabel', class_names);

figure;
boxplot(data(:,7:13), data_names(1,7:13));
hold on;
title('Test vs Score (All)');
set(gca, 'YTick', 0:0.5:1);
set(gca, 'YTickLabel', {'Low' ; 'Middle' ; 'High'});

%Demographics
names = {age_names, gender_names, education_names, country_names, ethnicity_names};
figure;
for i = 2:6
   col = data(:,i);
   subplot(1,5,i-1);
   boxplot(col);
   title(strcat(data_names(1,i), ' (All)'));
   dnames = names{1,i-1};
   set(gca, 'YTick', 0:length(dnames));
   set(gca, 'YTickLabel', dnames);
end