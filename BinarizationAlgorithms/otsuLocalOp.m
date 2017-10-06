function finalImage = otsuLocalOp(InputImage)
    
%		Implementation of local Otsu method with locally adaptive document background correction
%
%
%    Demo to threshold a document with text where the image is noisy and
%    there is severe non-uniformity of illumination.
%
%		Rewrite from MathWorks user: Image Analyst 

% Do a local Otsu of the gray level image.
fun = @(x) LocalOtsu(x); 
A = im2double(InputImage);
localThresh = nlfilter(A, [15, 15], fun); 

% Do a Sobel filter
sobelImage = imgradient(InputImage, 'Sobel');

% Calculate the local standard deviation
sdImage = stdfilt(sobelImage, ones(9));

% Do a global Otsu of the stddev image.
% Threshold the center pixel only.
binaryImage = sdImage > 50;

% AND the two images to produce the final image.
finalImage = ~(localThresh & binaryImage);

% Function to take the Otsu threshold of the small patch of gray levels passed in by nlfilter().
function oneThresholdedPixel = LocalOtsu(grayImagePatch)
	oneThresholdedPixel = false;
	try
		[rows, columns] = size(grayImagePatch);
		middleRow = ceil(rows/2);
		middleColumn = ceil(columns/2);
		level = graythresh(grayImagePatch);
		% Threshold the center pixel only.
		oneThresholdedPixel = ~im2bw(grayImagePatch(middleRow, middleColumn), level);
	catch ME
		errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
			ME.stack(1).name, ME.stack(1).line, ME.message);
		fprintf(1, '%s\n', errorMessage);
		uiwait(warndlg(errorMessage));
	end
	return; % from LocalOtsu()