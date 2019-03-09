function [f,g] = evalGradients_L2(x, imageSize, d, mask, lambda, D, W)
% Fitting || Fx - d ||^2 + lambda ||Dx||^2
% || [F;sqrt(lambda)D]x - [d;0] ||^2

fx1 = fftshift(fft2(ifftshift(reshape(x,imageSize))));
fx = fx1(mask(:));

f = norm(fx(:)-d(:))^2 + lambda*norm(W(:).*(D*x(:)))^2;

if nargout > 1
    fhfx = prod(imageSize)*fftshift(ifft2(ifftshift(fx1)));
    mhd = zeros(imageSize);
    mhd(mask) = d;
    Fhd = prod(imageSize)*fftshift(ifft2(ifftshift(mhd)));   
    g = fhfx(:) + lambda*D'*(conj(W(:)).*W(:).*(D*x(:))) - Fhd(:);
end

end

