% Lawrence Lechuga
% 04/10/2019
% MP 574 Project

%% Create shep-logan phantoms with added noise.
% Noiseless phantom
P0 = phantom('Modified Shepp-Logan',256);
% Noise-added phantom (gaussian noise with zero mean and var = 0.01
P1 = imnoise(P0, 'gaussian',0,0.003);
% plot the two phantoms
figure;
subplot(1,2,1)
imshow(P0,[])
title('Noiseless')
subplot(1,2,2)
imshow(P1,[])
title('Noise-Added')
%% smoothing noise with Edge preserving Bilateral filter
% homogenize the noise in the images with a preprocessing filter to the
% noiseless and the noisy phantoms
P0s = imbilatfilt(P0);
P1s = imbilatfilt(P1);

% display original and filtered images for noiseless phantom
figure;
subplot(1,2,1)
imshow(P0s,[])
title('Original')
subplot(1,2,2)
imshow(P0s,[])
title('Filtered')
% display original and filtered images for the noisy phantom
figure;
subplot(1,2,1)
imshow(P1,[])
title('Original')
subplot(1,2,2)
imshow(P1s,[])
title('Filtered')

% Histogram of noiseless image, both filtered and original
figure;
subplot(1,2,1)
imhist(P0)
xlim([-0.05 1.01])
title('Unfiltered')
subplot(1,2,2)
imhist(P0s)
xlim([-0.05 1.05])
title('Filtered')
sgtitle('Noiseless Images')
% Histogram of noisy image, both filtered and original
figure;
subplot(1,2,1)
imhist(P1)
xlim([-0.05 1.01])
title('Unfiltered')
subplot(1,2,2)
imhist(P1s)
xlim([-0.05 1.05])
title('Filtered')
sgtitle('Noise-Added Images')
% axes were adjust to show intensity at zero

Plarge = phantom('Modified Shepp-Logan',512);