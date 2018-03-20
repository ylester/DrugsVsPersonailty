clear all;
close all;
load('data.mat');

red = [1, 0, 0];
blue = [0, 0, 1];
size = 50;
jitter = 0.5;
alpha = 0.2;

ill = class_illegal(data);
scs = class_scores(data, [8]);
enable_legal = 0;
enable_illegal = 1;

% Attempt to visualize if scores have any impact on class illegal/legal

%6,13
for d = 2:6 %Demographics
   figure;
   p = 1;
   for s = 7:13 %Scores
      cdata = data;
      cdata(:,end+1) = scs(:,1);
      illegal = cdata(ill == 1, :);
      legal = cdata(ill == 0, :);

      if enable_illegal == 1
          subplot(2,4,p);
          scatter(illegal(:,d), illegal(:,s), size, illegal(:,end), 'filled', '^', ...
              'jitter', 'on', 'jitterAmount', jitter, 'MarkerFaceAlpha', alpha);
      end
      if enable_legal == 1
          hold on;
          subplot(2,4,p);
          scatter(legal(:,d), legal(:,s), size, legal(:,end), 'filled', 'v', ...
              'jitter', 'on', 'jitterAmount', jitter, 'MarkerFaceAlpha', alpha);
      end
      xlabel(data_names(1,d));
      ylabel(data_names(1,s));
      p = p + 1;
   end
   %subplot(2,4,p);
   %axis off
   %text(0,0, {'{\color{red} o } Illegal', '{\color{blue} o } Legal'}, 'EdgeColor', 'k');
end