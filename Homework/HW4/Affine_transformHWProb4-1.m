% Affine Transform Script
I = fixed; 
%I =[0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 1 1 0 0; 0 0 1 1 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0] % Define the image
figure;subplot(2,2,1);imagesc(I); axis('image'); colormap('gray');title('Fixed') %Display the image
colorbar;

[xdim,ydim] = size(I)
theta = 0;
phi = 35;
delx = xdim/2;
dely = ydim/2;
mdelx = 10;
mdely = 10;
I_affine = zeros(xdim,ydim);
% Define the Transformation Matrix
T = [1 0 mdelx;0 1 mdely;0 0 1] % Translation 0
T2 = [1 0 delx; 0 1 dely; 0 0 1] % Translation 1
T1 = [1 0 -delx; 0 1 -dely; 0 0 1] % Translation 2
R = [cos(theta/180*pi) -sin(theta/180*pi) 0; sin(theta/180*pi) cos(theta/180*pi) 0; 0 0 1] % Rotation
S = [1 0 0;0 1 0;0 0 1] % Scaling
H_x = [1 tan(phi/180*pi) 0;0 1 0;0 0 1] % Shear in x only %tan(20/180*pi)
T_affine = S*H_x*R*T % Calculate the Affine Transformation Matrix

% Define indices of Coordinates to Transform
x = 1:length(I(:,1));
y = 1:length(I(1,:));
[X, Y] = meshgrid(x,y); % This automatically creates a matrix made up of the x and y coordinates
Z = ones(length(x),length(y));
clear Index;
Index(:,:,1) = X; 
Index(:,:,2) = Y;
Index(:,:,3) = Z;
Index; % The columns of this 3D matrix are the coordinates to transform

% Perform Affine Tranformation with Nearest Neighbor Interpolation
for j = 1:length(y),
    for i = 1:length(x),
        temp = Index(i,j,:); % temp is the column representing the coordinates 
        temp = squeeze(temp); % collapse to a 1X3 matrix
        Test = T_affine*temp; % apply the tranformation to the coordinates
        if round(Test(2))>0 & round(Test(1))>0 & round(Test(2))<xdim & round(Test(1))<xdim
            I_affine(round(Test(2)),round(Test(1))) = I(temp(2),temp(1));end;
        if round(Test(2))>0 & round(Test(1))>0 & round(Test(2))<xdim & round(Test(1))<xdim
            I_affine(round(Test(2))+1,round(Test(1))) = I(temp(2),temp(1));end;
        if round(Test(2))>0 & round(Test(1))>0 & round(Test(2))<xdim & round(Test(1))<xdim
            I_affine(round(Test(2))+1,round(Test(1))+1) = I(temp(2),temp(1));end;
        if round(Test(2))>0 & round(Test(1))>0 & round(Test(2))<xdim & round(Test(1))<xdim
            I_affine(round(Test(2)),round(Test(1))+1) = I(temp(2),temp(1));end;
        % round() performs the nearest neighbor interpolation
    end
end

% Display the transformed matrix
subplot(2,2,2);imagesc(I_affine); axis('image'); colormap('gray'); title('Transformed Image: NN Interpolation') %Display the image
colorbar;

I_affine = zeros(xdim,ydim);
% Perform Affine Tranformation with Bi-linear Interpolation
for j = 1:length(y),
    for i = 1:length(x),
        temp = Index(i,j,:); % temp is the column representing the coordinates 
        temp = squeeze(temp); % collapse to a 1 X 3 matrix
        Test = T_affine*temp; % apply the tranformation to the coordinates
        alpha = (Test(1)-floor(Test(1)));
        beta = (Test(2)-floor(Test(2)));
        w_11 = (1-alpha)*(1-beta);
        w_12 = alpha*(1-beta);
        w_22 = beta*alpha;
        w_21 = (1-alpha)*(beta);
        norm = w_11+w_12+w_22+w_21;
        if floor(Test(2))>0 & floor(Test(1))>0 & floor(Test(2))<xdim & floor(Test(1))<xdim
            I_affine(floor(Test(2)),floor(Test(1))) = I_affine(floor(Test(2)),floor(Test(1)))+ w_11*I(i,j);end;
        if floor(Test(2))>0 & ceil(Test(1))>0 & floor(Test(2))<xdim & ceil(Test(1))<xdim
            I_affine(floor(Test(2)),ceil(Test(1))) = I_affine(floor(Test(2)),ceil(Test(1)))+w_12*I(i,j);end;
        if ceil(Test(2))>0 & floor(Test(1))>0 & ceil(Test(2))<xdim & floor(Test(1))<xdim
            I_affine(ceil(Test(2)),floor(Test(1))) = I_affine(ceil(Test(2)),floor(Test(1)))+w_21*I(i,j);end;
        if ceil(Test(2))>0 & ceil(Test(1))>0 & ceil(Test(2))<xdim & ceil(Test(1))<xdim
            I_affine(ceil(Test(2)),ceil(Test(1))) = I_affine(ceil(Test(2)),ceil(Test(1)))+w_22*I(i,j); end;
        % load the values of the original matrix into the new coordinates
        % w_xx perform the bi-linear interpolation
    end
end

% Display the transformed matrix
subplot(2,2,3);imagesc(I_affine); axis('image'); colormap('gray'); title('Transformed Image: Bilinear Interpolation') %Display the image
colorbar;
%I_affine(1:6,1:6) = I_affine(1:6,1:6) + I;
%subplot(2,2,4);imagesc(I_affine); axis('image'); title('Sum Image') %Display the image
