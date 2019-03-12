function [f,g] = evalGradients_L2(x, imageSize, d, m, lambda, D, W)
%% Calculates the cost function and gradient of cost function at x
% Fitting || Fx - d ||^2 + lambda ||Dx||_2^2 = || [F;sqrt(lambda)D]x - [d;0] ||_2^2
%   x = input image estimation
%   imageSize = array of image dimensions ([320 320])
%   d = acquired data vector (Nx1)
%   m = vectorized mask (Nx1)
%   lambda = regularization parameter (scalar)
%   D = finite differences matrix (NxN)
%   W = weighting matrix (320x320)

N = prod(imageSize); % number of pixels
k = fftshift(fft2(ifftshift(reshape(x,imageSize)))); % get kSpace (Fx)
km = k(m); % mask kSpace (MFx)
% objective function = ||MFx-d||_2^2 + lambda||Dx||_2^2
f = norm(km(:)-d(:))^2 + lambda*norm(W(:).*(D*x(:)))^2; 


if nargout > 1
    kmm = k(:).*m; % zero-fill and mask kSpace (M'MFx)
    fhfx = N*fftshift(ifft2(ifftshift(reshape(kmm,imageSize)))); % get image space (F'M'MFx)

    mhd = zeros(imageSize); % initialize undersampled d vector
    mhd(m) = d; % zero-fill d (M'd)
    Fhd = prod(imageSize)*fftshift(ifft2(ifftshift(mhd))); % fft masked d (F'M'd)
    % closed form of gradient of obj. function = (2F'M'MFx)-(2F'M'd)
    g = 2*fhfx(:) + 2*lambda*D'*(conj(W(:)).*W(:).*(D*x(:))) - 2*Fhd(:);     
end

end

