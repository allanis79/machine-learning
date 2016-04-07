clear
clc
close all

x = xlsread('IROS_DATA2p2.xls');
x(:,1:5) = [];
y = xlsread('IROS_RESULTSp2.xls');
y = bincutoff(y,.8);
x = normalizeer(x);

[X,Y,T,AUC] = perfcurve(y',x',1);

%Best Fit line to polynomial data for ROC

xprime = X*cosd(-45)-Y*sind(-45);
yprime = X*sind(-45)+Y*cosd(-45);
pol = polyfit(xprime,yprime,2);
fit = polyval(pol,xprime);
[~,kstat] = max(fit);
fit = [xprime*cosd(45)-fit*sind(45) xprime*sind(45)+fit*cosd(45)];

plot(X,Y)
axis([0 1 0 1])
axis square
hold on
plot([0 1],[0 1])
plot(fit(:,1),fit(:,2))
hold off

disp('fpr')
disp(fit(kstat,1))

disp('tpr')
disp(fit(kstat,2))
