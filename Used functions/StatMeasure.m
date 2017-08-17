function Stat_Evaluation_Metrics = StatMeasure(TableOfNames, ArrOfValues)
% 
% Input: 
%   ArrOfValues - 3D array of all the binariszed images [Amount_Of_Images, 
%   Length, Width];
%   TableOfNames - 1D type 'cell' array with names of binarization applied
%   algorithms;
%
% Output: 
%   Stat_Evaluation_Metrics - table with summed marks for every 
%   clasification system given by statistically-based approach
%   (by pseudo-metrics) which are described in the article "Statistic 
%   Metrics for Evaluation of Binary Classifiers without Ground-Truth". 
%   https://hal.inria.fr/hal-01563615

ImNum = size (ArrOfValues, 1);

% [PROBARR] - Array of probabilities that every particular element on the 
% array belongs to foreground according to the all the classifiers
ProbArr(:,:) = sum(ArrOfValues,1);
ProbArr = ProbArr ./ ImNum;

SumPr = sum(sum(ProbArr));

 for k = 1:ImNum
     ImageIn(:,:) = ArrOfValues(k,:,:);
     
     SumSk = sum(sum(ImageIn));
     SumPrSk = sum(sum(ProbArr .* ImageIn));
     
     StRecall(k,1) = SumPrSk / SumSk;
     StPrecesion(k,1) = SumPrSk / SumPr;
     St_F1_score(k,1) = 100 * (2 * StRecall(k,1) * StPrecesion(k,1))/...
         (StRecall(k,1) + StPrecesion(k,1));
     
     StCrossCorr(k,1) = corr2(ImageIn, ProbArr);
     
     AltFN = sum(sum(ProbArr .* ~ImageIn));
     AltFP = sum(sum((1 - ProbArr) .* ImageIn));
     AltTN = sum(sum((1 - ProbArr) .* ~ImageIn));
     
     NR_FN = AltFN ./ (AltFN + SumPrSk); %Negative Rate of False Negative
	 NR_FP = AltFP ./(AltFP + AltTN); %Negative Rate of False Positive
	 StNRM(k,1) = (NR_FN + NR_FP) / 2; %Negative Rate Metric
     
    MSE = sum( sum((ImageIn - ProbArr).^2 )) / numel(ProbArr);
    C = 255;  % difference between foreground and background (possible to be 1)
    StPSNR(k,1) = 10 * log10(C^2 / MSE);
     
     BinName{k,1} = sprintf('%s', TableOfNames{k});
 end
 
% Later we will use [initial_code] symbols for calculating correlation of
% the order between statistically-based and GT-based evaluating results
initial_code(:,1) = (['A','B','C','D','E','F','G','H','I','J']);

Stat_Evaluation_Metrics = table(StRecall, StPrecesion, St_F1_score, StPSNR, StCrossCorr, StNRM,...
     initial_code, 'RowNames', BinName);
end