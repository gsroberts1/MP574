function [f,g,g1,g2] = evalGradients_L1(x, imageSize, d, mask, lambda, D,mu)
%% evalGradients_L1: evaluates f(x) and grad(x) given x.
% Fitting || Fx - d ||_2^2 + lambda ||Dx||_1
%   imageSize: matrix of image dimensions
%   d: data vector
%   mask: vectorized mask
%   lambda: regularization parameter
%   D: finite differences matrix
%   mu: 

fx1 = fftshift(fft2(ifftshift(reshape(x,imageSize))));
fx = fx1(mask(:));

Dx = D*x(:);
l1term = sqrt(abs(Dx).^2 + mu);
f = norm(fx(:)-d(:))^2 + lambda*sum(l1term);

if nargout > 1
    mhd = zeros(imageSize);
    mhd(mask) = d;
    mhfx = zeros(imageSize);
    mhfx(mask) = fx;
    g1 = 2*prod(imageSize)*fftshift(ifft2(ifftshift(mhfx-mhd)));
    g2 = lambda*D'*((1./l1term(:)).*(Dx));
    g = g1(:) + g2(:);
end

end
