%% Edge Length
% Description: 
%   Calculates discrete edge length (perimeter) of a region.
% Returns: 
%   regions = new map of distinct region labels
%   added = new proposed region to merge
% Arguments:
%   regions = image of distinct region labels (double)
%   R = region of interest
%   added = regions which have already been tested
% Dependencies:
%   NONE

function [regions,added] = merge(regions, R, added)

flag = 0;
[m,n] = size(regions);
for i = 1:m
    for j = 1:n % iterate left to right
        if (regions(i,j) == R)
            if (i > 1 && regions(i-1,j) ~= R && sum(eq(regions(i-1,j),added))==0) % check row above
                % if there is a border between the region of interest
                added = [added, regions(i-1,j)]; % region of proposed merge
                mask = (regions == regions(i-1,j)); % create mask of region to be added
                regions(mask) = R; % merge regions
                flag = 1;
                break
            end
            if (i < m && regions(i+1,j) ~= R && sum(eq(regions(i+1,j),added))==0) % check row below      
                added = [added, regions(i+1,j)];
                mask = (regions == regions(i+1,j));
                regions(mask) = R;
                flag = 1;
                break
            end
            if (j > 1 && regions(i,j-1) ~= R && sum(eq(regions(i,j-1),added))==0) % check column to the left
                added = [added, regions(i,j-1)];
                mask = (regions == regions(i,j-1));
                regions(mask) = R;
                flag = 1;
                break
            end
            if (j < n && regions(i,j+1) ~= R && sum(eq(regions(i,j+1),added))==0) % check column to the right
                added = [added, regions(i,j+1)];
                mask = (regions == regions(i,j+1));
                regions(mask) = R;
                flag = 1;
                break
            end
        end
    end
    if (flag == 1) % break if a proposal is found
        break
    end
end

end
    