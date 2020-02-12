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
function [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions, regionNum1, regionNum2, image1, nu, region1Stuff)
    area1 = region1Stuff(1); % area of prior region
    sumg1 = region1Stuff(2); % summed image values in prior region
    f1 = region1Stuff(3); % normalized image values in prior region (to # pixels)
    borderLength1 = region1Stuff(4); % border length of prior region
    area2 = sum(sum(regions==regionNum2)); % area of new region
    sumg2 = sum(sum(image1(regions==regionNum2))); % summed image values in new region
    f2 = sumg2/area2; % normalized image values in new region
    borderLength2 = regionBorderLength(regionNum2, regions); % new border length
    newRegions = regions;
    newRegions(newRegions==regionNum2) = regionNum1; % merge regions
    newlb = regionBorderLength(regionNum1, newRegions); % 
    L = borderLength1+borderLength2-newlb;
    normfs = abs(f1-f2);
    dE = ((area1*area2)/(area1+area2))*normfs - nu*L;
    if(dE<0)
        area1 = area1+area2;
        sumg1 = sumg1+sumg2;
        f1 = sumg1/area1;
        borderLength1 = newlb;
        regions = newRegions;
    end
end