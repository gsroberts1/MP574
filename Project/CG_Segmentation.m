phant = phantom; % Shepp-Logan phantom (256x256)
phant1 = imnoise(phantom,'Gaussian',0,0.0001);
phant2 = imnoise(phantom,'Gaussian',0,0.0005);
phant3 = imnoise(phantom,'Gaussian',0,0.001);
phant4 = imnoise(phantom,'Gaussian',0,0.01);
figure; subplot(2,2,1); imshow(phant1,[0 1])
subplot(2,2,2); imshow(phant2,[0 1])
subplot(2,2,3); imshow(phant3,[0 1])
subplot(2,2,4); imshow(phant4,[0 1])
