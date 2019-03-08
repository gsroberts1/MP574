function x = ifft2c(k)
    dims = 320;
    x = dims^2*ifftshift(ifft2(fftshift(k)));
end

