function [f_out] = f2(x,b,m,D2,lambda)
% Cost function for problem 2 (including finite differences)
%   x = image space guess
%   b = masked kspace data (acquired)
%   m = vectorized mask
%   D2 = finite differences matrix
%   lambda = regularization parameter
dims = 320;
k(m) = fft2c(rearrange(x),dims); % (MFx)
data = k-b; % 1st term, data consistency (MFx-b)
Dx = sqrt(lambda)*D2*x; % 2nd term (lambdaDx)

f_out = norm(data).^2 + norm(Dx).^2; % ||Mfx - b||2 + lambda||Dx||2

