clear all;
close all;
load('data.mat');

red = [1, 0, 0];
blue = [0, 0, 1];
size = 200;
jitter = 0.0;
alpha = 0.2;

ill = class_illegal(data);

illegal = data(ill == 1, :);
legal = data(ill == 0, :);
xc = 7; % Nicotine (30)
yc = 8; % Cannibis (19) / Caffine (18)
zc = 9; % Benzos (17) / Chocolate (20)
scatter3(illegal(:,xc), illegal(:,yc), illegal(:,zc), ...
    size, red, 'filled', 'o', 'MarkerFaceAlpha', alpha);
hold on;
scatter3(legal(:,xc), legal(:,yc), legal(:,zc), ...
    size, blue, 'filled', 'o', 'MarkerFaceAlpha', alpha);

xlabel(data_names(1,xc));
ylabel(data_names(1,yc));
zlabel(data_names(1,zc));
legend('Illegal', 'Legal');

% legal = illegal;
% x = [legal(:,15),legal(:,16),legal(:,17),legal(:,19),legal(:,21), ...
%     legal(:,22),legal(:,23),legal(:,24),legal(:,25),...
%     legal(:,27),legal(:,28),legal(:,29)];
% Has done both illegal drugs (1)
tabulate(illegal(:,17) == 0 & illegal(:,19) == 0);
tabulate(legal(:,17) == 0 & legal(:,19) == 0); % All are 0 for data set
tabulate(data(:,17) == 0 & data(:,19) == 0);

% Makes sense that there is good separation because two of the axis are
% Both illegal drugs
% More interesting to look at scores

% tabulate(data(:,19));
% tabulate(data(:,17));