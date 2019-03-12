function df_out = df1(x,B,m,dims)
% df: Calculates the output of the objective function (Ax-b --> Mk-b)
%   B = zero-filled a-priori data (M'b)
%   m = vectorized mask
%   k = input fourier data
%   dims = 2D dimensions of image

Y = fft2c(rearrange(x,dims)); % turn to kSpace
Ym = Y(:).*m(:); % masked k-space with zeros (M'Mk)
df = 2*ifft2c(rearrange((Ym-B),dims)); % 2 factor comes from derivative
df_out = df(:); % vectorize

end


