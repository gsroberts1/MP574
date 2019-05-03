% This Algorithm is a region merging algorithm using the simplified Mumford Shah.
%
% See: G. Koepfler, C. Lopez and J. Morel. A multiscale Algorithm for
% Image Segmentation by Variational method. SIAM Journal of Numerical
% Analysis, vol 31, pp 282-299, 1994.

%% Segmentation
tic %%%% Start timer
nu = 900; % decrease to get more regions
folder = 'images';
addpath('images');
%%%% ENTER FILE NAME HERE %%%%%
file = 'brain2_256';
extension = '.png';
filename = [file extension];
filepath = fullfile(folder,filename);
image1 = imread(filepath);  % read in png image
% test = [1 2 1 5 4;0 0 1 12 10;3 9 24 56 48;0 1 16 103 84;0 4 21 95 128];
% image1 = test;
if ndims(image1)>2 % if the image is RGB ..
    image1 = rgb2gray(imread(filepath)); % read in the file and turn to gravalues
end   
[image1, regions] = segmentPNG(image1, nu, 1);
%% Save Sgmented Images
img = double(image1);
f = getF(regions, image1);
b = getBorder(regions)*255;
imageStruct.img = img; 
imageStruct.f = f; 
imageStruct.b = b; 
imageStruct.regions = regions;
cd('Output Images')
mkdir(file);
cd(file)

save('image.mat', 'imageStruct');
cmap = colormap('colorcube');
figure; subplot(1,4,1); imshow(img,[]); title('Original Image (g)');
subplot(1,4,2); imshow(regions,cmap); title('Regions (f_i)');
subplot(1,4,3); imshow(f,[]); title('Piecewise Constant Approximation (f \epsilon \Omega)');
subplot(1,4,4); imshow(b,[]); title('Boundaries (\Gamma)');
saveas(gcf,['figureSummary' num2str(nu) '.png']); savefig(['figureSummary' num2str(nu)]);
imwrite(regions, cmap, [file '-region-' num2str(nu) '.png']);
imwrite(uint8(img), [file '-grayG-' num2str(nu) '.png']);
imwrite(uint8(f), [file '-f-' num2str(nu) '.png']);
imwrite(uint8(b), [file '-border-' num2str(nu) '.png']);
cd('../..')
toc %%%% End timer