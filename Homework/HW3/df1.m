function df_out = df1(k,B,m,dims)
% df: Calculates the output of the objective function (Ax-b --> Mk-b)
%   B = zero-filled a-priori data
%   m = vectorized mask
%   k = input fourier data
%   dims = 2D dimensions of image

Y = k.*m; % masked k-space with zeros (=M'Mk)
v = reshape(Y-B,[dims dims]); % prepare for 2D inverse fourier transform
V = ifftshift(ifft2(fftshift(v))); % function output 
df_out = V(:); % vectorize

end


