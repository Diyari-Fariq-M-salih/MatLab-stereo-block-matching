function mre = mre_evaluation(D_est, D_gt)
% MRE_EVALUATION  Compute Mean Relative Error between estimated and true disparity.
%
% Inputs:
%   D_est : estimated disparity (with NaNs)
%   D_gt  : ground-truth disparity
%
% Output:
%   mre : mean relative error

    % Both must be doubles
    D_est = double(D_est);
    D_gt = double(D_gt);

    % Valid pixels (both non-NaN and GT non-zero)
    mask = ~isnan(D_est) & D_gt > 0;

    % Compute relative error
    relError = abs(D_est(mask) - D_gt(mask)) ./ D_gt(mask);

    % Mean relative error
    mre = mean(relError);
end
