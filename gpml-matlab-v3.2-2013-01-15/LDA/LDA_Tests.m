clear
clc
%data = xlsread('mydata_2.csv');
data = xlsread('FinalData.csv');
testnum = 475;

% Make the results = 0 if it is NaN
for v = (2:526)
    if isnan(data(v,34))
        data(v,34) = 0;
    end
end
% Save GraspIt epsilon and autograsp quality to separate array
num = 1;
for k=2:526
   if data(k,11) > -100
       D(num, 1) = data(k,11);
       D(num, 2) = data(k,13);
       D(num, 3) = data(k,35);
       D(num, 4) = data(k,34);
       num = num + 1;
   else
       data(k,11) = NaN;
       data(k,13) = NaN;
   end
end

% Spherize data
%data2 = data(2:526,1:13);
%data(2:526,1:13) = spherize(data2);
%D(:,1:2) = spherize(D(:,1:2));


% Spherize data
data2 = data(2:526,1:13);
data(2:526,1:13) = spherize(data2);
newdata = data(2:526,1:10);
newdata(:,11) = data(2:526,12);
D(:,1:2) = spherize(D(:,1:2));

% Split data into successful and unsuccessful matrices
s = 1;
f = 1;
for l = (1:testnum)
    if data(l+1,34) >= 8
        SucData(s,1:11) = newdata(l,1:11);
        SucD(s,1) = data(l+1,34);
        s = s + 1;
    else
        FailData(f,1:11) = newdata(l,1:11);
        FailD(f,1) = data(l+1,34);
        f = f + 1;
    end
end
validate_data = newdata(testnum+1:525,:);
validate_data2(:,1) = newdata(testnum+1:525,1);
validate_data2(:,2:4) = newdata(testnum+1:525,3:5);
validate_data2(:,5) = newdata(testnum+1:525,7);
SuccessR = [SucD;FailD];
s = 1;
f = 1;

%for l = (1:length(D(:,1)) )
%    if D(l,4) >= 8
%        SucD(s,:) = D(l,1:2);
%        s = s + 1;
%    else
%        FailD(f,:) = D(l,1:2);
%        f = f + 1;
%    end
%end
NumGood = length(SucData(:,1));
NumBad = length(FailData(:,1));

%X2 = [SucData(:,1); FailData(:,1)];
%X2(:,2:4) = [SucData(:,3:5); FailData(:,3:5)];
%X2(:,5) = [SucData(:,7); FailData(:,7)];
X = [SucData; FailData];  
Y = [ones(NumGood,1); zeros(NumBad,1)];
Total = length(X(:,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  Perform tests %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W = LDA(X,Y);  % Gives two lines for determining the category 
[w,t,fp] = fisher_training(X,Y); % Gives one axis which is most discriminatory
%[w2,t2,fp2] = fisher_training(X,Y);

beta = mvregress(X,SuccessR); % Multivariable regression line
%[V,d] = SVDA(X,Y,5,.05);  % Does not work without Bioinformatics Toolbox

% Returns n number of axes which have high discrimination capabilities
[ V, eigvalueSum ] = fld( X, Y, 6, 1, 'false', 0, .001, 100 ); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% GP training %%%%%%%%%%%%%%%%%%%
index = 1:length(SuccessR(:,1));
%[aucave,aucerr,ave,upper,lower,kstat,meantpr,meanfpr] = gptrainandtest(X, SuccessR, index', SuccessR , 300, 20, 8);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class = zeros(Total, 1 );
for i = 1:Total
   %val(1:2,i) = W(:,1) + W(:,2:12) * transpose(X(i,:));
   %ans = W(:,2:12) .* transpose(X(i,:));
   if t < fp(i)
       class(i,1)=10;
   end
   
end


TP = 0;
FP = 0;
TN = 0;
FN = 0;
TP2 = 0;
FP2 = 0;
TN2 = 0;
FN2 = 0;

for i = 1:Total
   if class(i,1) >= 8 && data(i+1,34) >= 8 
       TP = TP + 1;
   elseif class(i,1) < 8 && SuccessR(i,1) >= 8 
       FN = FN + 1;
   elseif class(i,1) >= 8 && SuccessR(i,1) < 8 
       FP = FP + 1;
   elseif class(i,1) < 8 && SuccessR(i,1) < 8 
       TN = TN + 1;
   end
end
TPR = TP / (TP + FN)
FPR = FP / (FP + TN)
%figure(1)
%clf
%scatter(val(1,1:378),val(2,1:378),'bo')
%scatter(val(2,1:378),class(1:378,1),'bo')
%hold on
%scatter(val(1,379:525),val(2,379:525),'rx')
%scatter(val(2,379:525),class(379:525,1),'rx')

figure(2)
clf
scatter(fp(1:NumGood,1),SuccessR(1:NumGood,1),'bo')
hold on
scatter(fp(NumGood+1:Total,1),SuccessR(NumGood+1:Total,1),'rx')


% Validate the LDA

for i = 1:length(validate_data(:,1))
   %val(1:2,i) = W(:,1) + W(:,2:12) * transpose(X(i,:));
   %ans = W(:,2:12) .* transpose(X(i,:));
   if data(i+testnum+1,34) >= 8
       results(i,1) = 1;
   else
       results(i,1) = 0;
   end
end
[l,precision,recall,accuracy,F1]=fisher_testing(validate_data,w,t,results,1);

scores = validate_data * w;
figure(3)
clf
scatter(scores(:,1),data(testnum+2:526,34),'bo')

MVscores = validate_data*beta;
figure(4)
clf
scatter(MVscores,data(testnum+2:526,34))

% FLD validation

FLD_Scores = validate_data * V;


%EOF

