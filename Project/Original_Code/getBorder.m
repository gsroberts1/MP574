%% usage: border = getBorder(regions)
% Returns a border matrix the same size as our image g. It is a matrix where 1 is where the border is and 0 is not the border.
%   The border is our \Gamma.
% Arguments:
%   regions = A regions matrix
function border = getBorder(regions)
    border = ones(size(regions));
    dim = size(regions);
    for regionNumber = sort(unique(regions))'
        for x = 1:dim(1)
            for y = 1:dim(2)
                if(regions(x,y)==regionNumber)
                    if((x>1) && (regions(x-1,y) > regionNumber))
                        border(x,y) = 0;
                    end
                    if((x<dim(1)) && (regions(x+1,y) > regionNumber))
                        border(x,y) = 0;
                    end
                    if((y>1) && (regions(x,y-1) > regionNumber))
                        border(x,y) = 0;
                    end
                    if((y<dim(2)) && (regions(x,y+1) > regionNumber))
                        border(x,y) = 0;
                    end
                end
            end
        end
    end
end