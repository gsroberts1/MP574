function f_out = f1(k,b,m)
% f: Calculates the output of the objective function (MFx-b --> Mk-b)
%   b = a-priori data
%   m = vectorized mask
%   k = input fourier data

y = k(m); % get masked k-space (MFx = Mk)
f_out = norm(y-b).^2; % function output ( ||MFx-b|| )

end

