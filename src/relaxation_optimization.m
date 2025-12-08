function D_relaxed = relaxation_optimization(I1, I2, dispMax, lambda, numIter)
% RELAXATION_OPTIMIZATION  Global disparity optimization via relaxation.
%
% Inputs:
%   I1, I2  : grayscale images
%   dispMax : maximum disparity
%   lambda  : smoothness weight
%   numIter : number of relaxation iterations
%
% Output:
%   D_relaxed : optimized disparity map

    I1 = double(I1);
    I2 = double(I2);

    [h, w] = size(I1);

    % --- Compute cost volume C(x,y,d) ---
    C = zeros(h, w, dispMax+1);

    for d = 0:dispMax
        shifted = shiftImage(I2, d);  % helper function below
        C(:,:,d+1) = abs(I1 - shifted);   % SAD cost
    end

    % Initialize disparity with local minimum (winner-takes-all)
    [~, D0] = min(C, [], 3);
    D0 = D0 - 1;

    D = D0;

    % --- Relaxation iterations ---
    for iter = 1:numIter
        D_new = zeros(h,w);

        for y = 2:h-1
            for x = 2:w-1

                costList = zeros(1, dispMax+1);

                for d = 0:dispMax
                    % Data cost
                    cd = C(y, x, d+1);

                    % Smoothness cost (neighbors)
                    smooth = lambda * ( ...
                        abs(d - D(y, x-1)) + ...
                        abs(d - D(y, x+1)) + ...
                        abs(d - D(y-1, x)) + ...
                        abs(d - D(y+1, x)) );

                    costList(d+1) = cd + smooth;
                end

                [~, bestD] = min(costList);
                D_new(y,x) = bestD - 1;
            end
        end

        D = D_new;
    end

    D_relaxed = D;
end

function shifted = shiftImage(I, d)
% Safe horizontal shift to the RIGHT by d pixels
% When d=0 → return original image

    [h, w] = size(I);

    if d <= 0
        shifted = I;
        return;
    end

    % Clamp d just in case (avoid d >= w issues)
    d = min(d, w-1);

    shifted = zeros(h, w);

    % Shift right: pixels move from left to right
    shifted(:, d+1:end) = I(:, 1:end-d);

    % Fill the leftmost d columns by replicating the first column
    shifted(:, 1:d) = repmat(I(:,1), 1, d);
end
