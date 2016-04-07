function [ccrit,fit,kstat,AUC] = roc(criteria,step,data1,data2)

% %Troubleshooting
% criteria = .8
% step = .001
% data1 =[0.0092 0 0.0194 0 0 0.0009 0 0 0 0 0.0362 0.0050 0.0102];
% data2 =[1.0000 1.0000 1.0000 1.0000 0 0.6300 0.6300 0 0 0 1.0000 1.0000 1.0000];

ccrit = zeros((1/step),7);
reset = zeros(1,7);
incr = 1;

for j = 0:step:1
    temp = reset;
    [~,~,~,~,temp] = truefalse([data1 data2],criteria,j);
    P1 = temp(1,1)+temp(1,4);
    P2 = temp(1,2)+temp(1,3);
    % step  xx xx xx xx xx xx
    ccrit(incr,:) = [j temp(1,:) temp(1,2)/P2 temp(1,4)/P1];
    incr = incr+1;
end


%Best Fit line to polynomial data for ROC

xprime = ccrit(:,6)*cosd(-45)-ccrit(:,7)*sind(-45);
yprime = ccrit(:,6)*sind(-45)+ccrit(:,7)*cosd(-45);
pol = polyfit(xprime,yprime,2);
fit = polyval(pol,xprime);
[~,kstat] = max(fit);
fit = [xprime*cosd(45)-fit*sind(45) xprime*sind(45)+fit*cosd(45)];

%AUC
AUCprep = [ccrit(:,6) ccrit(:,7) ccrit(:,1)];
AUCprep = sort(AUCprep,1);
AUC = 0;
for i = 1:length(AUCprep)-1
    AUC = AUC + (AUCprep(i+1,1)-AUCprep(i,1))*mean([AUCprep(i,2) AUCprep(i+1,2)]);
end

