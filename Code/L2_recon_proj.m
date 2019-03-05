% File Name: L2_recon_proj.m
% Description: Example L2-regularized reconstruction from projections
% Author: Diego Hernando
% Date created: 2/26/19
% Date last modified: 3/2/19


%% Options for this code
N = 128; % Size of image (NxN)
theta = 0:1:179; % Projection angles to be used
noise_std = N*0.01; % How much noise to add to the data
lambda = 1000; % Regularization parameter
WEIGHTED_REG = 1; % Use locations of known edges to weight the regularization
ALGO = 2; % Algorithm - 1: SD, 2: CG
niter = 50; % Number of algorithm iterations



%% Create data
rng(2); % Initialize random number generator
im_mr = phantom(N);
im_mr = im_mr/max(abs(im_mr(:)));
im_mr1 = im_mr; % Noiseless
[s1,s2] = size(im_mr);
Nangle = length(theta);
data = radon(im_mr,theta);
data_noiseless = data;
data = data + noise_std*randn(size(data));

% Direct (FBP) reconstruction
x1 = iradon(data,theta,'linear','Cosine',1,N);

% Create D (finite differences matrix)
D = 2*eye(s1) - circshift(eye(s1),[0, -1]) - circshift(eye(s1),[0, 1]);
D = sparse(D); 
I = speye(s1);
D2 = kron(I,D) + kron(D,I);

% Generate an edge map for edge-constrained weighted regularization
edgeMap = abs(D2*im_mr1(:));
edgeMap = edgeMap/max(edgeMap(:));
edgeMap = edgeMap>0.1;
w = double(~edgeMap); % Do not penalize previously known edges
if WEIGHTED_REG <= 0 % If not using edge weights, set these to all ones
    w = ones(size(w));
end

%% Start running
x = zeros([s1*s2,1]);
allf = [];



tic % Let's measure the processing time (should be different for SD vs CG)
switch ALGO
    case 1
        % Steepest descent with golden section search
        niterGS = 60;
        x = x(:);
        for k=1:niter % SD Iterations
            [f,g] = evalGradientsProj(x, [s1,s2], data, theta, lambda, D2,w);
            d = -g;
            a0 = 0;
            b0 = 1;
            newfa1 = NaN;
            newfb1 = NaN;
            for kg=1:niterGS % Golden section search iterations
                a1 = x + d*a0 + d*(b0-a0)*0.382;
                b1 = x + d*a0 + d*(b0-a0)*0.618;
                if ~isnan(newfa1)
                    fa1 = newfa1;
                else
                    fa1 = evalGradientsProj(a1, [s1,s2], data, theta, lambda, D2,w);
                end
                if ~isnan(newfb1)
                    fb1 = newfb1;
                else
                    fb1 = evalGradientsProj(b1, [s1,s2], data, theta, lambda, D2,w);
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
            allf = [allf,f];
            x = x +alpha*d;
        end
        
        [f,g] = evalGradientsProj(x, [s1,s2], data, theta, lambda, D2,w);
        allf = [allf,f];
        x = reshape(x,[s1,s2]);
        
    case 2 % Conjugate gradients
        x = x(:);
        k=0;
        [f,g] = evalGradientsProj(x, [s1,s2], data, theta, lambda, D2,w);
        allf = [allf,f];
        if norm(g)>1e-6
            d = -g;
            while k<=niter
                fd = radon(reshape(d,[s1,s2]),theta);
                fxfd = 2/pi*Nangle*iradon(fd,theta,'spline','none',1,N);;
                Qd = fxfd(:) + lambda*D2'*(conj(w).*w.*(D2*d(:)));
                a = -(g'*d)/(d'*Qd);
                x = x + a*d;
                [f,g] = evalGradientsProj(x, [s1,s2], data, theta, lambda, D2,w);
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
        x = reshape(x,[s1,s2]);
end
toc % How long did this take? 

%% Show images
colorscale = [0,1.1];
figure(1)
subplot(1,3,1);
imagesc(abs(im_mr),colorscale);
axis equal tight off
title('Original Image');set(gca,'FontSize',16)
subplot(1,3,2);
imagesc(abs(x1),colorscale)
axis equal tight off
title('Direct Recon');set(gca,'FontSize',16)
subplot(1,3,3);
imagesc(abs(x),colorscale);
axis equal tight off
title('Optimization-Based Recon');set(gca,'FontSize',16)

figure(2);
semilogy(0:(length(allf)-1),allf,'LineWidth',3)
xlabel('Iterations','FontSize',16);
ylabel('Cost','FontSize',16);
set(gca,'FontSize',16);



