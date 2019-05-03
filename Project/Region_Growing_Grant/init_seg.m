%% Initial Segmentation
% Description: 
%   Basic region-growing segmentation utilizing 'grayconnected' function 
%   to connect regions of like pixels. Also fills in small holes. 
% Returns: 
%   regions = basic region segmentation (initialization)
% Arguments:
%   trueImage = input image (double)
%   tol = tolerance of "like pixels" (see 'grayconnected')
% Dependencies:
%   NONE

function [regions] = init_seg(trueImage,tol)

R_num = 0; % initialize region number
mask = ones(size(trueImage)); % matrix for regions available for merging
regions = zeros(size(trueImage)); % initialize region matrix

while (sum(mask(:)) > 0)
    R_num = R_num + 1; % update region number
    [Rx, Ry] = find(mask == 1,1); % find first instance of new region
    temp_mask = grayconnected(trueImage,Rx,Ry,tol); % connect like pixels
    largeRegions = bwareaopen(~temp_mask, 10); % fill in holes < size 10
    temp_mask = ~largeRegions; % invert to turn region of interest to 1's
    regions(temp_mask) = R_num; % assign this region to a specific region #
    trueImage(temp_mask) = NaN; % exclude region in trueImage for next grayconnected iter
    mask = mask - temp_mask; % remove already segmented region from mask
    imagesc(regions); axis square; title('Unique Region Labels');
    drawnow;
end

end
