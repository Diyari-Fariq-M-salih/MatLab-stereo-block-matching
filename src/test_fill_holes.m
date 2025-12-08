I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

blockSize = 9;
dispMax = 20;
contrast = 0.05;
gradThr = 10;

D = block_matching(I1, I2, blockSize, dispMax, contrast, 'SAD', gradThr);
D_filled = fill_holes(D);

figure;

subplot(1,2,1);
imagesc(D); colormap jet; colorbar;
title('Raw disparity (with NaN holes)');

subplot(1,2,2);
imagesc(D_filled); colormap jet; colorbar;
title('After hole filling');
sgtitle("Effect of hole filling");
