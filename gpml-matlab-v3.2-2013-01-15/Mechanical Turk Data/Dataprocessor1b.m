%Grasp Testing Data Comparison to Mechanical Turk Data
%
%
%----------Document History----------------
%Version  Modified Date    By                      Notes    
%   A     3FEB13           Ryan Carpenter          Original
%
%

clear
clc
close all

%----------Define Variables----------------

control = [8 18 28 38 48 58 68 78 88];          %control grasps
ctrl_rsp1 = .3;                                 %minimum answer on control test to accept data

%Graspit Data
grspit = xlsread('graspout.csv');
addpath('Z:\Windows.Documents\Desktop\GPFilter\gpml-matlab-v3.2-2013-01-15')  %HAS ROC FUNCTION BUILT IN


grspitnorm(:,1) = grspit(:,1);
for i = 2:length(grspit(1,:))
    temp = (grspit(:,i)-min(grspit(:,i)));
    grspitnorm(:,i) = temp./max(temp);
end

%Mechanical Turk Data + Grasp Data
mtur = xlsread('mechturkrawdata.csv');
mturct = length(mtur(:,1));
grasp = unique(mtur(:,1));

%----------Average Complete Data--------------------

%send to function file

%  Grasp No - Physical - rating - percieved success - expirimental
compdata = matave([mtur(:,1) mtur(:,2) mtur(:,9) mtur(:,10) mtur(:,11)]);

%----------Filter Data---------------------

%Identify control tests
index = ismember(mtur(:,1),control);
index = find(index);
temp = 1;
for i = 1:length(index)
    if mtur(index(i),9)>ctrl_rsp1
        blklst(temp) = mtur(index(i),3);
        temp = temp+1;
    end
end
blklst = unique(blklst);    %remove duplicates
whtlst = unique(mtur(:,3));
temp = ismember(whtlst,blklst);
whtlst = unique(temp.*whtlst);
whtlst = whtlst(2:length(whtlst));
filter1 = ismember(mtur(:,3),whtlst);
filter1 = filter1.*mtur(:,1);
filter1 = [filter1 mtur(:,2:length(mtur(1,:)))];
temp = 1;
%remove filtered rows
for i = mturct:-1:1
    if filter1(i,1) == 0
        filter1(i,:) = [];
    end
end
%Average Filtered Data
filtdata1= [filter1(:,1) filter1(:,9) filter1(:,11)];





%Survey options for x and y cutoffs ROC Curve Generation
[ccritmtur,fitmtur,statmtur] = roc(.8,.001,filtdata1(:,3),filtdata1(:,2));



% fprintf('Criteria      FN        FP        TN        TP       FPR      TPR\n')
% disp(ccrit(:,:))
% fprintf('\n\nOptimum FPR:  ')
% disp(ccrit(kstat))

%----------ROC Analysis---------------------
%Area under curve
AUCprep = [ccritmtur(:,6) ccritmtur(:,7) ccritmtur(:,1)];
AUCprep = sort(AUCprep,1);
AUC = 0;
for i = 1:length(AUCprep)-1
    AUC = AUC + (AUCprep(i+1,1)-AUCprep(i,1))*mean([AUCprep(i,2) AUCprep(i+1,2)]);
end
    
fprintf('\n\nAUC mechanical turk:  ')

disp(AUC)



%Angular minimum Distance
%[~,angular]=min((ccrit(:,6).^2+(1-fit).^2).^.5);

% fprintf('\n\nAngular:  ')
% disp(ccrit(angular,6))

gaus = xlsread('dataoutnorm.csv');

% fprintf('\n\n Average Standard Deviation:  ')
% disp(mean(filtstdev(:,3)))
% 
% fprintf('\n\n SD of SD:  ')
% disp(std(filtstdev(:,3)))
% 
% fprintf('\n\n Standard Error:  ')
% disp(mean(filtsterr(:,3)))



%--------------------------------------------
%-----------Graph Results--------------------
%--------------------------------------------

% [~,kstat] = max(yprime);



% subplot(2,1,1)
%ROC GRAPH
plot(ccritmtur(:,6),ccritmtur(:,7),'-k','linewidth',2)
hold on
plot([0 1],[0 1],'Color',[.25 .25 .25])

% plot([ccritmtur(statmtur,6) ccritmtur(statmtur,6)+2],[fit(statmtur) fit(statmtur)-2],'g')
legend('Mechanical Turk Data','Epsilon', 'Volume','Random Guess',4)
hold off
xlabel('False Positive Rate')
ylabel('True Positive Rate')
title('ROC Space Normalized Grasp Data')
axis([0 1 0 1])
axis square

xlswrite('rocmtur.csv',ccritmtur(:,6:7))
xlswrite('rocmturfit.csv',fitmtur)
xlswrite('rocinter.csv',statmtur)


% subplot(2,1,2)
% plot(fitmtur(:,1),fitmtur(:,2),'-','linewidth',2)
% hold on
% plot(fitvol(:,1),fitvol(:,2),'-.','linewidth',1.5)
% plot(fiteps(:,1),fiteps(:,2),'--','linewidth',.75)
% plot([0 1],[0 1],'r')
% hold off
% title('ROC Space Normalized Grasp Data')
% xlabel('False Positive Rate')
% ylabel('True Positive Rate')
% axis([0 1 0 1])
% axis square


% subplot(2,1,2)% % Filtered Data
% rectangle('Position',[cgrcrit,cmtcrit,1-cgrcrit,1-cmtcrit],'facecolor','r')
% hold on
% rectangle('Position',[0,0,cgrcrit,cmtcrit],'facecolor','g')
% plot(filtdata1(:,5),filtdata1(:,3),'.')
% text(.1,.1,'True Negative')
% text(.1,.9,'False Positive')
% text(.9,.9,'True Positive')
% text(.9,.1,'False Negative')
% hold off
% xlabel('Experimental Results')
% ylabel('Mech. Turk Grasp Rating')
% title('Averaged, Filtered Data at Fixed Criteria')

% plot3(ccrit(:,1),ccrit(:,2),ccrit(:,7),'.')
% axis([0 1 0 1 0 5])

% 
% subplot(2,3,3)
% 
% subplot(2,3,4)
% 
% subplot(2,3,5)
% 
% subplot(2,3,6)
