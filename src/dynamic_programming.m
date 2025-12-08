function D_dp = dynamic_programming(I1, I2, dispMax, lambda)
% DYNAMIC_PROGRAMMING Stereo disparity using DP along horizontal scanlines.

    I1 = double(I1);
    I2 = double(I2);

    [h, w] = size(I1);
    D_dp = zeros(h, w);

    for y = 1:h

        % Compute cost volume for this row
        C = zeros(w, dispMax+1);
        for d = 0:dispMax
            shifted = shiftRow(I2(y,:), d);
            C(:, d+1) = abs(I1(y,:) - shifted);
        end

        % DP table
        DP = zeros(w, dispMax+1);
        Prev = zeros(w, dispMax+1);

        DP(1,:) = C(1,:);   % first column

        for x = 2:w
            for d = 0:dispMax
                penalties = DP(x-1, :) + lambda * abs((0:dispMax) - d);
                [bestVal, bestD] = min(penalties);
                DP(x, d+1) = C(x, d+1) + bestVal;
                Prev(x, d+1) = bestD - 1;  % store previous disparity
            end
        end

        % Backtracking
        [~, bestD] = min(DP(w,:));
        dispRow = zeros(1,w);
        dispRow(w) = bestD - 1;
        % Ensure LEFT-view sign convention
        if nanmean(D_dp(:)) < 0
            D_dp = -D_dp;
        end


        for x = w:-1:2
            dispRow(x-1) = Prev(x, dispRow(x)+1);
        end

        D_dp(y,:) = dispRow;
    end
end

function shifted = shiftRow(row, d)
% Safe horizontal shift of a single row to the RIGHT

    w = numel(row);

    if d <= 0
        shifted = row;
        return;
    end

    d = min(d, w-1);

    shifted = zeros(size(row));
    shifted(d+1:end) = row(1:end-d);
    shifted(1:d) = repmat(row(1), 1, d);
end
