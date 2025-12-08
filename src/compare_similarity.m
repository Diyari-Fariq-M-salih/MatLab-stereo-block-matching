I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

blockSize = 9;
dispMax = 20;
seuilContrast = 0.05;

methods = {"SAD", "SSD", "NCC"};

figure;
for k = 1:3
    D = block_matching(I1, I2, blockSize, dispMax, seuilContrast, methods{k});
    
    subplot(1, 3, k);
    imagesc(D); colormap jet; colorbar;
    title(methods{k});
end
sgtitle("Comparison of Similarity Measures");
