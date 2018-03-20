%% INIT DATA
clear all;
close all;
load('data.mat');
rng(1); % For reproducibility

%% FILTER
% Filtering the data set can increase the accuracy
%data = filter_some_college(data);
%data = filter_white(data);


%% GET CLASSES
% Append class to data as last column
classes = class_illegal(data);

% Compute skew of classes
num_illegal = sum(classes==1); % Number of illegal drug users
num_legal = sum(classes==0); % Number of legal drug users
class_skewness = num_legal/num_illegal;


%% CLEAN
% Remove duplicates
[data,i] = unique(data,'rows');
classes = classes(i);

% Remove features
data = data(:,2:end); % Remove id (All indexes are -1 from this point)


%% TEST

% See if performance is better for any other set of features
s1 = [data(:, 6:10) classes]; %Use only scores
[~,~,~,~,thetas_scores] = run(s1); % Train score 90, Test score 88, Overfit

% Optimize features (To decrease features/overfit)
title = 'Scores';
optimize_lambda(s1, 1:20:1000, title); % Optimize lambda from 1 to 1000
optimize_pca(s1, title); % Optimize with PCA, retain all features info(100%) to none (0%)
optimize_threshold(s1, title); % See if changing boundary has any effect (Seems like error is based on skew)

% Determine if the most information columns have better classification
[info_rank] = explore_rank(s1);


%% MAIN RUN FUNCTIONS

function [avg_train_score, avg_test_score, avg_train_error, avg_test_error, thetas] = ... 
    run(data)
    [avg_train_score, avg_test_score, avg_train_error, avg_test_error, thetas] = ...
        run_params(data,0,100,0.5,1);
end

function [avg_train_score, avg_test_score, avg_train_error, avg_test_error, thetas] = ... 
    run_params(data, lambda, retention, threshold, print)

    % Define parameters
    options = optimoptions('fminunc','Display','off', ...
        'SpecifyObjectiveGradient',true,'MaxIterations',1000);
    %lambda = 0;
    beta = 1;

    folds = 10;
    train_scores = zeros(folds,1);
    test_scores = zeros(folds,1);
    train_errors = zeros(folds,1);
    test_errors = zeros(folds,1);
    for i = 1:folds
        % Separate into test/training data set
        rows = size(data,1);
        num_rows = rows/folds;
        lower_test_row = int16((i-1)*num_rows);
        upper_test_row = int16(i*num_rows);
        if i == 1
            data_train = data(upper_test_row+1:end,:);
            data_test = data(lower_test_row+1:upper_test_row,:);
        elseif i == folds
            data_train = data(1:lower_test_row, :);
            data_test = data(lower_test_row+1:upper_test_row,:);
        else
            data_train = ...
              [data(1:lower_test_row, :) ; data(upper_test_row+1:end,:)];
            data_test = data(lower_test_row+1:upper_test_row,:);
        end
        
        % Strip class labels
        class_train = data_train(:,end);
        data_train = data_train(:,1:end-1);
        class_test = data_test(:,end);
        data_test = data_test(:,1:end-1);

        % Feature scaling/mean normalization
        avg = mean(data_train);
        var = std(data_train);
        data_train = (data_train - avg)./var;
        data_test = (data_test - avg)./var; % Assume test set is within same population
        
        % Principle Component Analysis
        [coeff_train, sc_train, latent_train] = pca(data_train);
        col = size(coeff_train,2);
        while 1==1 % Determine how many columns in new basis to keep
            retained = (sum(latent_train(1:col))/sum(latent_train))*100;
            if retained < retention
               col = col + 1;
               break;
            else
               col = col - 1;
            end
        end
        [coeff_test, sc_test, latent_test] = pca(data_test);
        data_train = sc_train(:,1:col);
        data_test = sc_test(:,1:col);

        % Add bias terms
        data_test = horzcat(ones(size(data_test,1),1),data_test);
        data_train = horzcat(ones(size(data_train,1),1),data_train);
        
        % Determine thetas with gradient descent
        thetas = 1e-5 * randn(size(data_train,2),1); % Start with low randoms
        [thetas,~] = fminunc( ...
            @(T)(cost(T,data_train,class_train,lambda)), ...
            thetas,options);
        %cost_train = cost(thetas,data_train,class_train,0);
        %cost_test = cost(thetas,data_test,class_test,0);


        [error_train, recall_train, precision_train, fscore_train] =  ...
            score(data_train, class_train, thetas, threshold, beta);

        [error_test, recall_test, precision_test, fscore_test] =  ...
            score(data_test, class_test, thetas, threshold, beta);

        train_errors(i,1) = error_train;
        test_errors(i,1) = error_test;
        train_scores(i,1) = fscore_train;
        test_scores(i,1) = fscore_test;

    end
    
    avg_train_score = mean(train_scores);
    avg_test_score = mean(test_scores);

    avg_train_error = mean(train_errors);
    avg_test_error = mean(test_errors);

    % Print results
    if (print == 1)
        sprintf('Train score:\t%f\nTest score:\t%f\nTrain error:\t%f\nTest error:\t%f', ...
             avg_train_score, avg_test_score, avg_train_error, avg_test_error)
    end

end


%% HELPER FUNCTIONS

