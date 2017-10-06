function [TableOfNames, ArrOfValues] = Binarization(GrayTestImage, NumOfImage)

 %1 Binarization By Otsu`s method   
    BinarizedByO = imbinarize(GrayTestImage, graythresh(GrayTestImage));  
    filename = sprintf('BinarizedByO_%d.png',NumOfImage);
    imwrite(BinarizedByO,filename);
    %2 Binarization by using Sauvola method
    BinarizedBySau = sauvola(GrayTestImage, [150 150]);     
    filename = sprintf('BinarizedBySau_%d.png',NumOfImage);
    imwrite(BinarizedBySau,filename);
    
    %3 Binarization by using Wolf method
    BinarizedByWolf = wolf(GrayTestImage, [100 100]);       
    filename = sprintf('BinarizedByWolf_%d.png',NumOfImage);
    imwrite(BinarizedByWolf,filename);
    
    %4 Binarization by using Bernsen method
    BinarizedByBrensen = bernsen(GrayTestImage, [3 3], 128);
    filename = sprintf('BinarizedByBrensen_%d.png',NumOfImage);
    imwrite(BinarizedByBrensen,filename);
    
    %5 Binarization by using Kittler method
    [Trashh, Minn] = kittlerMinimimErrorThresholding(GrayTestImage); 
    BinarizedByKittler = imbinarize(GrayTestImage, Trashh / 255); 
    filename = sprintf('BinarizedByKittler_%d.png',NumOfImage);
    imwrite(BinarizedByKittler,filename);
    
    %6 Binarized by using Niblack method
    BinarizedByNiblack = niblack(GrayTestImage, [151 151], -0.2, 25);
    filename = sprintf('BinarizedByNiblack_%d.png',NumOfImage);
    imwrite(BinarizedByNiblack,filename);
    
    %7 Binarization by using Bradley method
    BinarizedByBradely = bradley(GrayTestImage, [25 25]);
    filename = sprintf('BinarizedByBradely_%d.png',NumOfImage);
    imwrite(BinarizedByBradely,filename);
    
    %8 Binarization by using Gatos method
    [BinarizedByGatos, Background_Gatos] = BinarizationGatos(GrayTestImage);
    filename = sprintf('BinarizedByGatos_%d.png',NumOfImage);
    imwrite(BinarizedByGatos,filename);
    
    %9  Binarization by using adaptive image threshold 
    BinarizedByAdaptT = imbinarize(GrayTestImage, adaptthresh(GrayTestImage,...
       'ForegroundPolarity', 'dark'));
    filename = sprintf('BinarizedByAdaptT_%d.png',NumOfImage);
    imwrite(BinarizedByAdaptT,filename);
    
    %10 Binarization by using local Otsu`s method %%% Slow performance %%%
    %BinarizedByAdaptT2 = LocalOtsuOp(GrayTestImage);
    
    %10.2  Binarization by using adaptive image threshold 2
    BinarizedByAdaptT2 = imbinarize(GrayTestImage, adaptthresh(GrayTestImage,...
       0.6, 'ForegroundPolarity', 'dark'));
    filename = sprintf('BinarizedByAdaptT2_%d.png',NumOfImage);
    imwrite(BinarizedByAdaptT2,filename);

%% ************** Constructor for all the bin. systems*********************
[TableOfNames, ArrOfValues] = Constructor(BinarizedByWolf, BinarizedByAdaptT, BinarizedBySau,...
    BinarizedByO, BinarizedByAdaptT2, BinarizedByNiblack, BinarizedByKittler,...
    BinarizedByBrensen, BinarizedByBradely, BinarizedByGatos);