function k = fft2c(x)
    k = fftshift(fft2(ifftshift(x)));
end

