I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

D_gt = double(imread('data/disp2.pgm'))/8;

blockSize=9; dispMax=20; c=0.05; g=10; lambda=5;

% Compute disparities
DL_BM = block_matching(I1, I2, blockSize, dispMax, c, "SAD", g);
DL_BM = fill_holes(DL_BM);

DL_relax = relaxation_optimization(I1, I2, dispMax, lambda, 10);

DL_DP = dynamic_programming(I1, I2, dispMax, lambda);

% LR consistency (direction aware)
DR_BM = block_matching(I2, I1, blockSize, dispMax, c, "SAD", g);
DR_relax = relaxation_optimization(I2, I1, dispMax, lambda, 10);
DR_DP = dynamic_programming(I2, I1, dispMax, lambda);

BM_LR = lr_consistency(DL_BM, DR_BM, 1);
Relax_LR = lr_consistency(DL_relax, DR_relax, 1);
DP_LR = lr_consistency(DL_DP, DR_DP, 1);

% Evaluate
mreBM = mre_evaluation(BM_LR, D_gt);
mreR  = mre_evaluation(Relax_LR, D_gt);
mreDP = mre_evaluation(DP_LR, D_gt);

repBM = reprojection_error(I1, I2, BM_LR);
repR  = reprojection_error(I1, I2, Relax_LR);
repDP = reprojection_error(I1, I2, DP_LR);

% Plot 3x3
figure;
tiledlayout(3,3);

nexttile; imagesc(BM_LR); colormap jet; colorbar;
title(sprintf("BM LR (MRE=%.3f)", mreBM));

nexttile; imagesc(Relax_LR); colormap jet; colorbar;
title(sprintf("Relax LR (MRE=%.3f)", mreR));

nexttile; imagesc(DP_LR); colormap jet; colorbar;
title(sprintf("DP LR (MRE=%.3f)", mreDP));

% Error maps
nexttile; imagesc(abs(BM_LR-D_gt)); colormap hot; colorbar;
title("BM Abs Error");

nexttile; imagesc(abs(Relax_LR-D_gt)); colormap hot; colorbar;
title("Relax Abs Error");

nexttile; imagesc(abs(DP_LR-D_gt)); colormap hot; colorbar;
title("DP Abs Error");

% Reprojection maps
nexttile; imagesc(reprojection_error_map(I1,I2,BM_LR)); colormap hot; colorbar;
title(sprintf("BM Reproj %.2f", repBM));

nexttile; imagesc(reprojection_error_map(I1,I2,Relax_LR)); colormap hot; colorbar;
title(sprintf("Relax Reproj %.2f", repR));

nexttile; imagesc(reprojection_error_map(I1,I2,DP_LR)); colormap hot; colorbar;
title(sprintf("DP Reproj %.2f", repDP));

sgtitle("Global Evaluation (Direction-Corrected)");
