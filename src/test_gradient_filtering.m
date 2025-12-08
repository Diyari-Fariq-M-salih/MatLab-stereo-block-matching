I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

blockSize = 9;
dispMax = 20;
seuilContrast = 0.05;

method = 'SAD';

% No gradient filtering (very low threshold)
gradThreshold_low = 0;
D_noGrad = block_matching(I1, I2, blockSize, dispMax, seuilContrast, method, gradThreshold_low);

% With gradient filtering
gradThreshold = 15;   % you can tune this
D_grad = block_matching(I1, I2, blockSize, dispMax, seuilContrast, method, gradThreshold);

figure;
subplot(1,2,1);
imagesc(D_noGrad); colormap jet; colorbar;
title('Without gradient filtering');

subplot(1,2,2);
imagesc(D_grad); colormap jet; colorbar;
title(sprintf('With gradient filtering (thr = %.1f)', gradThreshold));
sgtitle('Effect of Sobel gradient-based block selection');
