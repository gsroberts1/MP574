function [alpha] = goldenSearch(x,g,imageSize,b,m,lambda,D,W)
%%   goldenSearch
%    Finds 1D mimimum of function along gradient direction
a0 = 0; % lower bound on golden section search
b0 = 1; % upper bound on golden section search
rho = 0.382; % golden value
iterations = 200;

for ii = 1:iterations
    a1 = a0 + rho*(b0-a0);
    b1 = b0 - rho*(b0-a0);
    va1 = x - g*a1; 
    vb1 = x - g*b1; 
    ha1 = evalGradients_L2( va1,imageSize,b,m,lambda,D,W );
    hb1 = evalGradients_L2( vb1,imageSize,b,m,lambda,D,W );
    if ha1 >= hb1
        a0 = a1;
    else
        b0 = b1;
    end 
end
alpha = (a1+b1)/2;
end
