%%Find the L0 norm
A = [1,-2];
b = 2;
x = (-10:.01:10)';
y = 0.5*x-1; %1D solution to linear equation
X = [x,y];
X0 = X;
X0(X0~=0)=1; %turn nonzero values into 1's
L0 = abs(sum(X0,2)); %L0 norm
[min0,ind0] = min(L0); %NOT THE ONLY MIN
plot(x,L0)
hold on
%%Find the L1 norm
X1 = X;
L1 = abs(sum(X1,2));
[min1,ind1] = min(L1);
plot(x,L1)
%%Find the L2 norm
X2 = X;
L2 = rssq(X2,2);
[min2,ind2] = min(L2);
plot(x,X2);
%%Find the L_inf norm
X8 = X;
L8 = max(X8,[],2);
[min8,ind8] = min(L8);
