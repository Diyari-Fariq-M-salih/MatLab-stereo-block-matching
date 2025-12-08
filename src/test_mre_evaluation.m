% Load images
I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

% Ground truth (scaled)
D_gt = double(imread('data/disp2.pgm')) / 8;

% Generate disparity (example)
DL = block_matching(I1, I2, 9, 20, 0.05, 'SAD', 10);
DL_filled = fill_holes(DL);

% Compute MRE
mre_value = mre_evaluation(DL_filled, D_gt);

fprintf("MRE (Mean Relative Error): %.4f\n", mre_value);
absError = abs(DL_filled - D_gt);
absError(isnan(absError)) = 0;

figure;
subplot(1,3,1);
imagesc(DL_filled); colormap jet; colorbar;
title("Estimated disparity");

subplot(1,3,2);
imagesc(D_gt); colormap jet; colorbar;
title("Ground truth disparity");

subplot(1,3,3);
imagesc(absError); colormap hot; colorbar;
title("Absolute error map");

sgtitle("Evaluation of Disparity Map");
