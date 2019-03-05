function f_out = f1(k,b,m)
% f: Calculates the output of the objective function (Ax-b --> Mk-b)
%   b = a-priori data
%   m = vectorized mask
%   k = input fourier data

Mk = k(m); % get masked k-space
f_out = norm(Mk-b).^2; % function output

end

