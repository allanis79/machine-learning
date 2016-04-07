clc,clear all

load fisheriris

%Dtrain = meas(1:100,:);
%Ltrain = species(1:100);
%Dtest = meas(101:150,:);
%Ltest = species(101:150);
opt = 2;

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