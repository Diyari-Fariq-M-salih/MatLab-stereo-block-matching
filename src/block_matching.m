function D = block_matching(I1, I2, blockSize, dispMax, seuilContrast, method, gradThreshold)
% BLOCK_MATCHING - Always returns left-view disparity: x_left - x_match.
    I1 = double(I1);
    I2 = double(I2);
    [h, w] = size(I1);

    half = floor(blockSize/2);
    D_raw = nan(h,w);   % temporary disparity, orientation unknown

    % Precompute gradient for filtering
    hx = fspecial('sobel'); hy = hx';
    G1 = sqrt( imfilter(I1,hx,'replicate').^2 + imfilter(I1,hy,'replicate').^2 );

    for y = 1+half : h-half
        for x = 1+half : w-half

            bL = I1(y-half:y+half, x-half:x+half);

            % Contrast check
            c = (max(bL(:))-min(bL(:))) / max(bL(:));
            if c < seuilContrast, continue; end
            
            % Gradient check
            if mean(G1(y-half:y+half, x-half:x+half),'all') < gradThreshold
                continue
            end

            bestScore = inf;
            bestX = NaN;

            % Search range
            for xr = max(1+half, x-dispMax) : (x)
                bR = I2(y-half:y+half, xr-half:xr+half);

                switch upper(method)
                    case 'SAD'
                        score = sum(abs(bL(:)-bR(:)));
                    case 'SSD'
                        score = sum((bL(:)-bR(:)).^2);
                    case 'NCC'
                        num = sum(bL(:).*bR(:));
                        den = sqrt(sum(bL(:).^2)*sum(bR(:).^2));
                        score = -(num/(den+eps));
                end

                if score < bestScore
                    bestScore = score;
                    bestX = xr;
                end
            end

            if ~isnan(bestX)
                D_raw(y,x) = bestX - x; % may be positive or negative
            end
        end
    end

    % --- Enforce left-view convention ---
    % Choose orientation that matches dominant disparity direction
    if nanmean(D_raw(:)) > 0
        D = D_raw;        % positive = right-shift → correct
    else
        D = -D_raw;       % negative means reversed → flip sign
    end
end
