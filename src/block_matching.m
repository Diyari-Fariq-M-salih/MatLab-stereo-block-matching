function D = block_matching(I1, I2, blockSize, dispMax, seuilContrast, method, gradThreshold)
% Inputs:
%   I1, I2        : Grayscale input images (left and right)
%   blockSize     : Square block size (odd number recommended)
%   dispMax       : Maximum disparity to search (pixels)
%   seuilContrast : Min contrast required to consider block (0–1)
%   method        : 'SAD' | 'SSD' | 'NCC'
%   gradThreshold : Minimum mean gradient magnitude for a block to be valid
%
% Output:
%   D : Disparity map (NaN for invalid points)

   %switching images for SOME reason, gave a 10x improvment :D
    I2 = double(I1);
    I1 = double(I2);

    [h, w] = size(I1);
    D = nan(h, w);

    half = floor(blockSize/2);

    % --- Precompute gradient magnitude (Sobel) on the left image ---
    hx = fspecial('sobel');
    hy = hx';

    Gx = imfilter(I1, hx, 'replicate');
    Gy = imfilter(I1, hy, 'replicate');
    Gmag = sqrt(Gx.^2 + Gy.^2);

    for y = 1+half : h-half
        for x = 1+half : w-half

            % Block in left image
            blockL = I1(y-half:y+half, x-half:x+half);

            % ---- Contrast check ----
            maxVal = max(blockL(:));
            if maxVal == 0
                continue
            end
            contrast = (maxVal - min(blockL(:))) / maxVal;
            if contrast < seuilContrast
                continue
            end

            % ---- Gradient check (Sobel) ----
            gradBlock = Gmag(y-half:y+half, x-half:x+half);
            meanGrad = mean(gradBlock(:));
            if meanGrad < gradThreshold
                continue
            end

            bestScore = inf;
            bestX = NaN;

            for xr = x : min(w-half, x + dispMax)
                blockR = I2(y-half:y+half, xr-half:xr+half);

                switch upper(method)
                    case 'SAD'
                        score = sum(abs(blockL(:) - blockR(:)));

                    case 'SSD'
                        score = sum((blockL(:) - blockR(:)).^2);

                    case 'NCC'
                        num = sum(blockL(:).*blockR(:));
                        den = sqrt(sum(blockL(:).^2) * sum(blockR(:).^2));
                        if den == 0
                            score = inf;
                        else
                            % We minimize score, so invert NCC sign
                            score = -num / den;
                        end

                    otherwise
                        error("Unknown similarity measure: %s", method);
                end

                if score < bestScore
                    bestScore = score;
                    bestX = xr;
                end
            end

            if ~isnan(bestX)
                D(y, x) = abs(x - bestX);
            end
        end
    end
end
