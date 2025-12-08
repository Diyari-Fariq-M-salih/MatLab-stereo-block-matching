function D = block_matching(I1, I2, blockSize, dispMax, seuilContrast, method)
% BLOCK_MATCHING Compute disparity map using block matching.
%
% method : 'SAD' | 'SSD' | 'NCC'

    I1 = double(I1);
    I2 = double(I2);

    [h, w] = size(I1);
    D = nan(h, w);

    half = floor(blockSize/2);

    for y = 1+half : h-half
        for x = 1+half : w-half

            blockL = I1(y-half:y+half, x-half:x+half);

            % Contrast filtering
            contrast = (max(blockL(:)) - min(blockL(:))) / max(blockL(:));
            if contrast < seuilContrast || isnan(contrast)
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
                            % We invert NCC because block matching minimizes the score
                            score = -num/den;
                        end

                    otherwise
                        error("Unknown similarity measure");
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
