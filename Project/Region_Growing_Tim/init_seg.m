% SUMMARY
% Creates a set of regions each with a label. The regions will be the same
% size as the image
%
% INPUTS
% - g: image
%
% OUTPUTS
% - regions: set of regions, with each pixel having a specific label


function [regions] = init_seg(g)
[m,n] = size(g); % dimensions of image
tol = 30; % tolerance for grayconnected function
R_num = 0; % region number
mask = zeros(size(g)); % create matrix for total mask
regions = zeros(m*n,1); % initialize the region matrix
imask = (mask == 0); % create initial inverse mask

fig = figure;
fig.Position = [100 100 600 600]; % set size of figure

while (sum(imask(:)) ~= 0) % while there are still pixels to be labeled
    R_num = R_num + 1; % label 
    [Rx, Ry] = find(mask == 0,1); % find the first instance where the regions are not labeled
    temp_mask = grayconnected(g,Rx,Ry,tol); % connect all gray values that are simlar
    % only fill  small holes ----------------------------------------------
    filled = imfill(temp_mask,'holes');
    holes = filled & ~temp_mask;
    bigholes = bwareaopen(holes, 50);
    smallholes = holes & ~bigholes;
    temp_mask = temp_mask | smallholes;
    % ---------------------------------------------------------------------
    g2 = g(:); % vecotrize image
    temp_mask2 = temp_mask(:); % Vectorize mask
    regions(temp_mask2) = R_num; % label the regions in the mask
    g2(temp_mask2) = NaN; % make it so this region is not included in the next one
    g = reshape(g2,[m,n]); % reshape image 
    mask = mask + temp_mask; % add label to temp mask
    imask = (mask == 0); % create an inverse of the mask
    % Plot initialization operation ---------------------------------------
    imagesc(reshape(regions,[m,n]));
    axis square
    drawnow;
    % ---------------------------------------------------------------------
end

regions = reshape(regions,[m,n]); % reshape into image size

end
