A = [1 2 3;0 2 1;4 0 1];
C = [400 0 0;0 20 0;0 0 1];
b = [100;100;100];
Q = A'*C*A;

iters = 500;
x = zeros(3,iters); %initialize solution (initial guess [0;0;0])
f = zeros(1,iters); %initialize function output (value of function at x)
    % f(x) = (1/2)*x'*Q*x - x'*b
    

%% Part A (Steepest Descent)
alpha = 
for i=1:iters
    
    f(i) = 0.5*(x(:,i)')*Q*(x(:,i)) - (x(:,i))'*b;
end 
solution = x(:,iters);
