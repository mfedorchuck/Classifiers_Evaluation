% FENG's local thresholding.
%   BW = FENG(IMAGE) performs local thresholding of a two-dimensional 
%   array IMAGE with Feng's algorithm.
%      
%   BW = FENG(IMAGE, [M N], [P Q]) performs local thresholding with M-by-N 
%   primary window (default is 3-by-3) and P-by-Q large window 
%   (default is 5-by-5). The M-by-N window should be large enough to cover 
%   1-2 characters. The P-by-Q window compensates for unevenness of the 
%   illumination and should be bigger than M-by-N window.
%
%   BW = FENG(IMAGE, [M N], [P Q], ALPHA, GAMMA, K1, K2, PADDING) performs
%   local thresholding with defined constants ALPHA, GAMMA, K1 and K2. 
%   ALPHA shifts the threshold and is commonly in range 0.1-0.2 (default is 0.12).
%   GAMMA describes exponent and is by default set to 2. 
%   K1 is a multiplicative constant in range 0.15-0.25 (default is 0.25).
%   K2 is a multiplicative constant in range 0.01-0.05 (default is 0.04).
%   To deal with border pixels the image is padded with PADARRAY. The 
%   PADDING parameter can be either set to a scalar or a string: 
%       'circular'    Pads with circular repetition of elements.
%       'replicate'   Repeats border elements of matrix A (default).
%       'symmetric'   Pads array with mirror reflections of itself. 
%
%   Implementation note
%   -------------------
%   Due to the limitations of the used min filter the kernel size is
%   limited to odd values.
%
%   Postprocesing
%   -------------
%   It's suggested to apply a median filter with kernel 3x3 to the output
%   of Feng's method. This additional filtering should reduce noise in the
%   thresholded image. 
%
%   Example
%   -------
%       imshow(feng(imread('eight.tif'), [91 91], [110 110]));
%
%   See also PADARRAY, RGB2GRAY.

%   For method description see:
%       Meng-Ling Feng and Yap-Peng Tan, "Contrast adaptive binarization of
%       low quality document images", IEICE Electron. Express, Vol. 1,
%       No. 16, pp.501-506, (2004))
%   Contributed by Jan Motl (jan@motl.us)
%   $Revision: 1.0 $  $Date: 2013/05/10 16:58:01 $

function output=feng(image, varargin)
% Initialization
numvarargs = length(varargin);      % only want 3 optional inputs at most
if numvarargs > 7
    error('myfuns:somefun2Alt:TooManyInputs', ...
     'Too many parameters was passed to the function.');
end
 
optargs = {[3 3] [5 5] 0.12 2 0.25 0.04 'replicate'}; % set defaults
 
optargs(1:numvarargs) = varargin;   % use memorable variable names
[window, windowBig, alpha, gamma, k1, k2, padding] = optargs{:};

if ndims(image) ~= 2
    error('The input image must be a two-dimensional array.');
end

% Convert to double
image = double(image);

% Standard deviation (big window)
[meanBig, iNormal] = averagefilter_v1_3(image, windowBig, padding);
[meanSquareBig, iSquare] = averagefilter_v1_3(image.^2, windowBig, padding);
deviationBig = (meanSquareBig - meanBig.^2).^0.5;

% Standard deviation and mean (small window), reuse the integral images
mean = averagefilter_v1_3(image, window, iNormal);
meanSquare = averagefilter_v1_3(image.^2, window, iSquare);
deviation = (meanSquare - mean.^2).^0.5;

% Minimum
minimum = minfilt2(image, window);

% Feng
alpha2 = k1*(deviation./deviationBig).^gamma;
alpha3 = k2*(deviation./deviationBig).^gamma;
threshold = (1-alpha)*mean + alpha2.*(deviation./deviationBig).*(mean-minimum) + alpha3.*minimum;

output = (image > threshold);
