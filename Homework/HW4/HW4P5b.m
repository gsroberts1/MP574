%% HW P5b (L1 cost function)
% load('HW4-Image-Fixed.mat')
% load('HW4-Image-Moving.mat')
original = fixed; % original image
distorted = I2; % rotated image
figure; subplot(2,2,1); imshow(original);

ptsOriginal = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);
[featuresOriginal,validPtsOriginal] = extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = extractFeatures(distorted,ptsDistorted);
index_pairs = matchFeatures(featuresOriginal,featuresDistorted,'Metric','SAD','MatchThreshold',5);
matchedPtsOriginal = validPtsOriginal(index_pairs(:,1));
matchedPtsDistorted = validPtsDistorted(index_pairs(:,2));

subplot(2,2,2); showMatchedFeatures(original,distorted,matchedPtsOriginal,matchedPtsDistorted);
title('Matched SURF points,including outliers');
[tform,inlierPtsDistorted,inlierPtsOriginal] = estimateGeometricTransform(matchedPtsDistorted,matchedPtsOriginal,'similarity');

subplot(2,2,3); showMatchedFeatures(original,distorted,inlierPtsOriginal,inlierPtsDistorted);
title('Matched inlier points');

outputView = imref2d(size(original));
Ir = imwarp(distorted,tform,'OutputView',outputView);
subplot(2,2,4); imshow(Ir); 
title('Recovered image using L1 norm');