clear all;
close all;
load('data.mat');

red = [1, 0, 0];
blue = [0, 0, 1];
size = 50;
jitter = 0.5;
alpha = 0.2;

ill = class_illegal(data);

%6,13
for d = 2:6
   figure;
   p = 1;
   for s = 7:13
      illegal = data(ill == 1, :);
      legal = data(ill == 0, :);
      subplot(2,4,p);
      scatter(illegal(:,d), illegal(:,s), size, red, 'filled', 'o', ...
          'jitter', 'on', 'jitterAmount', jitter, 'MarkerFaceAlpha', alpha);
      hold on;
      subplot(2,4,p);
      scatter(legal(:,d), legal(:,s), size, blue, 'filled', 'o', ...
          'jitter', 'on', 'jitterAmount', jitter, 'MarkerFaceAlpha', alpha);
      xlabel(data_names(1,d));
      ylabel(data_names(1,s));
      p = p + 1;
   end
   subplot(2,4,p);
   axis off
   text(0,0, {'{\color{red} o } Illegal', '{\color{blue} o } Legal'}, 'EdgeColor', 'k');

end