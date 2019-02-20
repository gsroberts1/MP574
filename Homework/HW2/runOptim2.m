% A = [1 2 3;0 2 1;4 0 1];
% C = [400 0 0;0 20 0;0 0 1];
% b = [100;100;100];
% Q = A'*C*A;
% 
% iters = 500;
% x = zeros(3,iters); %initialize solution (initial guess [0;0;0])
% f = zeros(1,iters); %initialize function output (value of function at x)
%     f(x) = (1/2)*x'*Q*x - x'*b
%     
% 
% %% Part A (Steepest Descent)
% alpha = 0;
% for i=1:iters
%     f(i) = 0.5*(x(:,i)')*Q*(x(:,i)) - (x(:,i))'*b;
% end 
% solution = x(:,iters);

% initialize matrices and function
clear all
a = [1,2,3; 0,2,1; 4,0,1]; 
c = [400,0,0; 0,20,0; 0,0,1];
b = [100;100;100];
q = a'*c*a;
iters = 100;
X = zeros(3,iters);
f = @(x) (1/2*x'*q*x-x'*b); % function to minimize
df = @(x) (q*x-b);

for ii=1:iters
    a0 = -1000;
    b0 = 1000;
    alpha = goldensearch(f,df,X(ii),a0,b0,iters);
    X(:,ii+1) = X(:,ii) - alpha*df(X(:,ii));
end 
% for ii = 1:iters
%     x_in = x(:,ii);
%     [error,alpha] = goldensearch(f,df,x_in,a0,b0,10);

%     alpha
% end
