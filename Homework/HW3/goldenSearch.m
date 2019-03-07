function [alpha] = goldenSearch(k_in,df,b,m,dims)
%%   goldenSearch
%    Finds 1D mimimum of function along gradient direction
a0 = 0; % lower bound on golden section search
b0 = 1; % upper bound on golden section search
rho = 0.382; % golden value
tol = 0.001; % tolerance
iterations = 100;

h = @(alpha) k_in-alpha*df;

for ii = 1:iterations
    a1 = rho*(b0 - a0)+ a0; 
    b1 = b0-rho*(b0 - a0); 
    f1a1 = f1(h(a1),b,m);
    f1b1 = f1(h(b1),b,m);
    if abs(f1a1-f1b1) < tol
        alpha = a1; % f(a1) and f(b1) are very close
        break % leave loop, we've found the minimum
    elseif f1a1 >= f1b1
        a0 = a1;
    elseif f1a1 < f1b1
        b0 = b1;
    else 
        alpha = a1; %lets go home
    end
end

end
