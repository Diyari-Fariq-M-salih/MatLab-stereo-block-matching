I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

blockSize = 9;
dispMax = 20;
contrast = 0.05;
gradThr = 10;

method = 'SAD';

% Left disparity (I1 → I2)
DL = block_matching(I1, I2, blockSize, dispMax, contrast, method, gradThr);

% Right disparity (I2 → I1)
DR = block_matching(I2, I1, blockSize, dispMax, contrast, method, gradThr);

% LR consistency check
D_LR = lr_consistency(DL, DR, 1);  % tolerance = 1 pixel

figure;
subplot(1,3,1);
imagesc(DL); colormap jet; colorbar;
title("Left disparity (DL)");

subplot(1,3,2);
imagesc(DR); colormap jet; colorbar;
title("Right disparity (DR)");

subplot(1,3,3);
imagesc(D_LR); colormap jet; colorbar;
title("After LR consistency");

sgtitle("Left-Right Consistency Check");
