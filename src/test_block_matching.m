% % inital test -------------------------------------------------
% I1 = rgb2gray(imread('data/im6.ppm'));
% I2 = rgb2gray(imread('data/im2.ppm'));
% 
% blockSize = 9;
% dispMax = 20;
% seuilContrast = 0.05;
% 
% D = block_matching(I1, I2, blockSize, dispMax, seuilContrast,"SAD",15);
% 
% figure;
% imagesc(D); colormap jet; colorbar;
% title("Raw Block Matching Disparity Map");
% % inital test -------------------------------------------------

% % different threshold values ------------------------------------
% I1 = rgb2gray(imread('data/im2.ppm'));
% I2 = rgb2gray(imread('data/im6.ppm'));
% blockSize = 9;
% dispMax = 20;
% thresholds = [0, 0.02, 0.05, 0.1];
% 
% figure;
% for k = 1:length(thresholds)
%     D = block_matching(I1, I2, blockSize, dispMax, thresholds(k),"SAD",15);
% 
%     subplot(2, 2, k);
%     imagesc(D); colormap jet; colorbar;
%     title(sprintf('Contrast Threshold = %.2f', thresholds(k)));
% end
% sgtitle("Effect of Contrast Threshold");
% % different threshold values ------------------------------------

% % differet disparity sizes ------------------------------------------
% I1 = rgb2gray(imread('data/im2.ppm'));
% I2 = rgb2gray(imread('data/im6.ppm'));
% blockSize = 9;
% contrast = 0.05;
% dispRanges = [5, 10, 20, 40];
% 
% figure;
% for k = 1:length(dispRanges)
%     D = block_matching(I1, I2, blockSize, dispRanges(k), contrast,"SAD",15);
% 
%     subplot(2, 2, k);
%     imagesc(D); colormap jet; colorbar;
%     title(sprintf('dispMax = %d', dispRanges(k)));
% end
% sgtitle("Effect of Maximum Disparity Range");
% % differet disparity sizes ------------------------------------------

% differet block sizes ------------------------------------------
I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

dispMax = 20;
seuilContrast = 0.05;

blockSizes = [3, 7, 11, 15];

figure;
for k = 1:length(blockSizes)
    D = block_matching(I1, I2, blockSizes(k), dispMax, seuilContrast,"SAD",15);

    subplot(2, 2, k);
    imagesc(D); colormap jet; colorbar;
    title(sprintf('Block Size = %d', blockSizes(k)));
end
sgtitle("Effect of Block Size on Disparity Map");
% differet block sizes ------------------------------------------
