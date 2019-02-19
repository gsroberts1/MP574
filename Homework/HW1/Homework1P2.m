%%Find the L0 norm
close all; close all;
A = [1,-2];
b = 2;
x = (-10:.1:10)';
y = 0.5*x-1; %1D solution to linear equation
X = [x,y];
X0 = X;
X0(X0~=0)=1; %turn nonzero values into 1's
L0 = abs(sum(X0,2));
[min0,ind0] = min(L0); %NOT THE ONLY MIN
plot(x,L0); hold on
%%Find the L1 norm
X1 = X;
L1 = sum(abs(X1),2);
[min1,ind1] = min(L1);
plot(x,L1)
%%Find the L2 norm
X2 = X;
L2 = rssq(X2,2);
[min2,ind2] = min(L2);
plot(x,L2);
%%Find the L_inf norm
X8 = X;
L8 = max(abs(X8),[],2);
[min8,ind8] = min(L8);
plot(x,L8)

[xx,yy] = meshgrid(x,x);
norm = sqrt((xx).^2+(yy).^2);
for i = 1:length(xx)
    for j = 1:length(yy)
        z = [xx(i);yy(j)];
        normC(i,j) = (A*z-2)==0;
        normC = double(normC);
    end 
end 
hold off
figure; surf(xx,yy,norm); hold on
normC = normC*20; %scale up the plane
surf(xx,yy,normC);
shading interp; title('L2 norm and constraint'); xlabel('x1'); ylabel('x2'); zlabel('L2-norm')
colormap bone;