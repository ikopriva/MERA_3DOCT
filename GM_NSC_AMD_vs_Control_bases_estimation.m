% GM_NSC_AMD_vs_Control

clear
close all
addpath(genpath('.\measures\'));
addpath(genpath('.\MultiClassMetrics-ConfusionMatrix-main'));

N_trials = 10; % Geneate N_trials random partitions

id = 0;
for dimSubspace = 11:11
    id = id+1;
    rng('default');  % for reproducibility

    tstart = tic;

    for n=1:N_trials

        % disease AMD class
        load G_features_AMD_256_CR_2
        ind=1:269; 
        G_features=abs(G_features(:,ind));

        hpartition = cvpartition(size(G_features,2),'Holdout',0.3); % Nonstratified partition
        idxTrain = training(hpartition);
        idxTest = test(hpartition);
        G_train_AMD=G_features(:,idxTrain);
        G_test_AMD=G_features(:,idxTest);

        % Control healthy class
        load G_features_Control_256_CR_2
        ind=1:114; 
        G_features=abs(G_features(:,ind));
 
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
            if el == 1
                BB_control = BB;
                mu_control = mu_X(:,1);
            else
                BB_AMD = BB;
                mu_AMD = mu_X(:,2);
            end
            Xproj = (BB*BB')*X_testm;
            Dproj = X_testm - Xproj;
            D(el,:) = sqrt(sum(Dproj.^2,1));
        end
        [~, TestLabels_est] = min(D);
        clear D X_test

        if numel(unique(TestLabels_est)) == 2
            C = confusionmat(TestLabels,TestLabels_est);
            Result = multiclass_metrics_common(C);
            Acc(n)=Result.Accuracy;
            F1_score(n)=Result.F1score;
            Precision(n)=Result.Precision;
            Recall(n)=Result.Recall;
            n=n+1;
        end

        save Bases_AMD_Control_CR_2_d_11 BB_AMD BB_control mu_AMD mu_control
        return
    end
    cpu_time(id) = toc(tstart)/N_trials
    SubDim(id)=dimSubspace
    mean_Acc(id) = mean(Acc)
    std_Acc(id) = std(Acc)
end

plot(SubDim,mean_Acc,'-sb')
grid
xlabel('Subspace dimension')
ylabel('Mean accuracy')

save G_classifier_256_CR_2 mean_Acc std_Acc SubDim cpu_time


