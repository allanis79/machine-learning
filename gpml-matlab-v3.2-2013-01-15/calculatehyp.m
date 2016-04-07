function [hyp] = calculatehyp(x,y,index,groundtruth,loopn,cutoff)
%Version 1 - Corrected error at 86
%Version 0 - Initial Creation 29AUG13 from remnents of code used in Humanoids paper
%This function pulls data in, optimizes and builds a GP on it, and exports
%evaluative properties.


% %%
% %For Troubleshooting
% x = data;
% y = results1;
% loopn = 100;
% index = (1:length(results1))';

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------Functions SELECTION------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meanfunc = @meanConst;
covfunc = @covSEard;
likfunc = @likGauss;
inffunc = @infExact;  %%CHANGING THIS WILL CHANGE OTHER THINGS, function lengths not computed for this

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Iterate and average hyperparameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%auc = zeros(1,loopn);
%fpr = auc;
%tpr = auc;

%binshakeresults = bincutoff(groundtruth,cutoff);

xdepth = length(x(1,:));

%-----define input function lengths-----

%    ---cov function depths---
if strcmp('covRQard',char(covfunc))==1
    covdepth = xdepth+2;
elseif strcmp('covSEard2',char(covfunc))==1
    covdepth = xdepth+1;
elseif strcmp('covSEard',char(covfunc))==1
    covdepth = xdepth+1;
end

%    ---mean function depths---
if strcmp('meanConst',char(meanfunc))==1
    meandepth = 1;
end

%    ---likfuncdepths---
if strcmp('likGauss',char(likfunc))==1
    likdepth = 1;
end

covfunc = @covSEard;

%mfout = [];
%indexout = [];

for l = 1:loopn

    hyp = [];

    %Train Hyperparameters

    %Define leave out percent
    [trainx, trainy, trainind] = leavetrain(x,y,index);

    hyp.mean = zeros(meandepth,1);
    hyp.cov(1:covdepth) = log(1);
    hyp.lik(1:likdepth) = -.2;

    %%%%%%%CHANGE ITER TO 1000!!!!%%%%%%%%%%
    hyp = minimize(hyp, @gp, -900, inffunc, meanfunc, covfunc, likfunc, trainx, trainy);

    hyptemp = [hyp.cov 0 0 0 0 0 0 0 0 0 0 0 0];
    hyptemp = hyptemp(1:12);





end