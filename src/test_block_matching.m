I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

blockSize = 9;
dispMax = 20;
seuilContrast = 0.05;

D = block_matching(I1, I2, blockSize, dispMax, seuilContrast);

figure;
imagesc(D); colormap jet; colorbar;
title("Raw Block Matching Disparity Map");
