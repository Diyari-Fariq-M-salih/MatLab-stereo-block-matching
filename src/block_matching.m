function D = block_matching(I1, I2, blockSize, dispMax, seuilContrast)
% BLOCK_MATCHING Compute disparity map using basic block matching (SAD).
%
% Inputs:
%   I1, I2        : Grayscale input images (left and right)
%   blockSize     : Size of the square block (odd number recommended)
%   dispMax       : Maximum disparity to search (pixels)
%   seuilContrast : Min contrast required to consider block (0–1)
%
% Output:
%   D : Disparity map (NaN for invalid points), this later helps us with
%   depth perception :D

    I1 = double(I1);
    I2 = double(I2);

    [h, w] = size(I1);
    D = nan(h, w);

    half = floor(blockSize/2);

    for y = 1+half : h-half
        for x = 1+half : w-half

            % Extract block from left image
            blockL = I1(y-half:y+half, x-half:x+half);

            % Contrast filter (avoid flat regions)
            contrast = (max(blockL(:)) - min(blockL(:))) / max(blockL(:));
            if contrast < seuilContrast || isnan(contrast)
                continue
            end

            bestScore = inf;
            bestX2 = NaN;

            % Horizontal search in right image
            for xr = x : min(w-half, x + dispMax)
                blockR = I2(y-half:y+half, xr-half:xr+half);

                % SAD similarity
                score = sum(abs(blockL(:) - blockR(:)));

                if score < bestScore
                    bestScore = score;
                    bestX2 = xr;
                end
            end

            % Store disparity
            if ~isnan(bestX2)
                D(y, x) = abs(x - bestX2);
            end

        end
    end
end
