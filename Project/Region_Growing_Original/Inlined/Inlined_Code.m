% Algorithm Implementation for MATH648 Project
% written by Russell Valentine
% Requirements: Octave with Octave-Forge extentions
% See: http://www.gnu.org/software/octave/
%
% This Algorithm is a region merging algorithm using the simplified Mumford Shah.
%
% See: G. Koepfler, C. Lopez and J. Morel. A multiscale Algorithm for
% Image Segmentation by Variational method. SIAM Journal of Numerical
% Analysis, vol 31, pp 282-299, 1994.

%% Find image

nu = 10; % reg. parameter for number of borders
folder = 'images';
addpath('images');
file = 'phant256noisy01Filt';
extension = '.png';
filename = [file extension];
filepath = fullfile(folder,filename);
image1 = imread(filepath);  % read in png image
if ndims(image1)>2 % if the image is RGB ..
    image1 = rgb2gray(imread(filepath)); % read in the file and turn to gravalues
end 
cd('Inlined')
%% Segmentation

%%% SegmentPNG
dim = size(image1);
%%% Default Regions
regions = zeros(dim);
count = 0;
for x = 1:dim(1)
    for y = 1:dim(2)
        regions(x,y) = count;
        count = count+1;
    end
end
numRegions = max(regions(:)); % returns the initial number of regions
for regionNumber = 0:numRegions
    %%% Merge Regions
    iteration = 0;
    if(sum(sum(regions==regionNumber)) > 0)    
        regionAdded = 1; %Reset already tried if a region was added
        %%% Region Area
        area1 = sum(sum(regions==regionNumber));
        %%% Sum G 
        sumg1 = sum(sum(image1(regions==regionNumber)));
        f1 = sumg1/area1;
        borderLength1 = regionBorderLength(regionNumber, regions);
        while(regionAdded)
            alreadyTried = [];
            regionAdded = 0;
            iteration = iteration+1;
            for x = 1:dim(1)  
                for y = 1:dim(2)     
                    if(regions(x,y)==regionNumber)
                      
                        if((x>1) && (regions(x-1,y)~=regionNumber) && (sum(alreadyTried==regions(x-1,y)) == 0))
                            regionNum2 = regions(x-1,y);
                            [dE, area1, sumg1, f1, borderLength1, regions] = deltaE(regions,regionNumber, regionNum2, image1, nu,[area1, sumg1, f1, borderLength1]);
                            if(dE<0)
                                alreadyTried=[];
                                regionAdded=1;
                            else
                                alreadyTried=[alreadyTried,regionNum2];
                            end
                        end
                        
                        if((x<dim(1)) && (regions(x+1,y)~=regionNumber) && (sum(alreadyTried==regions(x+1,y)) == 0))
                            regionNum2=regions(x+1,y);
                            [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions,regionNumber, regionNum2, image1, nu,[area1, sumg1, f1, borderLength1]);
                            if(dE<0)
                                alreadyTried=[];
                                regionAdded=1;
                            else
                                alreadyTried=[alreadyTried,regionNum2];
                            end
                        end
                        
                        if((y>1) && (regions(x,y-1)~=regionNumber) && (sum(alreadyTried==regions(x,y-1)) == 0))
                            regionNum2=regions(x,y-1);
                            [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions,regionNumber, regionNum2, image1, nu,[area1, sumg1, f1, borderLength1]);
                            if(dE<0)
                                alreadyTried=[];
                                regionAdded=1;
                            else
                                alreadyTried=[alreadyTried,regionNum2];
                            end
                        end
                        
                        if((y<dim(2)) && (regions(x,y+1)~=regionNumber) && (sum(alreadyTried==regions(x,y+1)) == 0))
                            regionNum2=regions(x,y+1);
                            [dE, area1, sumg1, f1, borderLength1, regions]=deltaE(regions,regionNumber, regionNum2, image1, nu,[area1, sumg1, f1, borderLength1]);
                            if(dE<0)
                                alreadyTried=[];
                                regionAdded=1;
                            else
                                alreadyTried=[alreadyTried,regionNum2];
                            end
                        end
                        
                    end
                end % for loop (y)
            end % for loop (x)
        end %while loop
    end
end

%%% Consolidate Regions
    ur = sort(unique(regions))';
    count = 0;
    for i = ur
        if(i ~= count)
            regions(regions==i) = count;
        end
        count = count+1;
    end
%% Save Segmented Images

img = double(image1);
%%% Get F
f = zeros(size(image1));
for r = sort(unique(regions))'
    f(regions==r) = sum(sum(image1(regions==regionNumber))) / sum(sum(regions==regionNumber));
end
%%% Get Border
b = ones(size(regions));
dim = size(regions);
for regionNumber = sort(unique(regions))'
    for x = 1:dim(1)
        for y = 1:dim(2)
            if(regions(x,y)==regionNumber)
                if((x>1) && (regions(x-1,y) > regionNumber))
                    b(x,y) = 0;
                end
                if((x<dim(1)) && (regions(x+1,y) > regionNumber))
                    b(x,y) = 0;
                end
                if((y>1) && (regions(x,y-1) > regionNumber))
                    b(x,y) = 0;
                end
                if((y<dim(2)) && (regions(x,y+1) > regionNumber))
                    b(x,y) = 0;
                end
            end
        end
    end
end
b = b*255;  

imageStruct.img = img; 
imageStruct.f = f; 
imageStruct.b = b; 
imageStruct.regions = regions;
cd('../Output Images')
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