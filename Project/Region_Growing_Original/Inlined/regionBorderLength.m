%% usage: length1 = regionBorderLength(regionNumber, regions)
% Returns the length of the board of a region.
% Arguments:
%   regionNumber = The region to find the board length
%   regions = A matrix containing the regions
function length1 = regionBorderLength(regionNumber, regions)
    dim = size(regions);
    length1 = 0;
    for x = 1:dim(1)
        for y = 1:dim(2)
            if(regions(x,y)==regionNumber)
                if((x>1) && (regions(x-1,y) ~= regionNumber))
                    length1 = length1 + 1;
                end
                if((x<dim(1)) && (regions(x+1,y) ~= regionNumber))
                    length1 = length1 + 1;
                end
                if((y>1) && (regions(x,y-1) ~= regionNumber))
                    length1 = length1 + 1;
                end
                if((y<dim(2)) && (regions(x,y+1) ~= regionNumber))
                    length1 = length1 + 1;
                end
            end
        end
    end
end