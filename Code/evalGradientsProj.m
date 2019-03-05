% File Name: evalGradientsProj.m
% Description: Calculate cost and gradient for  L2-regularized reconstruction from projections
% Author: Diego Hernando
% Date created: 2/26/19
% Date last modified: 3/2/19

function [f,g] = evalGradientsProj(x, imageSize, d, theta, lambda, D, W)
% Fitting || Fx - d ||^2 + lambda ||Dx||
% || [F;sqrt(lambda)D]x - [d;0] ||^2

Nangle = length(theta);
N = imageSize(1);
fx = radon(reshape(x,imageSize),theta);

% Here is the cost
f = norm(fx(:)-d(:))^2 + lambda*norm(W(:).*(D*x(:)))^2;

if nargout > 1 % If we need to calculate the gradient, run this part
    fx2 = reshape(fx,[],Nangle); 
    y2 = 2/pi*Nangle*iradon(fx2,theta,'spline','none',1,N);
    fhfx = reshape(y2,[],1);

    d2 = reshape(d,[],Nangle); 
    yd2 = 2/pi*Nangle*iradon(d2,theta,'spline','none',1,N);
    Fhd = reshape(yd2,[],1);
    g = fhfx(:) + lambda*D'*(conj(W(:)).*W(:).*(D*x(:))) - Fhd(:);
end

end

