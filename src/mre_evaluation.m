function mre = mre_evaluation(D_est, D_gt)
% MRE_EVALUATION  Compute Mean Relative Error between estimated and true disparity.
% Automatically checks both disparity directions.

    D_est = double(D_est);
    D_gt  = double(D_gt);

    % Valid masks
    mask = ~isnan(D_est) & D_gt > 0;

    % Check normalized error as-is
    rel1 = abs(D_est(mask) - D_gt(mask)) ./ D_gt(mask);
    mre1 = mean(rel1);

    % Check reversed disparity (if algorithm returned opposite direction)
    rel2 = abs(-D_est(mask) - D_gt(mask)) ./ D_gt(mask);
    mre2 = mean(rel2);

    % Choose best interpretation
    mre = min(mre1, mre2);
end
