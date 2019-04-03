% Image Registration Script
load HW4-Image-Fixed.mat 
% Affine - Scaling, Rotation, shear and translation.
% use bilinear vs NN interpolation
%I = checkerboard; % Alternative test image...
I = fixed;

figure, imshow(I);
% Perform rigid transforms
J = imresize(I,0.6,'bilinear'); % Try varying the resize factor.
load HW4-Image-Moving.mat
K = I2;
%K = imrotate(J,15,'bilinear'); % Try varying the scale factor.
figure, imshow(K,[]);

%Register using rigid (scale, rotation, translation) inverse transform matrix based on control points
[input_points base_points] = cpselect(K,I,'Wait',true);
t = fitgeotrans(input_points,base_points,'nonreflectivesimilarity');
ss = t.T(2,1);
sc = t.T(1,1);
scale = sqrt(ss*ss + sc*sc) % Calculate scale of inverse tranform
angle = atan2(ss,sc)*180/pi % rotation angle (ignoring shear) of inverse
mserror_scale_rigid = sqrt((0.6-(scale-1))^2)
mserror_angle_rigid = sqrt((30+angle)^2)
recovered = imwarp(K,t,'OutputView',imref2d(size(I)));
figure, imshow(recovered,[]), title('Rigid') % compare recovered to I
falsecolorOverlay = imfuse(I,recovered);
figure, imshow(falsecolorOverlay,'InitialMagnification','fit'), title('Rigid Overlay');

% Register using Piecewise Affine - Local Scaling, Rotation, shear and translation
t = fitgeotrans(input_points,base_points,'affine');
recovered = imwarp(K,t,'OutputView',imref2d(size(I)));
ss = t.T(2,1);
sc = t.T(1,1);
scale = sqrt(ss*ss + sc*sc) % Calculate scale of inverse tranform
angle = atan2(ss,sc)*180/pi % rotation angle (ignoring shear) of inverse
mserror_scale_affine = sqrt((0.6-(scale-1))^2)
mserror_angle_affine = sqrt((30+angle)^2)
figure, imshow(recovered,[]), title('Affine') % compare recovered to I
falsecolorOverlay = imfuse(I,recovered);
figure, imshow(falsecolorOverlay,'InitialMagnification','fit'), title('Affine Overlay');

% Deformable transformation
t = fitgeotrans(input_points,base_points,'projective'); %cubic polynomial interpolation model
recovered = imwarp(K,t,'OutputView',imref2d(size(I)));
ss = t.T(2,1);
sc = t.T(1,1);
scale = sqrt(ss*ss + sc*sc) % Calculate scale of inverse tranform
angle = atan2(ss,sc)*180/pi % rotation angle (ignoring shear) of inverse
mserror_scale_proj = sqrt((0.6-(scale-1))^2)
mserror_angle_proj = sqrt((30+angle)^2)
figure, imshow(recovered,[]), title('Projective') % compare recovered to I
falsecolorOverlay = imfuse(I,recovered);
figure, imshow(falsecolorOverlay,'InitialMagnification','fit'), title('Projective Overlay');