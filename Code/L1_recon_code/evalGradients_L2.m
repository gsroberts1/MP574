function [f,g] = evalGradients_L2(x, imageSize, d, mask, lambda, D, W)
% Fitting || Fx - d ||^2 + lambda ||Dx||^2
% || [F;sqrt(lambda)D]x - [d;0] ||^2

fx1 = fftshift(fft2(ifftshift(reshape(x,imageSize)))); %(Fx) = get kSpace
fx = fx1(mask(:)); %(MFx) = mask kSpace
f = norm(fx(:)-d(:))^2 + lambda*norm(W(:).*(D*x(:)))^2; % objective function

if nargout > 1
    fhfx = prod(imageSize)*fftshift(ifft2(ifftshift(fx1))); %(F'Fx) = return to image space
    mhd = zeros(imageSize); 
    mhd(mask) = d; %(M'd) = zero-fill undersample data
    Fhd = prod(imageSize)*fftshift(ifft2(ifftshift(mhd)));  %(F'M'd) = transform to image  
    g = fhfx(:) + lambda*D'*(conj(W(:)).*W(:).*(D*x(:))) - Fhd(:);
end

end

