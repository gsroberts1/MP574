%% usage: regions = defaultRegions(dim)
% Returns a default region matrix which each pixel is a region.
% Arguments:
%   dim = The size of our image
function regions = defaultRegions(dim)
    regions = zeros(dim);
    count = 0;
    for x = 1:dim(1)
        for y = 1:dim(2)
            regions(x,y) = count;
            count = count+1;
        end
    end
end