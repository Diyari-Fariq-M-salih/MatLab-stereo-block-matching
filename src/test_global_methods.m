I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

DL = block_matching(I1, I2, 9, 20, 0.05, 'SAD', 10);
D_relax = relaxation_optimization(I2, I1, 20, 4, 5);
D_dp = dynamic_programming(I1, I2, 20, 4);

figure;
subplot(1,3,1); imagesc(DL); colormap jet; title("Block Matching");
subplot(1,3,2); imagesc(D_relax); colormap jet; title("Relaxation");
subplot(1,3,3); imagesc(D_dp); colormap jet; title("Dynamic Programming");
sgtitle("Comparison of Stereo Methods");
