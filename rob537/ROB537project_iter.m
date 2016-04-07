function [ minerror, bestnet, hval, aveerror, SEerror, avetest, SEtest ] = ROB537project_iter( inputs, targets, iter, hiddenvector )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
pererror = zeros(length(hiddenvector),iter);
testerror = zeros(length(hiddenvector),iter);
pererror = pererror+100; 
testerror = testerror+100; 
minerror = 100; 


for i = 1:length(hiddenvector)
    h = hiddenvector(i); 
    
    for j = 1:iter

        [ net, tr, testPerformance, percentErrors ] = ROB537project_classification( inputs, targets, h );
        
        testerror(i,j) = testPerformance; 
        pererror(i,j) = percentErrors;
        
        if percentErrors < minerror
           minerror = percentErrors;
           bestnet = net; 
           hval = hiddenvector(i);
        end
        
        if testPerformance < pererror
           pererror = testPerformance;
           testnet = net; 
           testh = hiddenvector(i);
        end
    end
end

aveerror = zeros(1,length(hiddenvector));
stderror = zeros(1,length(hiddenvector));

for i = 1:length(hiddenvector)
   aveerror(i) = mean(pererror(i,:));
   stderror(i) = std(pererror(i,:)); 
end

SEerror = stderror./(sqrt(iter)); 



avetest = zeros(1,length(hiddenvector));
stdtest = zeros(1,length(hiddenvector));

for i = 1:length(hiddenvector)
   avetest(i) = mean(minerror(i,:));
   stdtest(i) = std(minerror(i,:)); 
end

SEtest = stdtest./(sqrt(iter)); 


errorbar(hiddenvector,aveerror,SEerror)

figure(2)

subplot(1,2,1)
plot(1:iter,testerror(1,:))
title('test')
subplot(1,2,2)
plot(1:iter,100.*pererror(1,:))

end

