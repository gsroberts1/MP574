sigma1 = 1;
sigma2 = 500;
lambda = (sigma1.^2)/(sigma2.^2);
A = [1 1 0;1 0 1;0 1 1];
b = [3;4;5];
x_ml = inv(A'*A)*A'*b;
x_map = inv((A'*A)+(lambda*eye(3)))*(A'*b);
           