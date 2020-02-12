% SUMMARY
% merge the first adjacent region found with the current region R. Return a
% logical value if no regoin was added, indicating that there are no
% adjacent regions.
%
% INPUTS
% - regions: set of regions, each pixel with a given label
% - R: current region that we want to merge
% - added: array containing already attempted regions (added or not)
%
% OUPUTS
% - regions: new set of regions containing merge
% - added: array containgin the updated already attempted regions
% - flag: logical operator that ret





function [regions,added,flag] = merge(regions, R, added)
flag = 0; % set logical value to false
[m,n] = size(regions); % dimensions of regions
% step through entire domain
for i = 1:m
    for j = 1:n
        if (regions(i,j) == R) % if the current pixel is in the region, R
            if (i > 1 && regions(i-1,j) ~= R && sum(eq(regions(i-1,j),added))==0) % if there is a border between the region of interest
                added = [added, regions(i-1,j)]; % store what the added region is 
                mask2 = (regions == regions(i-1,j)); % create mask of region to be added
                mask = mask2(:); % vectorize mask
                regions2 = regions(:); % vectorize regions
                regions2(mask) = R; % merge regions
                regions = reshape(regions2,[m,n]); % reshape regions
                flag = 1; % set flag to 1 to break out of 2nd for loop, as well as show that a region was added
                break
            end
            if (i < m && regions(i+1,j) ~= R && sum(eq(regions(i+1,j),added))==0)
                added = [added, regions(i+1,j)];
                mask2 = (regions == regions(i+1,j)); % create mask of region to be added
                mask = mask2(:); % vectorize mask
                regions2 = regions(:); % vectorize regions
                regions2(mask) = R; % merge regions
                regions = reshape(regions2,[m,n]);
                flag = 1;
                break
            end
            if (j > 1 && regions(i,j-1) ~= R && sum(eq(regions(i,j-1),added))==0)
                added = [added, regions(i,j-1)];
                mask2 = (regions == regions(i,j-1)); % create mask of region to be added
                mask = mask2(:); % vectorize mask
                regions2 = regions(:); % vectorize regions
                regions2(mask) = R; % merge regions
                regions = reshape(regions2,[m,n]);
                flag = 1;
                break
            end
            if (j < n && regions(i,j+1) ~= R && sum(eq(regions(i,j+1),added))==0)
                added = [added, regions(i,j+1)];
                mask2 = (regions == regions(i,j+1)); % create mask of region to be added
                mask = mask2(:); % vectorize mask
                regions2 = regions(:); % vectorize regions
                regions2(mask) = R; % merge regions
                regions = reshape(regions2,[m,n]);
                flag = 1;
                break
            end
        end
    end
    if (flag == 1)
        break
    end
end

end
    