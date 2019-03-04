function [f,g,H] = evalGradients(x)

A = [1 2 3; 0 2 1; 4 0 1];
Q = A'*diag([400,20,1])*A;
%Q = A'*diag([20,20,20])*A; % Uncomment this line for question 2D
d = [100; 100; 100];

% Cost function value
f = .5*x'*Q*x - x'*d;

% Gradient
g = Q*x - d;

% Hessian
H = Q;

