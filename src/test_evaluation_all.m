% Load images
I1 = rgb2gray(imread('data/im2.ppm'));
I2 = rgb2gray(imread('data/im6.ppm'));

% Ground truth disparity
D_gt = double(imread('data/disp2.pgm')) / 8;

% Parameters
blockSize = 9;
dispMax = 20;
contrast = 0.05;
gradThr = 10;
lambda = 0.3;

% Compute disparities
fprintf("Computing Block Matching...\n");
D_BM = block_matching(I1, I2, blockSize, dispMax, contrast, "SAD", gradThr);
D_BM = fill_holes(D_BM);

fprintf("Computing Relaxation...\n");
D_relax = relaxation_optimization(I1, I2, dispMax, lambda, 5);

fprintf("Computing Dynamic Programming...\n");
D_DP = dynamic_programming(I1, I2, dispMax, lambda);


% Compute errors
fprintf("\nEvaluating MRE...\n");
MRE_BM = mre_evaluation(D_BM, D_gt);
MRE_relax = mre_evaluation(D_relax, D_gt);
MRE_DP = mre_evaluation(D_DP, D_gt);

fprintf("BM MRE      = %.4f\n", MRE_BM);
fprintf("Relax MRE   = %.4f\n", MRE_relax);
fprintf("DP MRE      = %.4f\n", MRE_DP);

fprintf("\nEvaluating reprojection error...\n");
REP_BM = reprojection_error(I1, I2, D_BM);
REP_relax = reprojection_error(I1, I2, D_relax);
REP_DP = reprojection_error(I1, I2, D_DP);

fprintf("BM REPROJ   = %.4f\n", REP_BM);
fprintf("Relax REPROJ= %.4f\n", REP_relax);
fprintf("DP REPROJ   = %.4f\n", REP_DP);


% Compute absolute error maps
AE_BM = abs(D_BM - D_gt); AE_BM(isnan(AE_BM)) = 0;
AE_relax = abs(D_relax - D_gt); AE_relax(isnan(AE_relax)) = 0;
AE_DP = abs(D_DP - D_gt); AE_DP(isnan(AE_DP)) = 0;

% Create a 3×3 figure
figure;
tiledlayout(3,3);

%  Row 1: Disparity Maps 
nexttile; imagesc(D_BM); colormap jet; colorbar;
title(sprintf("BM Disparity (MRE=%.3f)", MRE_BM));

nexttile; imagesc(D_relax); colormap jet; colorbar;
title(sprintf("Relax Disparity (MRE=%.3f)", MRE_relax));

nexttile; imagesc(D_DP); colormap jet; colorbar;
title(sprintf("DP Disparity (MRE=%.3f)", MRE_DP));

%  Row 2: Absolute Error 
nexttile; imagesc(AE_BM); colormap hot; colorbar;
title("BM Abs Error");

nexttile; imagesc(AE_relax); colormap hot; colorbar;
title("Relax Abs Error");

nexttile; imagesc(AE_DP); colormap hot; colorbar;
title("DP Abs Error");

%  Row 3: Reprojection Error 

nexttile;
RP_map_BM = reprojection_error_map(I1, I2, D_BM);
imagesc(RP_map_BM); colormap hot; colorbar;
title(sprintf("BM Reproj Err (%.3f)", REP_BM));

nexttile;
RP_map_relax = reprojection_error_map(I1, I2, D_relax);
imagesc(RP_map_relax); colormap hot; colorbar;
title(sprintf("Relax Reproj Err (%.3f)", REP_relax));

nexttile;
RP_map_DP = reprojection_error_map(I1, I2, D_DP);
imagesc(RP_map_DP); colormap hot; colorbar;
title(sprintf("DP Reproj Err (%.3f)", REP_DP));

sgtitle("Full Evaluation of Stereo Methods");
