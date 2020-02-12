%% usage: sG = sumG(regionNumber, regions, image1)
% Returns the sum of pixel values in the actual image for a region.
% Arguments:
%   regionNumber = The region to sum over.
%   regions = A matrix containing the regions
%   image1 = The actual image matrix g
function sG = sumG(regionNumber, regions, image)
    sG = sum(sum(image(regions==regionNumber)));
end