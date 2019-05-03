%% usage: [image1, regions] = segmentPNG(file, nu, statusOutput)
% Returns the grayscale intensity n by m image g and a segmented
%   region matrix. This should be the function that gets called first.
%   f and \Gamma (The border) could be generated with just these two,
%   the image and the regions).
% Arguments:
%   file = The filename of a png file to segment
%   nu = The weight parameter \nu
%   statusOutput = 0 to not display anything while working, 1 to
%       display percentage complete after going through a
%       region. The percentage is not accurate as the
%       later regions should move much faster. Also some
%       regions would have been absorbed while working on
%       a previous region, but it does give you a little
%       idea of how far along you are.
function [image1, regions] = segmentPNG(varargin)
    image1 = varargin{1};
    dims = size(image1);
    nu = varargin{2};
    statusOutput = varargin{3};
    if nargin==3
        regions = defaultRegions(dims);% returns the default matrix in which each pixel is a region
    elseif nargin==5 && strcmp(varargin{4},'kMeans')
        numInitRegions = varargin{5};
        image1Filt = imbilatfilt(image1);
        [C,~] = kmeans(image1Filt(:),numInitRegions,'MaxIter',10000);  
        regions = (reshape(C,dims)) - 1;
    elseif nargin==5 && strcmp(varargin{4},'ThreshFill')
        level = varargin{5};
        image1Filt = imbilatfilt(image1);
        BW = imbinarize(image1Filt,'adaptive','Sensitivity',level);
        BW = imfill(BW,'holes');
        regions = double(BW).*defaultRegions(dims);
    elseif nargin==4 && strcmp(varargin{4},'Otsu')
        image1Filt = imbilatfilt(image1);
        level = otsuthresh(image1Filt(:));
        BW = imbinarize(image1Filt,'adaptive','Sensitivity',level);
        regions = BW-1;
    end 
    
    numRegions = max(unique(regions)); % returns the initial number of regions
    disp(['    NUMBER OF TOTAL POSSIBLE REGIONS = ' num2str(numRegions)])
    for r = 0:numRegions  
        regions = mergeRegions(r, regions, image1, nu);
        if(statusOutput > 0)
            percent = floor(r*100/numRegions); % rounded percent
            if ~mod(r,ceil(0.01*numRegions)) % display every 1% approximately
                disp( ['Percent Complete:         ' num2str(percent)] )
            end 
        end
    end
    if(statusOutput > 0)
        disp('Consolidating Regions...')
    end
    regions = consolidateRegions(regions);
    disp('Finished Consolidating Regions')
end