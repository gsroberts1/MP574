%% Cost Function
% Description: 
%   Calculates cost function (simplified mumford-shah functional) value.
%   Simplified MS: L2-norm(trueImage-approxImage) + length(regions)
%       where: approxImage is a piecewise-constant approx of true image
%       based on average pixel value in region, and length of regions is
%       total perimeter length of all regions.
% Returns: 
%   E = cost function value
% Arguments:
%   approxImage = approximation of true image (double)
%   trueImage = input image (double)
%   totaLength = sum of length of all regions
%   nu = regularization parameter
% Dependencies:
%   NONE

function E = cost(approxImage,trueImage,totaLength,nu)

data_term = norm(approxImage-trueImage); % data consistency (L2-norm)
edge_term = nu*totaLength; % regularization limiting length of region edges
E = data_term + edge_term; % cost function value

end

