function [ aveerror, stderror, avetest, stdtest  ] = ROB537project_inputs( inputs, targets, layersremoved, iter )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
 
testperf = zeros(layersremoved,iter);
testperf = testperf + 100; 

pererrors = zeros(layersremoved,iter);
pererrors = pererrors + 100; 

    
for i = 1:layersremoved
    
    numlayers = 7+1-i;
    
    
    numinputs = [inputs(1:49-(i-1)*7,:); inputs(50:98-(i-1)*7,:)];
    
    h = (6+length(numinputs(:,1)))/2;
    
    show = ['Layers used: ', num2str(numlayers), '. Hidden units: ', num2str(h)];
    disp(show)
    
    for j = 1: iter
    
        [ net, tr, testPerformance, percentErrors ] = ROB537project_classification( numinputs, targets, h );
        
        testperf(i,j) = testPerformance;
        pererrors(i,j) = percentErrors; 
        
    end
end

aveerror = zeros(1,layersremoved);
stderror = zeros(1,layersremoved);

for i = 1:layersremoved
   aveerror(i) = mean(pererrors(i,:));
   stderror(i) = std(pererrors(i,:)); 
end

SEerror = stderror./(sqrt(iter)); 

aveerror = 100.*aveerror; 
SEerror = 100.*SEerror; 

%----------------------------------------
avetest = zeros(1,layersremoved);
stdtest = zeros(1,layersremoved);

for i = 1:layersremoved
   avetest(i) = mean(testperf(i,:));
   stdtest(i) = std(testperf(i,:)); 
end

SEtest = stdtest./(sqrt(iter)); 

%-------------------------------------------

x1 = 8-(1:layersremoved);

errorbar(x1,aveerror,SEerror)
title('num decom layers vs. total misclass')
ylim([0 ceil(max(aveerror))+2])
ylabel('% missclassified')

figure(2)
errorbar(x1,avetest,SEtest)
title('num decom layers vs. test error')
ylim([0 ceil(max(avetest))+2])
ylabel('% missclassified')
 
end

