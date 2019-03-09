%% Get data and parameters started
s1 = 128; % Size of image to simulate
s2 = s1;
lambda2 = 10^5; % Regularization parameter for L2 formulation
lambda = 10^2; % Regularization parameter for L1 formulation (different from L2, since scaling is different)

% Load some data and create auxiliary matrices
rng(0); % Control the random number generator for repeatable, yet random-looking, results
im_mr = phantom(s1);
im_mr = im_mr/max(abs(im_mr(:)));
im_mr1 = im_mr; % Noiseless
im_mr = im_mr1 + 0.0*randn(size(im_mr));
[s1,s2] = size(im_mr);
data = fftshift(fft2(ifftshift(im_mr)));

% Create subsampling mask
mask = [rand(s1,1)>0.53];
mask(round(s1*3/7):round(s1*4/7))=1;
mask = repmat(mask,[1 s2]);
mask = mask>0;

% Create the subsampled data using our mask
x1 = fftshift(ifft2(ifftshift(data.*mask)));
data = data(mask(:));
m = mask(:);

% Zero-padded solution
fx1 = zeros(s1,s2);
fx1(m) = data;
x1 = fftshift(ifft2(ifftshift(fx1)));

% Create D (Note this is a simple finite differences matrix)
D = eye(s1) - circshift(eye(s1),[0, -1]);
D = sparse(D); 
I = speye(s1);
D2 = [kron(I,D);kron(D,I)];

% Display our image and FFT, as well as subsampled data and edge locations
% (for reference)
figure(1)
fs = 16;
subplot(1,4,1)
imagesc(abs(im_mr));axis equal tight off; drawnow;pause(0.001);
title('True image');set(gca,'FontSize',fs)
subplot(1,4,2)
imagesc(log(abs(fftshift(fft2(ifftshift(im_mr))))));axis equal tight off; drawnow;pause(0.001);
title('2D DFT');set(gca,'FontSize',fs)
subplot(1,4,3)
imagesc(log(mask.*abs(fftshift(fft2(ifftshift(im_mr))))));axis equal tight off; drawnow;pause(0.001);
title('Subsampled 2D DFT');set(gca,'FontSize',fs)
dx = D2*im_mr(:);
dx = reshape(abs(dx(1:end/2)) + abs(dx(end/2+1:end)),[s1 s2]);
subplot(1,4,4)
imagesc(dx);axis equal tight off; drawnow;pause(0.001);
title('Edge Locations');set(gca,'FontSize',fs)



%% L2: start running (CG algorithm only)
x = 0.1+zeros(s1*s2,1);
%x = im_mr1(:); % Could also initialize with zero-padded solution
allf = [];
niter = 400;
w = ones(size(D2,1),1);

x = x(:);
k=0;
[f,g] = evalGradients_L2(x, [s1,s2], data, m, lambda2, D2,w);
allf = [allf,f];
if norm(g)>1e-6
    d = -g;
    while k<=niter
        fd = fftshift(fft2(ifftshift(reshape(d,[s1,s2]))));
        fxfd = s1*s2*fftshift(ifft2(ifftshift(fd.*reshape(m,[s1 s2]))));
        Qd = fxfd(:) + lambda2*D2'*(conj(w).*w.*(D2*d(:)));
        a = -(g'*d)/(d'*Qd);
        x = x + a*d;
        [f,g] = evalGradients_L2(x, [s1,s2], data, m, lambda2, D2,w);
        allf = [allf,f];
        if norm(g)>1e-6
            b = (g'*Qd)/(d'*Qd);
            d = -g + b*d;
        else
            k=niter;
        end
        k=k+1;
    end
end
xL2 = reshape(x,[s1,s2]);

% Display L2 results
figure(2)
subplot(1,4,1)
imagesc(abs(im_mr));axis equal tight off; drawnow;pause(0.001);
title('True image');set(gca,'FontSize',fs)
subplot(1,4,2)
imagesc(abs(x1));axis equal tight off; drawnow;pause(0.001);
title('Direct recon');set(gca,'FontSize',fs)
subplot(1,4,3)
imagesc(abs(xL2));axis equal tight off; drawnow;pause(0.001);
title(['L2 recon, \lambda = ' num2str(lambda2)]);set(gca,'FontSize',fs)
subplot(1,4,4)
imagesc(0*abs(xL2));axis equal tight off; drawnow;pause(0.001);




%% L1: start running (CG algorithm only)
x = zeros(s1*s2,1);
%x = im_mr1(:); % Could also initialize with zero-padded solution
allf = [];
niter = 150;

mu = 1e-6;

x = x(:);
k=0;
[f,g] = evalGradients_L1(x, [s1,s2], data, m, lambda, D2,mu);
allf = [allf,f];
if norm(g)>1e-6
    d = -g;
    while k<=niter

        % Line search for a
        a0 = 0;
        b0 = 1;
        for kg=1:60
            a1 = x + d*a0 + d*(b0-a0)*0.382;
            b1 = x + d*a0 + d*(b0-a0)*0.618;
            fa1 = evalGradients_L1(a1, [s1,s2], data, m, lambda, D2,mu);
            fb1 = evalGradients_L1(b1, [s1,s2], data, m, lambda, D2,mu);
            if fb1<fa1
                a0 = a0 + 0.382*(b0-a0);
            else
                b0 = a0 + 0.618*(b0-a0);
            end
        end
        alpha = (a0+b0)/2;
        
        x = x + alpha*d;
        
        gprevious = g;
        [f,g] = evalGradients_L1(x, [s1,s2], data, m, lambda, D2,mu);
         disp(['Iteration: ' num2str(k)  ' , cost = ' num2str(f)]);
        
        allf = [allf,f];
        if norm(g)>1e-6
            if rem(k+1,30)>0
                b = (g'*g)/(gprevious'*gprevious);
                d = -g + b*d;
            else
                d = -g;
            end    
        else
            k=niter;
        end
        k=k+1;


        % Display L1 results
        subplot(1,4,4)
        imagesc(abs(reshape(x,[s1 s2])));axis equal tight off; 
        title(['L1 recon']);set(gca,'FontSize',fs);drawnow;pause(0.001);

    end
end
xL1 = reshape(x,[s1,s2]);





