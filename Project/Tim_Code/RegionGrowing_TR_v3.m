%% Region Growing Segmentation Algorithm

clear all 
close all

%% ------------------------------------------------------------------------
% Read in image
%--------------------------------------------------------------------------

file = 'brain256.png'; % name of image file
im_init = imread(file); % read png file to matlab

if size(im_init,3) == 1
    im_gray = im_init; % if the image is already grayscale
else
    im_gray = rgb2gray(im_init); % converts to grayscale if not rgb
end
[m,n] = size(im_gray); % dimensions of the image

%% ------------------------------------------------------------------------
% Initialize segmentation
%--------------------------------------------------------------------------

nu = .3; % set the edge term weighting factor
g = double(im_gray); % true image
f = zeros(size(g)); % initialize segmentation
regions = init_seg(g); % creates the initial set of regions

% create a figure showing the inital set of regions
fig1 = figure(1);
imagesc(regions)
title('labeled regions')
axis square

f_init = segment(regions,g); % create initial segmentation
g = g(:); % vectorize g
L = edgeLength2(regions); % create vector which contains edge lengths for inital regions
len = sum(L); % total length of inital set of regions
E1 = cost(f_init,g,len,nu); % compute the initial cost

%% ------------------------------------------------------------------------
% Merge regions
%--------------------------------------------------------------------------
labels = unique(regions); % vector of all labels in set of regions
N_regions = length(labels); % # of regions in initial segementation
k=1; % create index for keeping track of energy for added regions
E(k) = E1; % initial energy
L_temp = L; % set temporary length vector to inital length vector
idx = 0; % set iteration index equal to zero

% Create figure to update during region growin operations
% fig3 = figure(3);
% fig3.Position = [100 350 1200 350];
f = f_init;
tic % start timer
% begin merging operations
for r = 1:N_regions % for every region 
    if ismember(r,labels) % test to see if the region exists in the current set of labels
        added = []; % initialize added, a variable which stores the merged regions (added or not added)
        for p = 1:N_regions % merge every possible region with current region
            idx = idx+1; % advance interation index
            [regions_temp,added,flag] = merge(regions, r, added); % merge first adjacent region found
            L_temp(r) = edgeLength(r,regions_temp); % update region length to include merged region
            L_temp(added(end)) = 0; % set merged region length to zero
            len = sum(L_temp); % total length of new set of regions
            f_temp = segment2(f,regions_temp,r,g); % update segmentation based on region merge operation
            [E2,data_term(idx),edge_term(idx)] = cost(f_temp,g,len,nu); % compute cost of new regions
            energy(idx) = E2; % energy to plot
            
            % figure to plot energy terms as a function of overal
            % iterations
%             subplot(1,2,1)
%             imagesc(regions_temp,[0 357]);
%             title('Regions')
%             subplot(1,2,2)
%             plot(1:1:(idx),data_term,1:1:idx,edge_term,1:1:idx,energy)
%             title('Energy')
%             xlabel('Merging Operations')
%             ylabel('Energy')
%             legend('Data Term','Edge Term','Total Energy')
%             drawnow
%             frame = getframe(fig3);
%             im{idx} = frame2im(frame);
            if (E2-E1 < 0) % if the energy of new segmentation is less than that of the old
                k = k+1; % update energy index 
                regions = regions_temp; % set temporary region to the new regions
                L = L_temp; % set the temporary length to the new length vector
                f = f_temp; % set the temporary segmentation equal to the new segmentation
                E1 = E2; % set the temporary energy to the new energy
                E(k) = E1; % energy to plot
                labels = unique(regions); % update the labels vector
                N_regions = length(labels); % update the number of regions
                
                % figure to plot only successful merge operations
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

                % display which region was added 
                disp(['Iteration: ',num2str(idx),'. Region ',num2str(added(end)), ' added to region ', num2str(r),'. attempted merge: ',num2str((p))])
            elseif flag == 0 % if no region was added, there are no adjacent region
                disp(['Iteration: ',num2str(idx),'. There are no more adjacent regions next to region ', num2str(r),'. attempted merge: ',num2str((p))])
                break % break out of the for loop because there are no more adjacent regions
            else % if the new set of regions did not decrease the cost function
                % display whcih region was NOT added
                disp(['Iteration: ',num2str(idx),'. Region ',num2str(added(end)), ' NOT added to region ', num2str(r),'. attempted merge: ',num2str((p))])
                L_temp = L; % reset the length vector becuase the region was not added
            end
        end
    end
end

f = reshape(f,[m,n]);
g = reshape(g,[m,n]);
f_init = reshape(f_init,[m,n]);

toc

fig5 = figure(5);
subplot(1,3,1)
imshow(uint8(g))
title('image')
subplot(1,3,2)
imshow(uint8(f_init))
title('initalization')
subplot(1,3,3)
imshow(uint8(f))
title('Final segmentation')

