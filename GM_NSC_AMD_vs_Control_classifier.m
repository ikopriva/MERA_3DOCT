% GM_NSC_AMD_vs_Control_Classifier

clear
close all
addpath(genpath('.\measures\'));
addpath(genpath('.\MultiClassMetrics-ConfusionMatrix-main'));

N_trials = 10; % Choose randomly control and AMD feature vectors and classify them

load Bases_AMD_Control_CR_2_d_11.mat

BB = [BB_control BB_AMD];
mu_X = [mu_control mu_AMD];

% disease AMD class
load G_features_AMD_256_CR_2
ind= 1:269;
G_test_AMD=abs(G_features(:,ind));

% Control healthy class
load G_features_Control_256_CR_2
ind=1:114;
G_test_Control=abs(G_features(:,ind));

clear G_features

X_test = [G_test_Control G_test_AMD];
TestLabels = [ones(1,size(G_test_Control,2)) 2*ones(1,size(G_test_AMD,2))];

% Testing
for el=1:2
    X_testm = X_test - mu_X(:,el);    % make data zero mean for distance calculation
    Xproj = (BB*BB')*X_testm;
    Dproj = X_testm - Xproj;
    D(el,:) = sqrt(sum(Dproj.^2,1));
end
[~, TestLabels_est] = min(D);
%clear D X_test

C = confusionmat(TestLabels,TestLabels_est);
Result = multiclass_metrics_common(C)
Acc=Result.Accuracy
F1_score=Result.F1score
Precision=Result.Precision
Recall=Result.Recall

% save G_classifier_256_CR_2 mean_Acc std_Acc SubDim cpu_time


