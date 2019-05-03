%% usage: [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions, regionNum1, regionNum2, image1, nu,region1Stuff)
% Returns the calculated dE and updates current working region data to save on work for next time we calculate \Delta E.
% Arguments:
%   regions = A matrix with our regions
%   regionNum1 = Our current working region
%   regionNum2 = The region we are merging with to see if it improves dE
%   image1 = Our image matrix g
%   nu = The weight \nu parameter
%   region1Stuff = A matrix contains the current working region data it should include: [area1, sumg1, f1, borderLength1]
%       Inside region1Stuff:
%           area1 = The current area for our working region
%           sumg1 = The sum of values from the image for our region
%           f1 = sumg1/area
%           borderLength1 = The length of the border for our working region
function [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions, regionNum1, regionNum2, imagesq, image1, nu, region1Stuff)
%     % Parameters for region 1
%     area1 = region1Stuff(1);
%     sumg1 = region1Stuff(2);
%     f1 = region1Stuff(3);
%     borderLength1 = region1Stuff(4);
%     % Parameters for region 2
%     area2 = regionArea(regionNum2, regions);
%     sumg2 = sumG(regionNum2, regions, image1);
%     f2 = sumg2/area2;
%     borderLength2 = regionBorderLength(regionNum2,regions);
%     % Parameters for proposed merged region
%     newRegions = regions;
%     newRegions(newRegions==regionNum2) = regionNum1;
%     borderLength3 = regionBorderLength(regionNum1, newRegions);
%     
%     dL = borderLength3 - borderLength1 - borderLength2; % how much are we changing length by merging regions
%     normfs = abs(f1-f2).^2; % how much data consistency exists
%     effectiveArea = (area1*area2)/(area1+area2);
%     dE = effectiveArea*normfs + nu*dL; % change in energy by merging
    
    % Parameters for region 1
    area1 = region1Stuff(1);
    sumg1 = region1Stuff(2);
    TSS1 = sumG(regionNum1,regions, imagesq);
    f1 = region1Stuff(3);
    borderLength1 = region1Stuff(4);

    % Parameters for region 2
    area2 = regionArea(regionNum2, regions);
    sumg2 = sumG(regionNum2, regions, image1);
    TSS2 = sumG(regionNum2,regions, imagesq);
    f2 = sumg2/area2;
    borderLength2 = regionBorderLength(regionNum2,regions);
    
    % Parameters for proposed merged region
    newRegions = regions;
    newRegions(newRegions==regionNum2) = regionNum1;
    area3 = regionArea(regionNum1, newRegions);
    sumg3 = sumG(regionNum1, newRegions, image1);
    TSS3 = sumG(regionNum1, newRegions, imagesq);
    f3 = sumg3/area3;
    borderLength3 = regionBorderLength(regionNum1, newRegions);
    
    E1 = (area1*f1^2 + TSS1 - 2*f1*sumg1) + nu*borderLength1;
    E2 = (area2*f2^2 + TSS2 - 2*f2*sumg2) + nu*borderLength2;
    E12 =(area3*f3^2 + TSS3 - 2*f3*sumg3) + nu*borderLength3;
    dE = E12 - E1 - E2;
  
    if(dE<0)
        area1 = area1+area2;
        sumg1 = sumg1+sumg2;
        f1 = sumg1/area1;
        borderLength1 = borderLength3;
        regions = newRegions;
    end
end