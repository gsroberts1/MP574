% SUMMARY
% Returns a vector containing the length of each region
%
% INPUTS
% - regions: Current set of regions
%
% OUTPUTS
% - L: vector containing the length of each region

function L = edgeLength2(regions)

[m,n] = size(regions); % the dimensions of the regions
labels = unique(regions); % find the set of labels in the regions
N_regions = length(labels); % find the number of regions
L = zeros(N_regions,1); % initialize length vector
for r = 1:N_regions % for each region
    % step through the entire domain for each regoin
    for i = 1:m
        for j = 1:n
            if regions(i,j) == r % if the pixel is equal to the current region
                % if there is a border between the region of interest, add
                % to the length
                if (i > 1 && regions(i-1,j) ~= r)  
                    L(r) = L(r) + 1;
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