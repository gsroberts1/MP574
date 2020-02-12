%% Region Growing Segmentation Algorithm

clear all 
close all

%% ------------------------------------------------------------------------
% Read in image
%--------------------------------------------------------------------------
tic
file = 'brain128.png'; % name of image file
im_rgb = imread(file); % read png file to matlab
% im_gray = rgb2gray(im_rgb); % converts rgb to grayscale 
im_gray = im_rgb;
[m,n] = size(im_gray); % dimensions of the image

%% ------------------------------------------------------------------------
% Initialize segmentation
%--------------------------------------------------------------------------
% im = ideal_image;
% im_gray = im;
nu = 0.4;
g = double(im_gray); % true image
f = zeros(size(g)); % initialize segmentation
regions = init_seg(g); % creates the initial set of regions

fig1 = figure(1);
imagesc(regions)
title('labeled regions')

f_init = segment2(regions,g); % create initial segmentation
L = edgeLength2(regions); 
length = sum(L);
E1 = cost(f_init,g,length,nu); % compute the cost

fig2 = figure(2);
imshow(uint8(f))
title('initial segementation')

%% ------------------------------------------------------------------------
% Merge regions
%--------------------------------------------------------------------------
labels = unique(regions);
N_regions = length(labels); % # of regions in initial segementation
k=1;
E(k) = E1;
fig3 = figure(3);
fig3.Position = [100 100 1100 700];
for r = 1:N_regions
    if ismember(r,labels)
        added = r;
        for p = 1:N_regions
            [regions_temp,added] = merge(regions, labels(r), added);
            L_old = edgeLength(labels(r),regions); % length of old region
            L_new = edgeLength(labels(r),regions_temp); % length of combined region
            L_sub = edgeLength(added(end),regions); % length of subtracted region
            L_temp = L - (L_old + L_sub) + L_new; % potential new length
            f = segment2(regions_temp,g);
            E2 = cost(f,g,L_temp,nu);
            if (E2-E1 < 0)
                k = k+1;
                regions = regions_temp;
                L = L_temp;
                E1 = E2;
                E(k) = E1;
                labels = unique(regions);
                N_regions = length(labels);
                subplot(1,2,1)
                imagesc(regions);
                subplot(1,2,2)
                plot(1:length(E),E)
                drawnow
                disp([num2str(N_regions), ' Regions, ','Length = ',num2str(L)])
                
            end
        end
    end
end
f_final = f;
fig4 = figure(4);
imshow(uint8(f))
title('final segmentation')
toc

fig5 = figure(5);
subplot(1,3,1)
imshow(uint8(g))
title('image')
subplot(1,3,2)
imshow(uint8(f_init))
title('initalization')
subplot(1,3,3)
imshow(uint8(f_final))
title('Final segmentation')

