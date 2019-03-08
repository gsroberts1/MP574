function [alpha] = goldenSearch(x_in,df,b,m,dims)
%%   goldenSearch
%    Finds 1D mimimum of function along gradient direction
a0 = 0; % lower bound on golden section search
b0 = 1; % upper bound on golden section search
rho = 0.382; % golden value
iterations = 100;

h = @(alpha) f1(x_in-alpha*df,b,m,dims);

for ii = 1:iterations
    a1 = rho*(b0 - a0)+ a0; 
    b1 = b0-rho*(b0 - a0); 
    ha = h(a1);
    hb = h(b1);
    if ha >= hb
        a0 = a1;
    else
        b0 = b1;
    end 
    alpha = (a1+b1)/2;
end

end
