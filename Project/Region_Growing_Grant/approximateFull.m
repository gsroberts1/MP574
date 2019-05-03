%% Approximate Image
% Description: 
%   Approximates an image based on regions and true image. 
%   Image approximation is done by averaging true image pixel values in 
%   each region.
% Returns: 
%   approxImage = image approximation (double)
%   totaLength = sum of total length of each region
% Arguments:
%   regions = image of distinct region labels (double)
%   trueImage = input image (double)
% Dependencies:
%   edgeLength.m

function [approxImage,totaLength] = approximateFull(regions,trueImage)

totaLength = 0;
approxImage = zeros(size(regions));
labels = (unique(regions)); % unique region numbers (labels)
N_regions = length(labels); % number of total distinct regions

for r = 1:N_regions
    areaR = (regions == labels(r)); % returns 1's in the current region, and zeros elsewhere
    approxImage = approxImage + mean(trueImage(areaR))*areaR; % add approximation of region r to f
    totaLength = totaLength + edgeLength(labels(r),regions); % iteratively add region lengths
end

end