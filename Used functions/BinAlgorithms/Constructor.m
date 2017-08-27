function [ BinName output_arr ] = Constructor( varargin )
% Build 3D array and tables of names from all the classification algorithms
% which have been used

Numvarargs = length(varargin); 
ImageIn = varargin{1};
[N M] = size (ImageIn);
output_arr = zeros(Numvarargs, N, M); 

for i = 1:Numvarargs
    output_arr(i,:,:) = varargin{i};
    BinName{i,1} = sprintf('%s', inputname(i));
end

end