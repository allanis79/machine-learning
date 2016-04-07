clc


clear all, close all

load aucPCw5heur.mat


auc = auc(:,1)

meanave = mean(auc)

stand = std(auc)

sterr = stand/length(auc)^.5

tprave = mean(tpr(:,1))

fprave = mean(fpr(:,1))