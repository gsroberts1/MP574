function f_out = f1(x,b,m,dims)
% f: Calculates the output of the objective function (MFx-b --> Mk-b)
%   b = a-priori data
%   m = vectorized mask
%   k = input fourier data

Y = fft2c(rearrange(x,dims)); % get k-space (MFx = Mk)
y = Y(m); % mask kSpace
f_out = norm(y-b)^2; % function output ( ||MFx-b|| )

end

