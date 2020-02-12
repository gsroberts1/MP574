%% usage: regions = mergeRegions(regionNumber, regions, image1, nu)
% Goes through and checks to see if a given region should merge with
%   any of its surrounding regions. It returns the resulting region
%   matrix from any merges.
% Arguments:
%   regionsNumber = The given region to see if any of its adjacent
%   regions = should be merged with it.
%   regions = A regions matrix
%   image1 = Our image matrix g
%   nu = The weight parameter \nu
function regions = mergeRegions(regionNumber, regions, image1, nu)
global im
global nn
    iteration = 0;
    imagesq = double(image1).^2;
    if(sum(sum(regions==regionNumber)) > 0)         
        disp('Merging new region!')
        dim = size(image1);       
        regionAdded = 1; %Reset already tried if a region was added
        area1 = regionArea(regionNumber, regions);
        sumg1 = sumG(regionNumber, regions, image1);
        f1 = sumg1/area1;
        borderLength1 = regionBorderLength(regionNumber, regions);
        while(regionAdded)
            alreadyTried = [];
            regionAdded = 0;
            iteration = iteration+1;           
            disp(['While-loop iteration number = ' num2str(iteration)]);
            fig_gif = figure;
            fig_gif.Position = [100 100 900 500]; % set size of figure 
            giffile = 'gif_figure.gif'; % set gif filename
            nn = 1;
                imagesc(regions,[0 26])
                axis square
                drawnow
                frame = getframe(fig_gif);
                im{nn} = frame2im(frame);         
            for x = 1:dim(1)  
                for y = 1:dim(2)   
                    if(regions(x,y)==regionNumber)
                        if((x>1) && (regions(x-1,y)~=regionNumber) && (sum(alreadyTried==regions(x-1,y)) == 0))
                            regionNum2 = regions(x-1,y);
                            [dE, area1, sumg1, f1, borderLength1, regions] = deltaE(regions,regionNumber, regionNum2, imagesq, image1, nu,[area1, sumg1, f1, borderLength1]);                                                          
                                imagesc(regions,[0 26])
                                axis square
                                drawnow
                                frame = getframe(fig_gif);
                                im{nn} = frame2im(frame);
                                nn = nn+1;
                            if(dE<0)
                                alreadyTried=[];
                                regionAdded=1;                           
                            else
                                alreadyTried=[alreadyTried,regionNum2];
                            end
                        end
                        
                        if((x<dim(1)) && (regions(x+1,y)~=regionNumber) && (sum(alreadyTried==regions(x+1,y)) == 0))
                            regionNum2=regions(x+1,y);
                            [dE, area1, sumg1, f1, borderLength1, regions] = deltaE(regions,regionNumber, regionNum2, imagesq, image1, nu,[area1, sumg1, f1, borderLength1]);
                                imagesc(regions,[0 26])
                                axis square
                                drawnow
                                frame = getframe(fig_gif);
                                im{nn} = frame2im(frame);
                                nn = nn+1;
                            if(dE<0)
                                alreadyTried=[];
                                regionAdded=1;
                            else
                                alreadyTried=[alreadyTried,regionNum2];
                            end
                        end
                        
                        if((y>1) && (regions(x,y-1)~=regionNumber) && (sum(alreadyTried==regions(x,y-1)) == 0))
                            regionNum2=regions(x,y-1);
                            [dE, area1, sumg1, f1, borderLength1, regions] = deltaE(regions,regionNumber, regionNum2, imagesq, image1, nu,[area1, sumg1, f1, borderLength1]);
                                imagesc(regions,[0 26])
                                axis square
                                drawnow
                                frame = getframe(fig_gif);
                                im{nn} = frame2im(frame);
                                nn = nn+1;
                            if(dE<0)
                                alreadyTried=[];
                                regionAdded=1;
                            else
                                alreadyTried=[alreadyTried,regionNum2];
                            end
                        end
                        
                        if((y<dim(2)) && (regions(x,y+1)~=regionNumber) && (sum(alreadyTried==regions(x,y+1)) == 0))
                            regionNum2=regions(x,y+1);
                            [dE, area1, sumg1, f1, borderLength1, regions] = deltaE(regions,regionNumber, regionNum2, imagesq, image1, nu,[area1, sumg1, f1, borderLength1]);
                                imagesc(regions,[0 26])
                                axis square
                                drawnow
                                frame = getframe(fig_gif);
                                im{nn} = frame2im(frame);
                                nn = nn+1;
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
            for jj = 1:nn-1
            [A,map] = rgb2ind(im{jj},256);
            if jj == 1
                imwrite(A,map,giffile,'gif','Loopcount',inf,'DelayTime',.0015);
            else
                imwrite(A,map,giffile,'gif','WriteMode','append','DelayTime',.0015);
            end
            end
        end %while loop
    end
end