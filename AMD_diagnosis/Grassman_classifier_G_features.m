% Grassman_classifier_G_features

clear
close all
addpath(genpath('.\measures\'));
addpath(genpath('.\MultiClassMetrics-ConfusionMatrix-main'));

%dimSubspace = 30;  % Subspace dimension for Grassmann representatives
N_trials = 100; % Geneate N_trials random partitionscpu

id = 0;
for dimSubspace = 10:10cl
    id = id+1;
    rng('default');  % for reproducibility

    tstart = tic;

    for n=1:N_trials

        % disease AMD class
        load G_features_AMD_CR_4
        ind=1:269; 
        G_features=abs(G_features(:,ind));
        % cd ..

        hpartition = cvpartition(size(G_features,2),'Holdout',0.3); % Nonstratified partition
        idxTrain = training(hpartition);
        idxTest = test(hpartition);
        G_train_AMD=G_features(:,idxTrain);
        G_test_AMD=G_features(:,idxTest);

        % Control healthy class
        % cd .\G_features_Suzhou
        load G_features_Control_CR_4
        ind=1:114; %[1:87 89:115];  % remove nonexisiting samples
        G_features=abs(G_features(:,ind));
        %cd ..

        hpartition = cvpartition(size(G_features,2),'Holdout',0.3); % Nonstratified partition
        idxTrain = training(hpartition);
        idxTest = test(hpartition);
        G_train_Control=G_features(:,idxTrain);

        G_test_Control=G_features(:,idxTest);

        clear G_features

        % Estimate orthonormal bases: Grassmann points
        XX = [G_train_Control G_train_AMD];
        TrainLabels = [ones(1,size(G_train_Control,2)) 2*ones(1,size(G_train_AMD,2))];
        [affinity_x, B_x, begB_x, enddB_x, mu_X]  = average_affinity(XX,TrainLabels,dimSubspace);

        X_test = [G_test_Control G_test_AMD];
        TestLabels = [ones(1,size(G_test_Control,2)) 2*ones(1,size(G_test_AMD,2))];

        % Testing
        for el=1:2
            X_testm = X_test - mu_X(:,el);    % make data zero mean for distance calculation
            BB=B_x(:,begB_x(el):enddB_x(el));
            Xproj = (BB*BB')*X_testm;
            Dproj = X_testm - Xproj;
            D(el,:) = sqrt(sum(Dproj.^2,1));
        end
        [~, TestLabels_est] = min(D);
        clear D X_test

        if numel(unique(TestLabels_est)) == 2
            %   Acc(n) = 1-computeCE(TestLabels_est,TestLabels);
            %   NMI(n) = compute_nmi(TestLabels_est-1,TestLabels-1);
            %   F1_score(n) = compute_f(TestLabels_est-1,TestLabels-1);

            C = confusionmat(TestLabels,TestLabels_est);
            Result = multiclass_metrics_common(C);       
            Acc(n)=Result.Accuracy
            F1_score(n)=Result.F1score;
            Precision(n)=Result.Precision;
            Recall(n)=Result.Recall;
            n=n+1;
        end
    end
    cpu_time(id) = toc(tstart)/N_trials
    SubDim(id)=dimSubspace
    mean_Acc(id) = mean(Acc)
    std_Acc(id) = std(Acc)
end

% display('Grassman classifier performance')
% mean_ACC=mean(ACC)
% std_ACC = std(ACC)
% mean_NMI = mean(NMI)
% std_NMI = std(NMI)
% mean_F1_score = mean(F1_score)
% std_F1_score = std(F1_score)

% dimSubspace=10:40;
% 
plot(SubDim,mean_Acc,'-sb')
grid
xlabel('Subspace dimension')
ylabel('Mean accuracy')



