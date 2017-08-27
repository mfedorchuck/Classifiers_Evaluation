function [binarized, background] = BinarizationGatos(image,hist)
% [binarized, background] = BinarizationGatos(IMAGE) performs binarization
% of image by using Gatos algorithm
% 
% [binarized, background] = BinarizationGatos(IMAGE,HIST) performs local 
% thresholding with the optimal histogram template (HIST) to fit
% 
% This version includes wiener filter
% Found on GitHub and modified by MaxF
%
% ------ input -------
% "image" should be in grayscale
% "hist" is the optimal histogram template to fit

% ------ output ------
% "binarized" is the binarized image by gatos thresholding
% "background" is the background image for gatos thresholding

KERNEL=[7 7];    % square Kernel for wiener filter
KERNEL_MED=[17 17];   % the kernel for median filter. It works with image 
                      % whose size is around 1000*1000 to 2000*2000
hist = fopen('xdata.dat');

% denoise by wiener filter
adjust = wiener2(image,KERNEL);

% histogram equalization
image_adjust = histeq(adjust);
[a b] = size(image);

% background estiamtion
image_med = medfilt2(image_adjust, KERNEL_MED);   % median filter
% flood fill
image_med_pad = padarray(image_med, [1 1], 0); % prevent imfill filling the background into a single level
background_pad = imfill(image_med_pad, 'holes');
background = background_pad(2:a + 1, 2:b + 1);

PreBinarized = double((image./255) ./ (background./255));
binarized = imbinarize(PreBinarized);
end