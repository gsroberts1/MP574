% SUMMARY
% updates the segmentation vector, given an updated set of regions

% INPUTS
% - f: current segmentation
% - regions: current set of regions
% - R: region you are trying to segment
% - g: actual image

% OUPUTS
% - f: new segmentation


function f = segment2(f,regions,R,g)

areaR = (regions == R); % create a mask for the region you are trying to segment
areaR2 = areaR(:); % vectorize region mask
f(areaR2) = mean(g(areaR2)); % set values in region equal to average value of g in that region

end