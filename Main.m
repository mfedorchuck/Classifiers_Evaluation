% # Description of the method in the article: "Statistic Metrics for
% # Evaluation of Binary Classifiers without Ground-Truth"
% # https://hal.inria.fr/hal-01563615
%
% Current program perform traditional evaluation metrics and statistically-based metrics for classifier evaluation.
% For correct work - indicate all of folders and subfolders in path!
% 
% The program performs next stages (1-4 in the loop - for every input image):
% 
% 	1 - opening the test image from graphics file;
% 	(For this project were used datasets from DIBCO 2009-2013 years. DIBCO - Digital Image Binarisation Contests, which were organised by ICDAR (International Conference of Digital Analysis and Recognition).
% 
% 	2 - applying 10 binarization algorithms for every image;
% 
% 	3 - Calculating traditional metrics for binarization algorithms, according to Ground Truth (subscribed data) and print the result;
% 
% 	4 - Calculating statistically-based metrics for binarization algorithms (without Ground Truth) and print the result;
% 	
% In the end:
%   6 - Calculate how good are not-traditionally used Pseudo-metrics according to the traditionally-based system (which use subscribed data - Ground Truth)
% (calculating average values through dataset):
% 
%    - Average sequence alignment cost between the order of classifiers (Statistically-based and GT-based order)
%    
%    - Average word-edit distance between the order of classifiers  (Statistically-based and GT-based order)
%    
%    - Average correlation of algorithm's order between the order given by:
%    
% 		F-Measure and Pseudo-F-Measure	%F1 Score (Garmonic mean of Recall and Precesion);
% 		PSNR and Pseudo-PSNR	% Peak Signal-Noise Rate;
% 		NCC and Pseudo-NCC	% Normalized Cross-Correlation;
% 		NRM and Pseudo-NRM % Negative Rate Metric;
%
% Feel free to use
% by : Maks Fedorchuk (mfedorchuck@gmail.com)

clear all; close all; clc;

fprintf('Time: %02s \n', datestr(now, 'HH:MM:SS')); fprintf('\n');
disp('DIBCO dataset 2009');

% path for test images
ImPath = sprintf('%s%s', pwd, '\TestData\DIBCO13\');
NumIm = 13;

for NumOfImage = 15:15
	fprintf('Case number %d in progress...\n', NumOfImage);

    ImName = sprintf('%d.bmp', NumOfImage);
    GTName = sprintf('%d.tiff', NumOfImage);

    TestImage = imread(sprintf('%s%s', ImPath, ImName));
    GTImage = imread(sprintf('%s%s', ImPath, GTName));

    GrayTestImage = rgb2gray(TestImage);
    [N, M] = size(GrayTestImage);

    fprintf('Size of current image is %d x %d \n', N, M);

    % All the 10 binary classifiers performs by function:
    [TableOfNames, ArrOfValues] = Binarization(GrayTestImage, NumOfImage);

%%  Displaying classifiers`s performance 
%     if NumOfImage == 1
%         BinDisp(TestImage, GrayTestImage, GTImage, TableOfNames, ArrOfValues);
%         fprintf('\nProgram paused. Press enter to continue.\n'); pause;
%     end

%%  Evaluation metrics 

% Ground-Truth based evaluation metrics
ComparizeGTTable = ComparisingWithGT(GTImage, TableOfNames, ArrOfValues);
SortedGTTable = sortrows(ComparizeGTTable, 'F1_score', 'descend');

% Statistically-based evaluation metrics
StatEvaluationTable = StatMeasure(TableOfNames, ArrOfValues);
SortedStatTable = sortrows(StatEvaluationTable, 'St_F1_score', 'descend');

if NumOfImage == 1
    fprintf('\n Best clasifiers according to Ground-Truth based evaluation metrics:\n');
    disp(SortedGTTable);

    fprintf('\n Best clasifiers according to Statistically based evaluation metrics:\n');
    disp(SortedStatTable);

    fprintf('\nProgram paused. Press enter to continue.\n'); pause;
end

%% Computing "word distance" and "sequence alignment cost"

Word_GT_FM(:) = SortedGTTable.initial_code;
Word_Ps_FM(:) = SortedStatTable.initial_code;

num_ind(:,1) = 1:10;
SortedGTTable.num = num_ind; SortedGTTable = sortrows(SortedGTTable, 'initial_code', 'ascend');
SortedStatTable.num = num_ind; SortedStatTable = sortrows(SortedStatTable, 'initial_code', 'ascend');

Ps_FM_Distance(NumOfImage) = SeqAlignCost(Word_Ps_FM, Word_GT_FM);
EditPS_FM_distance(NumOfImage) = EditDistance(Word_Ps_FM,Word_GT_FM);

%% Computing Correlation of marks & Correlation of order
OrdCorrPsFM(NumOfImage) = corr2(SortedGTTable.num, SortedStatTable.num);

CorrFM(NumOfImage) = corr2(ComparizeGTTable.F1_score, StatEvaluationTable.St_F1_score);
CorrPSNR(NumOfImage) = corr2(ComparizeGTTable.PSNR, StatEvaluationTable.StPSNR);
CorrNCC(NumOfImage) = corr2(ComparizeGTTable.CrossCorr, StatEvaluationTable.StCrossCorr);
CorrNRM(NumOfImage) = corr2(ComparizeGTTable.NRM, StatEvaluationTable.StNRM);

fprintf('Case number %d complete\n', NumOfImage);
fprintf('Time: %02s \n\n', datestr(now, 'HH:MM:SS'));
end

%% Displaying - how good proposed statistically-based method for classifier evaluation is
ResultsComparing(Ps_FM_Distance, EditPS_FM_distance, OrdCorrPsFM, NumIm);

fprintf('\n\n Average correlation of GT-based metrics & Pseudo-metrics:');
fprintf('\n\n given by F-Measure and Pseudo F-Measure: %.4g', sum(CorrFM) / NumIm);
fprintf('\n given by PSNR and Pseudo PSNR: %.4g', sum(CorrPSNR) / NumIm);
fprintf('\n given by NCC and Pseudo NCC: %.4g', sum(CorrNCC) / NumIm);
fprintf('\n given by NRM and Pseudo NRM: %.4g\n', sum(CorrNRM) / NumIm);
