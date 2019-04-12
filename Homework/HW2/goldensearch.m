function [alpha] = goldenSearch(f,df,x,iters)
%%   goldenSearch
%    Finds 1D mimimum of function along gradient direction

a0 = 0; % lower bound on golden section search
b0 = 1; % upper bound on golden section search
rho = 0.382; % golden value
tol = 0.0001; % tolerance
h = @(alpha) f(x-alpha*df(x)); %golden section search 

for ii = 1:iters
    a1 = rho*(b0 - a0)+ a0; 
    b1 = b0-rho*(b0 - a0);  
    if abs(h(a1)-h(b1)) < tol
        alpha = a1; % f(a1) and f(b1) are very close
        break % leave loop, we've found the minimum
    elseif h(a1) >= h(b1)
        a0 = a1;
    elseif h(a1) < h(b1)
        b0 = b1;
    else 
        alpha = a1; %lets go home
    end
end

end