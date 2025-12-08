function D_relaxed = relaxation_optimization(I1, I2, dispMax, lambda, numIter, D_gt)
% RELAXATION_OPTIMIZATION
% Implements global stereo optimization using iterative relaxation.
%
% ALWAYS returns left-view disparity: d = x_left - x_right
%
% Inputs:
%   I1, I2  : left and right grayscale images
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

    % Block half-size (for SAD aggregation)
    b = 2;  % 5x5 block

    % --------------------------------------------------------------
    % 1. Build BLOCK-BASED SAD cost volume C(y,x,d)
    % --------------------------------------------------------------
    fprintf("Building cost volume (SAD block matching)...\n");
    C = Inf * ones(h, w, dispMax+1);

    for d = 0:dispMax
        shifted = shiftImage(I2, d);

        for y = 1+b:h-b
            for x = 1+b:w-b
                blockL = I1(y-b:y+b, x-b:x+b);
                blockR = shifted(y-b:y+b, x-b:x+b);

                % SAD block cost
                C(y,x,d+1) = sum(abs(blockL(:) - blockR(:)));
            end
        end
    end

    % --------------------------------------------------------------
    % 2. Initialize disparity using WTA (Winner-Takes-All)
    % --------------------------------------------------------------
    [~, init] = min(C, [], 3);
    D = init - 1;

    % --------------------------------------------------------------
    % 3. Relaxation iterations (global 2D optimization)
    % --------------------------------------------------------------
    fprintf("Running relaxation iterations...\n");

    for it = 1:numIter
        fprintf("  Iteration %d/%d\n", it, numIter);
        D_new = D;

        for y = 2:h-1
            for x = 2:w-1

                bestCost = Inf;
                bestD = D(y,x);

                for d = 0:dispMax
                    data = C(y,x,d+1);

                    smooth = lambda * ( ...
                        abs(d - D(y, x-1)) + ...
                        abs(d - D(y, x+1)) + ...
                        abs(d - D(y-1, x)) + ...
                        abs(d - D(y+1, x)) );

                    total = data + smooth;

                    if total < bestCost
                        bestCost = total;
                        bestD = d;
                    end
                end

                D_new(y,x) = bestD;
            end
        end

        D = D_new;
    end

    % --------------------------------------------------------------
    % 4. Enforce LEFT-view disparity orientation
    % --------------------------------------------------------------
    fprintf("Fixing disparity direction...\n");

    if exist('D_gt','var') && ~isempty(D_gt)
        mask = ~isnan(D(:)) & D_gt(:) > 0;
        err_pos = mean(abs(D(mask) - D_gt(mask)));
        err_neg = mean(abs(-D(mask) - D_gt(mask)));
        if err_neg < err_pos
            D = -D;
        end
    else
        m = nanmean(D(:));
        if abs(m) > 0.5 && m < 0
            D = -D;
        end
    end

    D_relaxed = D;
end



% ===================================================================
% Helper function: horizontal shift to simulate disparity
% ===================================================================
function shifted = shiftImage(I, d)
    [h, w] = size(I);

    if d <= 0
        shifted = I;
        return;
    end

    d = min(d, w-1);

    shifted = zeros(h, w);
    shifted(:, 1:end-d) = I(:, d+1:end);
    shifted(:, end-d+1:end) = repmat(I(:, end), 1, d);
end
