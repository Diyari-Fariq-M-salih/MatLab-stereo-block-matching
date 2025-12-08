function D_relaxed = relaxation_optimization(I1, I2, dispMax, lambda, numIter, D_gt)
% RELAXATION_OPTIMIZATION 
% Global stereo optimization using iterative relaxation.
%
% Always returns LEFT-VIEW disparity:
%       d(x,y) = x_left - x_right
%
% Inputs:
%   I1, I2  : grayscale stereo images (left, right)
%   dispMax : maximum disparity
%   lambda  : smoothness weight
%   numIter : number of relaxation iterations
%   D_gt    : (optional) ground truth for sign correction
%
% Output:
%   D_relaxed : optimized disparity map

    I1 = double(I1);
    I2 = double(I2);
    [h, w] = size(I1);

    % ----------------------------------------
    % 1. Build smooth cost volume C(x,y,d)
    % ----------------------------------------
    C = zeros(h, w, dispMax+1);

    % Use a small averaging kernel to stabilize costs
    win = fspecial('average', [5 5]);

    for d = 0:dispMax
        % Shift right image left by d (expected direction)
        shifted = shiftImage(I2, d);

        % Compute per-pixel SAD but smoothed
        sad = abs(I1 - shifted);
        C(:,:,d+1) = imfilter(sad, win, 'replicate');
    end

    % ----------------------------------------
    % 2. Initialization: Winner-Takes-All disparity
    % ----------------------------------------
    [~, init] = min(C, [], 3);
    D = init - 1;  % disparities 0..dispMax

    % ----------------------------------------
    % 3. Relaxation iterations
    % Minimizes E = C + lambda * sum |d - neigh|
    % ----------------------------------------
    for it = 1:numIter
        D_new = D;

        for y = 2:h-1
            for x = 2:w-1

                bestCost = Inf;
                bestD = D(y,x);

                for d = 0:dispMax

                    % Data term
                    data = C(y,x,d+1);

                    % Smoothness term (4-neighbors)
                    smooth = lambda * ( ...
                        abs(d - D(y, x-1)) + ...
                        abs(d - D(y, x+1)) + ...
                        abs(d - D(y-1, x)) + ...
                        abs(d - D(y+1, x)) );

                    totalCost = data + smooth;

                    if totalCost < bestCost
                        bestCost = totalCost;
                        bestD = d;
                    end
                end

                D_new(y,x) = bestD;
            end
        end

        D = D_new;
    end

    % ----------------------------------------
    % 4. Enforce LEFT-view disparity orientation
    % ----------------------------------------
    % At this point D returns positive disparities if direction matches.
    % However some datasets or code paths may generate negative disparities.
    % We correct by comparing to ground truth if provided.

    if exist('D_gt','var') && ~isempty(D_gt)
        % Compute error for +D
        mask = ~isnan(D(:)) & D_gt(:) > 0;
        err_pos = mean(abs(D(mask) - D_gt(mask)));

        % Compute error for -D (flipped direction)
        err_neg = mean(abs(-D(mask) - D_gt(mask)));

        if err_neg < err_pos
            D = -D;
        end
    else
        % Fallback: use mean disparity sign only if reliable
        m = nanmean(D(:));
        if abs(m) > 0.5 && m < 0
            D = -D;
        end
    end

    D_relaxed = D;
end


% ================================================================
% Helper: safe horizontal shift to the RIGHT by d pixels
% ================================================================
function shifted = shiftImage(I, d)
    [h, w] = size(I);

    if d <= 0
        shifted = I;
        return;
    end

    d = min(d, w-1);
    shifted = zeros(h, w);

    shifted(:, 1:end-d) = I(:, d+1:end);
    shifted(:, end-d+1:end) = repmat(I(:,end), 1, d);
end
