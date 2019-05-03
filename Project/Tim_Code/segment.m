% SUMMARY
% creates a segmentation for an image given a set of regions. For each
% region the function sets every pixel in the segmentation equal to the
% average value of all the pixels of the actual image.
%
% INPUTS
% - regions: set of regions for segmentation, each pixel having been
% assinged a label
% - g: actual image
%
% OUTPUTS
% - f: segmentation

function f = segment(regions,g)
[m, n] = size(regions);
N_regions = length(unique(regions));
labels = (unique(regions));
f = zeros(m*n,1);
for r = 1:N_regions
    areaR = (regions == labels(r)); % returns 1's in the current region, and zeros elsewhere
    areaR2 = areaR(:); % vectorize region area mask
    f(areaR2) = mean(g(areaR2));
end


end