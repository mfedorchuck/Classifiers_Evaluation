%   The follow program perform next stages (in the loop for all the images):
%
%   1 - open the test image from graphics file;
%
%   2 - apply 10 binarization algorithms for every image;
%
%   3 - Calculate and print the table with applied traditional metrics for
%   binarization algorithms, according to Ground Truth;
%
%   4 - Calculate and print the table with applied statistically-based
%   metrics for binarization algorithms (without Ground Truth);
%
%   5 - Calculate the order of classifiers from best to worsed by using
%   Reference Method;
%
%   6 - Calculate how good not-traditionally used evaluation systems 
%   (Pseudo-metrics and proposed Reference method ) are good by 
%   calculating (average values through dataset):
%   - Average sequence alignment cost between the order of classifiers 
%   - Average word-edit distance between the order of classifiers  
%   - Average correlation of algorithm`s order between the order given by 
%   F-Measure and statistically-based approaches

clear all; close all; clc;

fprintf('Time: %02s \n', datestr(now, 'HH:MM:SS')); fprintf('\n');
disp('DIBCO dataset 2009');

% number of images you want to test
NumIm = 10; %DIBCO09 dataset consist of 10 images - 5 printed and 5 - handwritten

% path for test images
ImPath = sprintf('C:/From DropBox/Code and Description/Data_For_Test/DIBCO09/');

for NumOfImage = 1:NumIm
   fprintf('Case number %d in progress...\n', NumOfImage);

    ImName = sprintf('%d.bmp', NumOfImage);
    GTName = sprintf('%d.tiff', NumOfImage);

    TestImage = imread(sprintf('%s%s', ImPath, ImName));
    GTImage = imread(sprintf('%s%s', ImPath, GTName));

    GrayTestImage = rgb2gray(TestImage);
    [N, M] = size(GrayTestImage);

    fprintf('Size of current image is %d x %d \n', N, M);

    %1 Binarization By Otsu`s method   
    BinarizedByO = imbinarize(GrayTestImage, graythresh(GrayTestImage));  

    %2 Binarization by using Sauvola method
    BinarizedBySau = sauvola(GrayTestImage, [150 150]);     

    %3 Binarization by using Wolf method
    BinarizedByWolf = wolf(GrayTestImage, [100 100]);       

    %4 Binarization by using Bernsen method
    BinarizedByBrensen = bernsen(GrayTestImage, [3 3], 128);

    %5 Binarization by using Kittler method
    [Trashh, Minn] = kittlerMinimimErrorThresholding(GrayTestImage); 
    BinarizedByKittler = imbinarize(GrayTestImage, Trashh / 255); 

    %6 Binarized by using Niblack method
    BinarizedByNiblack = niblack(GrayTestImage, [151 151], -0.2, 25);

    %7 Binarization by using Bradley method
    BinarizedByBradely = bradley(GrayTestImage, [25 25]);

    %8 Binarization by using Gatos method
    [BinarizedByGatos, Background_Gatos] = BinarizationGatos(GrayTestImage);

    %9  Binarization by using adaptive image threshold 
    BinarizedByAdaptT = imbinarize(GrayTestImage, adaptthresh(GrayTestImage,...
       'ForegroundPolarity', 'dark'));

    %10 Binarization by using adaptive image threshold
    BinarizedByAdaptT2 = imbinarize(GrayTestImage, adaptthresh(GrayTestImage,...
       0.7, 'ForegroundPolarity', 'dark'));

%% ************** Constructor for all the bin. systems*********************
[TableOfNames, ArrOfValues] = Constructor(BinarizedByWolf, BinarizedByAdaptT, BinarizedBySau,...
    BinarizedByO, BinarizedByAdaptT2, BinarizedByNiblack, BinarizedByKittler,...
    BinarizedByBrensen, BinarizedByBradely, BinarizedByGatos);

