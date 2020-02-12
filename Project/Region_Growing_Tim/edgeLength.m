% SUMMARY
% Returns the border length of the current region
%
% INPUTS
% - R: Current region
% - f: current segmentation
%
% OUTPUTS
% - L: length of border around current region

function L = edgeLength(R, regions)

[m,n] = size(regions); % the dimensions of the regions
L = 0; % initialize length variable
% step through the entire domain for the region of interest
for i = 1:m
    for j = 1:n
        if regions(i,j) == R % if the pixel is equal to the current region
            % if there is a border between the region of interest, add to
            % the length
            if (i > 1 && regions(i-1,j) ~= R) 
                L = L + 1; 
            end
            if (i < m && regions(i+1,j) ~= R)
                L = L + 1;
            end
            if (j > 1 && regions(i,j-1) ~= R)
                L = L + 1;
            end
            if (j < n && regions(i,j+1) ~= R)
                L = L + 1;
            end
        end
    end
end

end