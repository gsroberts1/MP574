function [BW2,I_mask,h1, h2] = bgthresh(I,visualize)
% Creates mask with simple threshold
% Outputs masked image, and the logical mask
% threshold value hardcoded here
% visualize == 1 will output figures
% Lawrence Lechuga


BW = im2bw(I,0.3);
BW2 = imfill(BW,'holes');

I_mask = I;
I_mask(BW2==0)=0;

if visualize == 1
    figure;
    subplot(1,3,1)
    h1 = imshow(BW2,[]);
    title('Logical Mask')
    subplot(1,3,2)
    h2 = imshow(I_mask,[]);
    title('Mask Applied')
    subplot(1,3,3)
    imshow(I,[])
end

end

