function k = fft2c(x)
    k = 1/sqrt(length(x(:)))*fftshift(fft2(ifftshift(x)));
end

