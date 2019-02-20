function [alpha] = goldensearch(f,df,x,a0,b0,iters)
%   goldensearch - provides a golden section search of a 1d function
%   a0 and b0: defines the interval search area.
%   iters: number of iterations to perform
%   fun: 1D function to perform search.
%   guess: define starting
%   estim: final estimator output
%   err: difference between the two eval points (absolute)
%   golden value is rho = 0.382
rho = 0.382;
tol = 0.0001;
h = @(alpha) f(x-alpha*df(x));
for ii = 1:iters
    a1 = rho*(b0 - a0)+ a0;
    b1 = b0-rho*(b0 - a0);
    if abs(h(a1)-h(b1)) < tol
        alpha = a1;
        break
    elseif h(a1) >= h(b1)
        a0 = a1;
    elseif h(a1) < h(b1)
        b0 = b1;
    else 
        alpha = a1;
    end
end

end