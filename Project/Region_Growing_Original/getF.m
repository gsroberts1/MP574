%% usage: f = getF(regions, image1)
% Returns our f function which is a approximation for our image g. It is a matrix the same size as our image.
% Arguments:
%   regions = A regions matrix
%   image1 = The image g
function f = getF(regions, image1)
    f = zeros(size(image1));
    for r = sort(unique(regions))'
        f(regions==r) = sumG(r, regions, image1)/regionArea(r, regions);
    end
end