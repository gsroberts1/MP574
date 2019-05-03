%% usage: regions = consolidateRegions(regions)
% Returns a matrix of regions in which the region numbers are
%   consolidated. For example after merging has been done the
%   regions will be numbered 3, 200, 450, etc. This function renames
%   them 0, 1, 2, ... We do this so it is easier to use the regions
%   matrix in the future as there will be no gap in the region numbers.
% Arguments:
%   regions = A regions matrix
function regions = consolidateRegions(regions)
    ur = sort(unique(regions))';
    count = 0;
    for i = ur
        if(i ~= count)
            regions(regions==i) = count;
        end
        count = count+1;
    end
end