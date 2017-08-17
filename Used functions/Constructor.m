function [ BinName output_arr ] = Constructor( varargin )
%CONSTRUCTOR Summary of this function goes here
%   Detailed explanation goes here

Numvarargs = length(varargin); 
ImageIn = varargin{1};
[N M] = size (ImageIn);
output_arr = zeros(Numvarargs, N, M); 

for i = 1:Numvarargs
    output_arr(i,:,:) = varargin{i};
    BinName{i,1} = sprintf('%s', inputname(i));
end

