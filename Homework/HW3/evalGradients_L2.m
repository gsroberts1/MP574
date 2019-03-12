function [f,g] = evalGradients_L2(x, imageSize, b, m, lambda, D, W)
%% Calculates the cost function and gradient of cost function at x
% Fitting || Fx - b ||^2 + lambda ||Dx||_2^2 = || [F;sqrt(lambda)D]x - [b;0] ||_2^2
%   x = input image estimation
%   imageSize = array of image dimensions ([320 320])
%   b = acquired data vector (Nx1)
%   m = vectorized mask (Nx1)
%   lambda = regularization parameter (scalar)
%   D = finite differences matrix (NxN)
%   W = weighting matrix (320x320)
%   DEPENDENCIES: ifft2c,fft2c

k = fft2c(reshape(x,imageSize)); % get kSpace (Fx)
km = k(m); % mask kSpace (MFx)
% objective function = ||MFx-d||_2^2 + lambda||Dx||_2^2
f = norm(km(:)-b(:))^2 + lambda*norm(W(:).*(D*x(:)))^2; 

if nargout > 1
    kmm = k(:).*m; % zero-fill and mask kSpace (M'MFx)
    fhfx = ifft2c(reshape(kmm,imageSize)); % get image space (F'M'MFx)

    mhb = zeros(imageSize); % initialize undersampled b vector
    mhb(m) = b; % zero-fill b (M'b)
    Fhb = ifft2c(reshape(mhb,imageSize)); % fft masked d (F'M'b)
    % closed form of gradient of obj. function = (F'M'MFx)-(F'M'b)-...
    g = fhfx(:) + lambda*D'*(conj(W(:)).*W(:).*(D*x(:))) - Fhb(:);     
end

end

