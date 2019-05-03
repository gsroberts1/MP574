%% Approximate Image
% Description: 
%   Approximates an image based on regions and true image. 
%   Image approximation is done by averaging true image pixel values in 
%   each region. Time is saved by importing an already approximated image,
%   only merging new regions.
% Returns: 
%   approxImage = image approximation (double)
% Arguments:
%   r = current region
%   proposedAdd = region of proposed merge
%   regions = image of distinct region labels (double)
%   approxImage = initial image approximation (double)
% Dependencies:
%   NONE

function approxImage = approximate(r,proposedAdd,regions,approxImage)

maskR = regions==r; % mask area of current region
maskP = regions==proposedAdd; % mask area of proposed region
mask = maskR | maskP; % create mask of combined region
newMean = mean(approxImage(mask)); % calculate mean of combined region
approxImage(mask) = newMean; % make new approximate image

end