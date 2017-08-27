function [TableOfNames, ArrOfValues] = Binarization(GrayTestImage)

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

    %10 Binarization by using local Otsu`s method %%% Slow performance %%%
    %BinarizedByAdaptT2 = LocalOtsuOp(GrayTestImage);
    
    %10.2  Binarization by using adaptive image threshold 2
    BinarizedByAdaptT2 = imbinarize(GrayTestImage, adaptthresh(GrayTestImage,...
       0.6, 'ForegroundPolarity', 'dark'));

%% ************** Constructor for all the bin. systems*********************
[TableOfNames, ArrOfValues] = Constructor(BinarizedByWolf, BinarizedByAdaptT, BinarizedBySau,...
    BinarizedByO, BinarizedByAdaptT2, BinarizedByNiblack, BinarizedByKittler,...
    BinarizedByBrensen, BinarizedByBradely, BinarizedByGatos);