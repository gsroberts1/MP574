function x = ifft2c(k)
    x = sqrt(length(k(:)))*ifftshift(ifft2(fftshift(k)));
end

