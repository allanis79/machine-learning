clc,clear all

%{
This is for problem one. As mentioned in the quesitoned here we used 5 fold
crossvalidation.
Confusion matrix will also gives you the prediction accuracy.
Just hit 'Run' in the editor window,everything will run.
%}

load fisheriris

%Dtrain = meas(1:100,:);
%Ltrain = species(1:100);
%Dtest = meas(101:150,:);
%Ltest = species(101:150);
opt = 1;

indices = crossvalind('Kfold',species,5);
for i = 1:5
    test =(indices ==i);
    train = ~test;
    prediction = myBayesPredict(meas(train,:),species(train,:),meas(test,:),opt);
    disp(prediction)
    %confusion matrix
    [c order] = confusionmat(species(test,:),prediction);
    disp(c)
    disp(order)
end