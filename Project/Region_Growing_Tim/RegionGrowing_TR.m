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

[f_init,L] = segment(regions,g); % create initial segmentation

E1 = cost(f_init,g,L,nu); % compute the cost

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
fig3.Position = [100 100 550 250];
% filename = 'RG5_figure.gif'; % set gif filename

idx = 0;
for r = 1:N_regions
    if ismember(r,labels)
        added = r;
        for p = 1:N_regions
%             disp(num2str(r))
            idx = idx+1;
            added_p = added;
            [regions_temp,added] = merge(regions, r, added);
            [f,L] = segment(regions_temp,g);
            [E2,data_term(idx),edge_term(idx)] = cost(f,g,L,nu);
            energy(idx) = E2;
            subplot(1,2,1)
            imagesc(regions_temp,[0 357]);
            title('Regions')
            subplot(1,2,2)
            plot(1:1:(idx),data_term,1:1:idx,edge_term,1:1:idx,energy)
            title('Energy')
            xlabel('Merging Operations')
            ylabel('Energy')
            legend('Data Term','Edge Term','Total Energy')
            drawnow
%             frame = getframe(fig3);
%             im{idx} = frame2im(frame);
            if (E2-E1 < 0)
                k = k+1;
                regions = regions_temp;
                E1 = E2;
                E(k) = E1;
                labels = unique(regions);
                N_regions = length(labels);
                
%                 subplot(1,3,1)
%                 imagesc(regions,[0 357]);
%                 title('Regions')
%                 subplot(1,3,2)
%                 plot(1:1:length(E),E)
%                 title('Energy')
%                 xlabel('Merging Operations')
%                 ylabel('Energy')
%                 subplot(1,3,3)
%                 bar(N_regions)
%                 ylim([0 357])
%                 set(gca,'xticklabel','Number of Regions')
%                 drawnow
                disp(['Iteration: ',num2str(idx),'. Region ',num2str(added(end)), ' added to region ', num2str(r),'. attempted merge: ',num2str((p))])
            elseif size(added_p) == size(added)
                disp(['Iteration: ',num2str(idx),'. There are no more adjacent regions next to region ', num2str(r),'. attempted merge: ',num2str((p))])
%                 pause(1)
                break
            else
                disp(['Iteration: ',num2str(idx),'. Region ',num2str(added(end)), ' NOT added to region ', num2str(r),'. attempted merge: ',num2str((p))])
            end
        end
    end
end

% for n = 1:idx
%     [A,map] = rgb2ind(im{n},256);
%     if n == 1
%         imwrite(A,map,filename,'gif','Loopcount',inf,'DelayTime',.15);
%     else
%         imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',.15);
%     end
% end

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

