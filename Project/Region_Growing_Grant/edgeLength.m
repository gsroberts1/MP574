%% Edge Length
% Description: 
%   Calculates discrete edge length (perimeter) of a region.
% Returns: 
%   len = length of region R
% Arguments:
%   regions = image of distinct region labels (double)
%   R = region of interest
% Dependencies:
%   NONE

function len = edgeLength(R, regions)

[m,n] = size(regions);
len = 0;
for i = 1:m
    for j = 1:n
        if regions(i,j) == R
            if (i > 1 && regions(i-1,j) ~= R) % if there is a border between the region of interest 
                len = len + 1; % add 1 to the length
            end
            if (i < m && regions(i+1,j) ~= R)
                len = len + 1;
            end
            if (j > 1 && regions(i,j-1) ~= R)
                len = len + 1;
            end
            if (j < n && regions(i,j+1) ~= R)
                len = len + 1;
            end
        end
    end
end

end