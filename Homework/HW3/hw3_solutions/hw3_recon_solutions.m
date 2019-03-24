%% Load data
clear
load hw3_problem3.mat % Pick right mat file to load for problem 1-2-3
data = b;
lambda = 10^8; % lambda=0 is problem 1, lambda>0 is problems 2 and 3
INIT_ZEROFILLED = 1; % Whether to initialize with the zero-filled ifft solution 
niter = 100; % Number of overall iterations
niterGS = 100; % Number of golden section search iterations for SD
s1 = 320; s2 = 320;
if ~exist('w')
    w = ones(s1*s2,1);
end

% Create D
D = 2*eye(s1) - circshift(eye(s1),[0, -1]) - circshift(eye(s1),[0, 1]);
D = sparse(D); 
I = speye(s1);
D2 = kron(I,D) + kron(D,I);

%% Zero-filled solution (also LS solution)
fx1 = zeros([s1,s2]);
fx1(m) = data;
x1 = fftshift(ifft2(ifftshift(fx1)));



%% Start running SD
if INIT_ZEROFILLED > 0
    x = x1(:);
else
    x = zeros([s1*s2,1]);
end

allfSD = [];

tic
% Steepest descent with golden section search
x = x(:);
for k=1:niter
    [f,g] = evalGradients2(x, [s1,s2], data, m, lambda, D2,w);
    if norm(g)>1e-6
        d = -g;
        a0 = 0;
        b0 = 1;
        newfa1 = NaN;
        newfb1 = NaN;
        for kg=1:niterGS
            a1 = x + d*a0 + d*(b0-a0)*0.382;
            b1 = x + d*a0 + d*(b0-a0)*0.618;
            if ~isnan(newfa1)
                fa1 = newfa1;
            else
                fa1 = evalGradients2(a1, [s1,s2], data, m, lambda, D2,w);
            end
            if ~isnan(newfb1)
                fb1 = newfb1;
            else
                fb1 = evalGradients2(b1, [s1,s2], data, m, lambda, D2,w);
            end
            if fb1<fa1
                a0 = a0 + 0.382*(b0-a0);
                newfa1 = fb1;
                newfb1 = NaN;
            else
                b0 = a0 + 0.618*(b0-a0);
                newfb1 = fa1;
                newfa1 = NaN;
            end
        end
        alpha = (a0+b0)/2;
        allfSD = [allfSD,f];
        x = x +alpha*d;
        
    else
        k = niter;
    end
    
end

[f,g] = evalGradients2(x, [s1,s2], data, m, lambda, D2,w);
allfSD = [allfSD,f];
xSD = reshape(x,[s1,s2]);

toc

%% Start running CG
if INIT_ZEROFILLED > 0
    x = x1(:);
else
    x = zeros([s1*s2,1]);
end

allfCG = [];

tic

% Conjugate Gradients
x = x(:);
k=0;
[f,g] = evalGradients2(x, [s1,s2], data, m, lambda, D2,w);
allfCG = [allfCG,f];
if norm(g)>1e-6
    d = -g;
    while k<=niter
        fd = fftshift(fft2(ifftshift(reshape(d,[s1,s2]))));
        fxfd = s1*s2*fftshift(ifft2(ifftshift(fd.*reshape(m,[s1 s2]))));
        Qd = fxfd(:) + lambda*D2'*(conj(w).*w.*(D2*d(:)));
        a = -(g'*d)/(d'*Qd);
        x = x + a*d;
        [f,g] = evalGradients2(x, [s1,s2], data, m, lambda, D2,w);
        allfCG = [allfCG,f];
        if norm(g)>1e-6
            b = (g'*Qd)/(d'*Qd);
            d = -g + b*d;
        else
            k=niter;
        end
        k=k+1;
    end
end
xCG = reshape(x,[s1,s2]);

toc


%% Display results
fs = 24;
figure(1)
imagesc(cat(2,abs(xSD), abs(xCG)),[0 1]);axis equal tight off; colormap gray
figure(2)
semilogy(0:(length(allfSD)-1),allfSD,'LineWidth',3)
hold on
semilogy(0:(length(allfCG)-1),allfCG,'LineWidth',3)
legend('SD','CG')
hold off
xlabel('Iterations','FontSize',fs);
ylabel('Cost','FontSize',fs);
set(gca,'FontSize',fs);
%axis([0 3 1395.55 1395.8])




