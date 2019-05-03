%% usage: area = regionArea(regionNumber, regions)
% Returns the number of pixels a region is covering.
% Arguments:
%   regionNumber = The region number to calculate the area for.
%   regions = The matrix containing the regions
function area = regionArea(regionNumber, regions)
    area = sum(sum(regions==regionNumber));
end