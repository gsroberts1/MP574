%% Region Growing Segmentation Algorithm
%
% Authors:      Tim Ruesink (truesink@wisc.edu)
%               Lawrence Lechuga (llechuga@wisc.edu)
%               Grant Roberts (gsroberts@wisc.edu)
% Institution:  University of Wisconsin - Madison
% Department:   Mechanical Engineering and Medical Physics
% Last Update:  05/01/2019
% Built for:    MATLAB 2018
%
% Performs region-growing (RG) using a simplified Mumford-Shah functional.
% Initialization is done using region-growing ('grayconnect' function)
% based on a given pixel-value tolerance (tol). Further segmentation is 
% done by proposing a merging of two neighboring regions and evaulating if
% this proposed merge decreases the simplified MS functional of the image.
% This process is done iteratively for every initial region. Regularization
% parameter (nu) controls # of regions by weighting region length term.
% Simplified MS: norm(trueImage-approxImage) + length(regions)
%   where: approxImage is a piecewise-constant approximation of true image
%   based on average pixel value in region, and length of regions is the
%   total perimeter length of all regions.
% 
% Inspired by: Georges Koepfler and Russell Valentine
% https://coldstonelabs.org/files/science/math/Intro-MS-Valentine.pdf
% http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.53.1631&rep=rep1&type=pdf

%% Import Data
% Reads in PNG, MAT, or DICOM files
cd('images')
file = 'brain8.mat'; % Name of image file in current directory
if sum(contains(file,'png'))
    rawImage = imread(file);            % read png file
elseif sum(contains(file,'mat'))
    rawImage = load(file);              % load mat file
    rawImage = struct2array(rawImage);
elseif sum(contains(file,'dcm'))
    rawImage = dicomread(file);         % import dcm file
else 
    disp('Could not recognize file type. Only reads PNG, MAT, and DICOM files');
end 
cd('..');
%% Assign variables and initialize matrices
nu = 0.1; % regularization parameter
tol = max(rawImage(:))*0.1; % initial RG tolerance, merge pixels w/in tol
trueImage = double(rawImage); % input image

%% Initialize Segmentation
regions = init_seg(trueImage,tol); % initial set of regions
[approxImage,totaLength] = approximateFull(regions,trueImage); % create initial segmentation
f_init = approxImage; % grab initial approximation
L = getAllLengths(regions); % array of region edge lengths
E = cost(approxImage,trueImage,totaLength,nu); % compute the cost (mumford shah)
%% Merge Regions
labels = unique(regions); % get region labels
N_regions = length(labels); % number of regions in initial segementation
L_temp = L;
k = 1;
fig2 = figure(2);
fig2.Position = [50 700 1400 400];
for r = 1:N_regions
    if ismember(r,labels) % if this region still exists
        added = [];
        for p = 1:N_regions
            added_p = added; % used to test if no regions are added (break)
            [regions_temp,added] = merge(regions, r, added); % merge adjacent regions
            proposedAdd = added(end); % proposed region addition
            L_temp(r) = edgeLength(r,regions_temp); % set new individual region length
            L_temp(proposedAdd) = 0; % set merged region length to zero
            totaLength = sum(L_temp); % total length
            % [approxTemp,~] = approximateFull(regions,trueImage); % create approximate image
            approxTemp = approximate(r,proposedAdd,regions,approxImage); % create approximate image
            E2 = cost(approxTemp,trueImage,totaLength,nu); % calculate cost
            if (E2-E(k) < 0) % does the cost decrease by merging the new region?
                k = k+1;
                regions = regions_temp; % if so, lets change our regions
                L = L_temp;
                E(k) = E2; % add result to energy array
                labels = unique(regions);
                approxImage = approxTemp;
                
                % Updated regions and energy figures
                subplot(1,3,1); imagesc(regions); title('Regions')
                subplot(1,3,2); plot(1:1:length(E),E); title('Energy'); xlabel('Merging Operations'); ylabel('Energy')
                subplot(1,3,3); bar(length(labels)); set(gca,'xticklabel','Number of Regions')
                drawnow
                
                % Display outputs
                disp(['Iteration: ',num2str(r),'. Region ',num2str(added(end)), ' added to region ', num2str(r),'. attempted merge: ',num2str((p))])
            elseif size(added_p) == size(added)
                disp(['Iteration: ',num2str(r),'. There are no more adjacent regions next to region ', num2str(r),'. attempted merge: ',num2str((p))])
                break
            else
                disp(['Iteration: ',num2str(r),'. Region ',num2str(added(end)), ' NOT added to region ', num2str(r),'. attempted merge: ',num2str((p))])
                L_temp = L;
            end
        end
    end
end
f_final = approxImage;
regions_final = regions;
N_regions = length(labels);

figure; 
subplot(1,3,1); imshow(trueImage,[]); title('Image')
subplot(1,3,2); imshow(f_init,[]); title('Initalization')
subplot(1,3,3); imshow(f_final,[]); title('Final Segmentation')

