%% Get Each Region Edge Length
% Description: 
%   Calculates discrete edge length (perimeter) of each region.
%   Note this does not count outside edge of image as a border
% Returns: 
%   L = array of region length
% Arguments:
%   regions = image of distinct region labels (double)
% Dependencies:
%   NONE

function L = getAllLengths(regions)

[m,n] = size(regions);
labels = unique(regions); % unique region numbers (labels)
N_regions = length(labels); % number of total distinct regions
L = zeros(N_regions,1); % initialize length array
for r = 1:N_regions
    for i = 1:m
        for j = 1:n
            if regions(i,j) == r
                if (i > 1 && regions(i-1,j) ~= r) % if there is a border b/w pixel of interest and next pixel 
                    L(r) = L(r) + 1; % add 1 to the length
                end
                if (i < m && regions(i+1,j) ~= r)
                    L(r) = L(r) + 1;
                end
                if (j > 1 && regions(i,j-1) ~= r)
                    L(r) = L(r) + 1;
                end
                if (j < n && regions(i,j+1) ~= r)
                    L(r) = L(r) + 1;
                end
            end
        end
    end
end

end