% FUNCTION FOR SCORES
function [error, recall, precision, fscore] = ...
    score(data, classes, thetas, threshold, beta)
    h = sigmoid(data*thetas);
    output = h;
    output(h>=threshold) = 1;
    output(h<threshold) = 0;
    tp = numel(find(output==1 & classes==1));
    fp = numel(find(output==1 & classes==0));
    tn = numel(find(output==0 & classes==0));
    fn = numel(find(output==0 & classes==1));
    error = (fp+fn)/(tp+fp+tn+fn);
    recall = tp/(tp+fn);
    precision = tp/(tp+fp);
    fscore = (1+beta^2)*(precision*recall)/((beta^2)*...
        precision+recall);
    if isnan(fscore) % Precision and recall are both 0 (0/0 is NaN)
        fscore = 0;
    end
end

% FUNCTION TO COMPUTE COST AND GRADIENT
function [J, grad] = cost(T,data,classes,lambda)
    m = size(data,1);
    h = sigmoid(data*T);
    J = -(1/m)*sum(classes.*log(h)+(1-classes).*log(1 - h)) + ...
        (lambda/(2*m))*sum(T(2:end).^2);
    grad = (1/m)*(data'*(h - classes)) + [0; (lambda/m)*T(2:end)];
end

% SIGMOID FUNCTION
function f = sigmoid(x)
    f = 1./(1+exp(-x));
end

%% EXTRA FUNCTIONS

function [info_rank] = explore_rank(data)
    %Check covariance
    % norm = (data-mean(data))./std(data); (Good to check)
    classes = data(:,end);
    covd = cov(data(:,1:end-1)); % Do not select class
    cov_eye = eye(size(covd)).*covd;
    cov_eye_vec = diag(cov_eye);
    cov_eye_vec(:,2) = 1:size(cov_eye_vec,1);
    info_rank = flipud(sortrows(cov_eye_vec, 1)); % How much info is in each feature?
    
    num_cols = 0;
    results = [];
    for i = 1:size(info_rank,1)
        num_cols = num_cols+1;
        columns = info_rank(1:num_cols,2);
        info_data = [];
        for ii = 1:size(columns,1)
            col = columns(ii,1);
            info_data = [info_data data(:,col)];
        end
        info_data(:,end+1) = classes; % add classes
        [avg_train_score, avg_test_score, avg_train_error, avg_test_error] = ...
            run_params(info_data,0,100,0.5,0);
        results(i,1:4) = [avg_train_score, avg_test_score, ...
            avg_train_error, avg_test_error];
    end
    plot_results(results);
end

function [lambda] = optimize_lambda(data, lambdas, name)
    all_results = [];
    for p = 1:size(lambdas,2)
        lambda = lambdas(1,p);
        [a,b,c,d,t] = run_params(data,lambda,100,0.5,0);
        all_results(p,1:4) = [a,b,c,d];
        all_results(p,5) = lambda;
    end
    figure;
    y = all_results(:,5);
    for xi = 1:2
        plot(y, all_results(:,xi), '-o');
        hold on;
    end
    title(sprintf('Optimize Lambda (%s)', name));
    xlabel('Lambda');
    ylabel('Score');
    legend('Train Fscores', 'Test Fscores');
    %all_results
end

function [ret] = optimize_pca(data, name)
    retentions = 1:100;
    all_results = [];
    for p = 1:size(retentions,2)
        retention = retentions(1,p);
        [a,b,c,d,t] = run_params(data,0,retention,0.5,0);
        all_results(p,1:4) = [a,b,c,d];
        all_results(p,5) = retention;
    end
    figure;
    y = all_results(:,5);
    for xi = 1:2
        plot(y, all_results(:,xi), '-o');
        hold on;
    end
    title(sprintf('Optimize Pca (%s)', name));
    xlabel('Retention');
    ylabel('Score');
    legend('Train Fscores', 'Test Fscores');
    %all_results
end

function [thr] = optimize_threshold(data, name)
    threshs = 0:0.1:1;
    all_results = [];
    for p = 1:size(threshs,2)
        thresh = threshs(1,p);
        [a,b,c,d,t] = run_params(data,0,100,thresh,0);
        all_results(p,1:4) = [a,b,c,d];
        all_results(p,5) = thresh;
    end
    figure;
    y = all_results(:,5);
    for xi = 1:2
        plot(y, all_results(:,xi), '-o');
        hold on;
    end
    title(sprintf('Optimize Threshold (%s)', name));
    xlabel('Threshold');
    ylabel('Score');
    legend('Train Fscores', 'Test Fscores');
    %all_results
end

function [] = plot_results(results)
    sz = size(results,1);
    figure;
    plot(1:sz, results(:,1), '-o');
    hold on;
    plot(1:sz, results(:,2), '-o');
    xlabel('Combined Features (By Info Rank)');
    ylabel('Score');
    legend('Train Fscores', 'Test Fscores');
    title('Optimize Variance');
    xticks(1:31);

    figure;
    plot(1:sz, results(:,3), '-o');
    hold on;
    plot(1:sz, results(:,4), '-o');
    xlabel('Combined Features (By Info Rank)');
    ylabel('Error');
    legend('Train Errors', 'Test Errors');
    title('Optimize Variance');
    xticks(1:31);
end