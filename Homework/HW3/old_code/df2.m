function [df_out] = df2(x,B,m,D2,lambda)
% Gradient function for problem 2
%   x = image space guess
%   b = masked kspace data (acquired)
%   m = vectorized mask
%   D2 = finite differences matrix
%   lambda = regularization parameter
dims = 320;
k = fft2c(rearrange(x),dims); % convert image to kSpace
K = k(:).*m(:); % mask kSpace (vectorized)
X = ifft2c(rearrange(K),dims); % produce masked image space

data = ifft2c(rearrange(B),dims); % data term (image space)

finDiff = lambda*(D2)'*D2*x; % finite difference term

df_out = (X-data)+finDiff; % get gradient

end

