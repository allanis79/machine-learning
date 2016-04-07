function Lpred = myBayesPredict(Dtrain, Ltrain, Dtest,opt)
% Multi-class classification using Bayesian Decision Theory
% Function Input:
% Dtrain: training dataset, each row is a feature vector of a training sample
% Ltrain: class labels of training samples
% Dtest: testing dataset
% opt: classification options
%if opt==1, use Naive Bayes
%if opt==2, use posterior probability as discriminant function
%if opt==3, use the derived formula based on multivariate normal distribution
% Function Output:
% Lpred: predicted class labels for the testing samples in Dtest

%% HW# Problem 1: use Naive Bayes to make classification

if opt == 1
    % training happens here
    nb = NaiveBayes.fit(Dtrain,Ltrain);
    % prediction happens here
    Lpred = nb.predict(Dtest);
    
    
end

if opt == 2
    C = unique(Ltrain);
    Lpred =[];
    for iC = 1:length(C)
        %c1 = C(iC);
        %c1 = cell2mat(c1);
        idx=[];
        if iC == 1
            for i = 1:length(Ltrain)
                v = strcmp(Ltrain(i),'setosa');
                idx =[idx;v];
            end
        
        elseif iC == 2
            for i = 1:length(Ltrain)
                v = strcmp(Ltrain(i),'versicolor');
                idx =[idx;v];
            end
        
        elseif iC == 3
            for i = 1:length(Ltrain)
                v = strcmp(Ltrain(i),'virginica');
                idx =[idx;v];
            end
        end
        idx = find(idx);
        data = Dtrain(idx,:);
        mu = mean(data);
        sigma = cov(data);
        P = length(idx)/length(Ltrain);
        for j = 1:size(Dtest,1)
            x = Dtest(j,:);
            likelihood = mvnpdf(x,mu,sigma);
            prior = P;
            G(iC,j) = likelihood*prior;
        end
    end
    [~, pred] = max(G)
    Lpred = C(pred);
end

    