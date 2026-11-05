% Grassman_classifier_G_features_Glaucoma_vs_NORMAL

clear
close all
addpath(genpath('.\measures\'));
addpath(genpath('.\MultiClassMetrics-ConfusionMatrix-main'));

%dimSubspace = 30;  % Subspace dimension for Grassmann representatives
N_trials = 100; % Geneate N_trials random partitions

problem_type = 1; % 1: normal vs. advanced
                  % 2: normal vs. early
                  % 3: early vs. advanced
                  % 4: normal vs. early vs. advanced

load G_features_train_CR_7.mat
[num txt raw]=xlsread('glaucoma_grading_training_GT.xlsx');  % It is assumed that text labels are .\MERA_features directory

normal = 0; early = 0; advanced = 0;
for ii=1:length(num)
    if num(ii,1)
        normal = normal + 1;
        ind_normal(normal)=ii;
    elseif num(ii,2)
        early = early + 1;
        ind_early(early) = ii;
    else
        advanced = advanced + 1;
        ind_advanced(advanced) = ii;
    end
end

G_features_normal = G_features_train(:,ind_normal);
G_features_early = G_features_train(:,ind_early);
G_features_advanced = G_features_train(:,ind_advanced);

load G_features_test_CR_7.mat
[num txt raw]=xlsread('glaucoma_grading_testing_GT.xlsx');  % It is assumed that text labels are .\MERA_features directory

normal = 0; early = 0; advanced = 0;
clear ind_normal ind_early ind_advanced

for ii=1:length(num)
    if num(ii,1)
        normal = normal + 1;
        ind_normal(normal)=ii;
    elseif num(ii,2)
        early = early + 1;
        ind_early(early) = ii;
    else
        advanced = advanced + 1;
        ind_advanced(advanced) = ii;
    end
end

G_features_normal = [G_features_normal G_features_test(:,ind_normal)];
G_features_early = [G_features_early G_features_test(:,ind_early)];
G_features_advanced = [G_features_advanced G_features_test(:,ind_advanced)];

load G_features_validation_CR_7.mat
[num txt raw]=xlsread('glaucoma_grading_validating_GT.xlsx');  % It is assumed that text labels are .\MERA_features directory

normal = 0; early = 0; advanced = 0;
clear ind_normal ind_early ind_advanced

for ii=1:length(num)
    if num(ii,1)
        normal = normal + 1;
        ind_normal(normal)=ii;
    elseif num(ii,2)
        early = early + 1;
        ind_early(early) = ii;
    else
        advanced = advanced + 1;
        ind_advanced(advanced) = ii;
    end
end

G_features_normal = [G_features_normal G_features_validation(:,ind_normal)];
G_features_early = [G_features_early G_features_validation(:,ind_early)];
G_features_advanced = [G_features_advanced G_features_validation(:,ind_advanced)];
%G_features_early_plus_advanced = [G_features_early G_features_advanced];

G_features_normal = abs(G_features_normal);
G_features_early = abs(G_features_early);
G_features_advanced = abs(G_features_advanced);
%G_features_early_plus_advanced = abs(G_features_early_plus_advanced);

rng('default');  % for reproducibility

tstart = tic;
n=1;
while n <= N_trials

    % Normal (control) class
    hpartition = cvpartition(size(G_features_normal,2),'Holdout',0.3); % Nonstratified partition
    idxTrain = training(hpartition);
    idxTest = test(hpartition);
    G_train_normal=G_features_normal(:,idxTrain);
    G_test_normal=G_features_normal(:,idxTest);

    % Early glaucoma class
    hpartition = cvpartition(size(G_features_early,2),'Holdout',0.3); % Nonstratified partition
    idxTrain = training(hpartition);
    idxTest = test(hpartition);
    G_train_early=G_features_early(:,idxTrain);
    G_test_early=G_features_early(:,idxTest);
    %
    % Advanced glaucoma class
    hpartition = cvpartition(size(G_features_advanced,2),'Holdout',0.3); % Nonstratified partition
    idxTrain = training(hpartition);
    idxTest = test(hpartition);
    G_train_advanced=G_features_advanced(:,idxTrain);
    G_test_advanced=G_features_advanced(:,idxTest);

    % Early plus advanced glaucoma class
    % hpartition = cvpartition(size(G_features_early_plus_advanced,2),'Holdout',0.3); % Nonstratified partition
    % idxTrain = training(hpartition);
    % idxTest = test(hpartition);
    % G_train_early_plus_advanced=G_features_early_plus_advanced(:,idxTrain);
    % G_test_early_plus_advanced=G_features_early_plus_advanced(:,idxTest);

    % Estimate orthonormal bases: Grassmann points
    % XX = [G_train_normal G_train_advanced];
    % TrainLabels = [ones(1,size(G_train_normal,2)) 2*ones(1,size(G_train_advanced,2))];
    % %
    % X_test = [G_test_normal G_test_advanced];
    % TestLabels = [ones(1,size(G_test_normal,2)) 2*ones(1,size(G_test_advanced,2))];

    %  XX = [G_train_normal G_train_early];
    % TrainLabels = [ones(1,size(G_train_normal,2)) 2*ones(1,size(G_train_early,2))];
    %
    % X_test = [G_test_normal G_test_early];
    % TestLabels = [ones(1,size(G_test_normal,2)) 2*ones(1,size(G_test_early,2))];

    % XX = [G_train_early G_train_advanced];
    % TrainLabels = [ones(1,size(G_train_early,2)) 2*ones(1,size(G_train_advanced,2))];
    %
    % X_test = [G_test_early G_test_advanced];
    % TestLabels = [ones(1,size(G_test_early,2)) 2*ones(1,size(G_test_advanced,2))];

    % XX = [G_train_normal G_train_early_plus_advanced];
    % TrainLabels = [ones(1,size(G_train_normal,2)) 2*ones(1,size(G_train_early_plus_advanced,2))];
    %
    % X_test = [G_test_normal G_test_early_plus_advanced];
    % TestLabels = [ones(1,size(G_test_normal,2)) 2*ones(1,size(G_test_early_plus_advanced,2))];

    if problem_type == 1
        XX = [G_train_normal G_train_advanced];
        TrainLabels = [ones(1,size(G_train_normal,2)) 2*ones(1,size(G_train_advanced,2))];
        X_test = [G_test_normal G_test_advanced];
        TestLabels = [ones(1,size(G_test_normal,2)) 2*ones(1,size(G_test_advanced,2))];
        num_classes = 2; dimSubspace = 1;
    elseif problem_type == 2
        XX = [G_train_normal G_train_early];
        TrainLabels = [ones(1,size(G_train_normal,2)) 2*ones(1,size(G_train_early,2))];
        X_test = [G_test_normal G_test_early];
        TestLabels = [ones(1,size(G_test_normal,2)) 2*ones(1,size(G_test_early,2))];
        num_classes = 2; dimSubspace = 1;
    elseif problem_type == 3
        XX = [G_train_early G_train_advanced];
        TrainLabels = [ones(1,size(G_train_early,2)) 2*ones(1,size(G_train_advanced,2))];
        X_test = [G_test_early G_test_advanced];
        TestLabels = [ones(1,size(G_test_early,2)) 2*ones(1,size(G_test_advanced,2))];
        num_classes = 2; dimSubspace = 8;
    elseif problem_type == 4
        XX = [G_train_normal G_train_early G_train_advanced];
        TrainLabels = [ones(1,size(G_train_normal,2)) 2*ones(1,size(G_train_early,2)) 3*ones(1,size(G_train_advanced,2))];
        X_test = [G_test_normal G_test_early G_test_advanced];
        TestLabels = [ones(1,size(G_test_normal,2)) 2*ones(1,size(G_test_early,2)) 3*ones(1,size(G_test_advanced,2))];
        num_classes = 3; dimSubspace = 12;
    end

    [B_x, begB_x, enddB_x, mu_X] = bases_estimation(XX,TrainLabels,dimSubspace);

    % Testing
    for el=1:num_classes
        X_testm = X_test - mu_X(:,el);    % make data zero mean for distance calculation
        BB=B_x(:,begB_x(el):enddB_x(el));
        Xproj = (BB*BB')*X_testm;
        Dproj = X_testm - Xproj;
        D(el,:) = sqrt(sum(Dproj.^2,1));
    end

    [~, TestLabels_est] = min(D);
    clear D X_test

    if numel(unique(TestLabels_est)) == num_classes
        C = confusionmat(TestLabels,TestLabels_est);
        Result = multiclass_metrics_common(C);
        Acc(n)=Result.Accuracy;
        F1_score(n)=Result.F1score;
        Precision(n)=Result.Precision;
        Recall(n)=Result.Recall;
        n=n+1;
    end
end
cpu_time = toc(tstart)/N_trials
mean_ACC = mean(Acc)
std_ACC = std(Acc)
mean_F1_score = mean(F1_score)
std_F1_score = std(F1_score)
mean_Precison = mean(Precision)
std_Precision = std(Precision)
mean_Recall = mean(Recall)
std_Recall = std(Recall)


% save G_classifier_normal_vs_early_vs_advanced_CR_7.mat mean_ACC std_ACC SubDim cpu_time...
% mean_F1_score std_F1_score mean_Precison std_Precision mean_Recall std_Recall
