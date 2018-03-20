clear all;
close all;
load('data.mat');

semer_data = filter_semer(data);
norm = 0;
scores_semer = class_sum_drugs(semer_data,norm);
scores_all = class_sum_drugs(data,norm);
%18, norm
%108, severity
tbl_semer = tabulate(scores_semer);
tbl_all = tabulate(scores_all);
figure;
bar(tbl_semer(:,2));
axis([0,108,0,max(tbl_semer(:,2))]);
xlabel('Sum of drug usage (Semer)');
ylabel('Frequency');
figure;
bar(tbl_all(:,2));
axis([0,108,0,max(tbl_all(:,2))]);
xlabel('Sum of drug usage (All)');
ylabel('Frequency');