%% **************** Displaying of system`s performance  *******************
% BinDisp(TestImage, GrayTestImage, GTImage, TableOfNames, ArrOfValues);

%% ************************* Evaluation metrics ***************************

% Ground-Truth based evaluation metrics
ComparizeGTTable = ComparisingWithGT(GTImage, TableOfNames, ArrOfValues);
fprintf('\n Best clasifiers according to Ground-Truth based evaluation metrics:\n');
disp(sortrows(ComparizeGTTable,'F1_score','descend'));

% Statistically-based evaluation metrics
StatEvaluationTable = StatMeasure(TableOfNames, ArrOfValues);
fprintf('\n Best clasifiers according to Statistically based evaluation metrics:\n');
disp(sortrows(StatEvaluationTable,'St_F1_score','descend'));

% BinarizedByWolf, BinarizedByAdaptT, BinarizedBySau,...
%     BinarizedByO, BinarizedByAdaptT2, BinarizedByNiblack, BinarizedByKittler,...
%     BinarizedByBrensen, BinarizedByBradely, BinarizedByGatos);

[RefArr, AlternativeRefArr] = CompByRef(ArrOfValues);

%disp('GT based measurements:'); disp(ComparizeGTTable);
%disp('Statistically-based measurements:'); disp(StatEvaluationTable);

% writetable(ComparizeGTTable, 'testdata.xlsx', 'Sheet', NumOfImage, 'Range', 'A2', 'WriteRowNames', 1);
% writetable(StatEvaluationTable, 'testdata.xlsx', 'Sheet', NumOfImage, 'Range', 'I2', 'WriteRowNames', 1);

% disp('best clasifiers according to Pseudo-Metrics'); disp(SortedStatTable(:,:));
% disp('best clasifiers according to GT'); disp(SortedGTTable(:,:));

%% Extract ranged array by usimg RefMetrics, Pseudo-metrics and GT-based metrics

NewRefAltArr(:,:) = zeros(10);

for ii = 1:length(TableOfNames)
        TwoDrefAltArr(:,:) = AlternativeRefArr(ii,:,:);
        NewRefAltArr(:,:) = TwoDrefAltArr(:,:) + NewRefAltArr(:,:); 
end

for jj = 1:length(TableOfNames)
    NewRefAltArr(jj,length(TableOfNames) + 1) = sum(NewRefAltArr(jj,:));
end

%% Tables construction

initial_code(:,1) = (['A','B','C','D','E','F','G','H','I','J']);
abc2(:,1) = 1:10;

T_AltRef = table(NewRefAltArr(:, length(TableOfNames) + 1), initial_code,...
    'RowNames', TableOfNames); %abc2,

SortedStatTable = sortrows(StatEvaluationTable, 'St_F1_score', 'descend');
SortedGTTable = sortrows(ComparizeGTTable, 'F1_score', 'descend');
SortedAltRef = sortrows(T_AltRef, 'Var1', 'descend');

Word_GT_FM(:) = SortedGTTable.initial_code;
Word_Ps_FM(:) = SortedStatTable.initial_code;
Word_AltRef(:) = SortedAltRef.initial_code;

SortedGTTable.num = abc2(:); SortedGTTable = sortrows(SortedGTTable, 'initial_code', 'ascend');
SortedStatTable.num = abc2(:); SortedStatTable = sortrows(SortedStatTable, 'initial_code', 'ascend');
SortedAltRef.num = abc2(:); SortedAltRef = sortrows(SortedAltRef, 'initial_code', 'ascend');

%% Comparing words distance of methods

Ps_FM_Distance(NumOfImage) = SeqAlignCost(Word_Ps_FM, Word_GT_FM);
Alt_Ref_Distance(NumOfImage) = SeqAlignCost(Word_AltRef, Word_GT_FM);

EditPS_FM_distance(NumOfImage) = EditDistance(Word_Ps_FM,Word_GT_FM);
EditARef_distance(NumOfImage) = EditDistance(Word_AltRef,Word_GT_FM);

%% Correlation of marks

OrdCorrPsFM(NumOfImage) = corr2(SortedGTTable.num, SortedStatTable.num);
OrdCorrAltRef(NumOfImage) = corr2(SortedGTTable.num, SortedAltRef.num);

PlaineCorrPsFM(NumOfImage) = corr2(ComparizeGTTable.F1_score, StatEvaluationTable.St_F1_score);

clear NewRefAltArr
clear TwoDrefAltArr

fprintf('Case number %d complete\n', NumOfImage);
fprintf('Time: %02s \n\n', datestr(now, 'HH:MM:SS'));
end

    DIBCO = 1; %Equal one only if you test only one dataset
    
    disp('*************** Average sequence alignment cost through dataset ***************');
    AvPsFMDistance(DIBCO) = sum(Ps_FM_Distance, 'omitnan') / NumIm;
    AvAltRefDistance(DIBCO) = sum(Alt_Ref_Distance, 'omitnan') / NumIm;
    
    fprintf('\nAverage sequence alignment cost between order given by F-Measure and Pseudo F-Measure: %.4g \n', AvPsFMDistance(DIBCO));
    fprintf('Average sequence alignment cost between order given by F-Measure and Reference Method: %.4g \n', AvAltRefDistance(DIBCO));
    
    disp('*************** Average word-edit distance through dataset ***************');
    AvRefWordDistance(DIBCO) = sum(EditPS_FM_distance, 'omitnan') / NumIm;
    AvPsFMWordDistance(DIBCO) = sum(EditARef_distance, 'omitnan') / NumIm;
    
    fprintf('\nAverage word-edit distance between order given by F-Measure and Pseudo F-Measure: %.4g \n', AvRefWordDistance(DIBCO));
    fprintf('Average word-edit distance between order given by F-Measure and Reference Method: %.4g \n', AvPsFMWordDistance(DIBCO));
    
    disp('*************** Average correlation of algorithm`s order through dataset ***************');
    AvgCorrelationOfPsFM(DIBCO) = sum(OrdCorrPsFM, 'omitnan') / NumIm;
    AvgCorrCorrAltRefGT(DIBCO) = sum(OrdCorrAltRef, 'omitnan') / NumIm;
    
    fprintf('\nAverage correlation of algorithm`s order between order given by F-Measure and Pseudo F-Measure: %.4g \n', AvgCorrelationOfPsFM(DIBCO));
    fprintf('Average correlation of algorithm`s order between order given by F-Measure and Reference Method: %.4g \n', AvgCorrCorrAltRefGT(DIBCO));
        
%     disp('*************** Average correlation of algorithm`s marks ***************');
%     AvCorrMarksPsFM(DIBCO) = mean(PlaineCorrPsFM, 'omitnan');
%     AvCorrMarksRef(DIBCO) = mean(PlaineCorrRefGT, 'omitnan');
%     AvCorrMarksGTRef(DIBCO) = mean(PlaineCorrAltRefGT, 'omitnan');