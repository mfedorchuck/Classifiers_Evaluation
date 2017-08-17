function GT_Evaluation_Metrics = ComparisingWithGT(ImageGT, TableOfNames, ArrOfValues)
% Input: 
%   ArrOfValues - 3D array of all the binariszed images [Amount_Of_Images, 
%   Length, Width];
%   TableOfNames - 1D type 'cell' array with names of binarization applied
%   algorithms;
%
% Output: 
%   GT_Evaluation_Metrics - table with summed marks for every
%   classification algorithms, given by comparing syntesized Ground-Truth
%   and every particular classifier by traditionally-used metrics
%   (F1-score, Peack signal-noise rate, Normalised cross-correlation and
%   negative rate metric);

numvarargs = size(ArrOfValues, 1);

for i = 1:(numvarargs)
    ImageIn(:,:) = ArrOfValues(i,:,:);
    ImageGT = double(ImageGT); 

    BinName{i,1} = sprintf('%s', TableOfNames{i});

    N_TP = sum(sum(~ImageIn & ~ImageGT)); % True Positive
    N_FP = sum(sum(~ImageIn &  ImageGT)); % False Positive
    N_FN = sum(sum( ImageIn & ~ImageGT)); % False Negative
    N_TN = sum(sum( ImageIn &  ImageGT)); % True Negative

    Recall(i,1) = N_TP/ (N_FN + N_TP); % Recall
    Precesion(i,1) = N_TP/ (N_FP + N_TP); % Precesion
    
    % Harmonic mean of obtained Recall and Precesion (F1 score)
    F1_score(i,1) = (2 * Recall(i,1) * Precesion(i,1)) /...
        (Recall(i,1) + Precesion(i,1)) * 100; 
        
    C = 255; % Max. difference between foreground and background 
    MSE = sum( sum((ImageIn - ImageGT).^2)) / numel(ImageGT);
    PSNR(i,1) = 10*log10(C^2/ MSE); % Peack signal-noise rate
    
    CrossCorr(i,1) = corr2(ImageIn, ImageGT); % Cross correlation 
    
    NR_FN = N_FN ./ (N_FN + N_TP); %Negative Rate of False Negative
    NR_FP = N_FP ./ (N_FP + N_TN); %Negative Rate of False Positive
    NRM(i,1) = (NR_FN + NR_FP) / 2; %Negative Rate Metric
    
end

% Later we will use [initial_code] symbols for calculating correlation of
% the order between statistically-based and GT-based evaluating
initial_code(:,1) = (['A','B','C','D','E','F','G','H','I','J']);

GT_Evaluation_Metrics = table(Recall, Precesion, F1_score, PSNR, CrossCorr, NRM,...
     initial_code, 'RowNames', BinName);
end