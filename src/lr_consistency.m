function D_LR = lr_consistency(DL, DR, threshold)
% LR_CONSISTENCY  Apply left-right consistency check.
%
% DL : disparity left → right
% DR : disparity right → left
% threshold : tolerance for mismatch (typically 1 pixel)
%
% Output:
%   D_LR : disparity after LR consistency (invalid points = NaN)

    [h, w] = size(DL);
    D_LR = DL;  % start from left disparity

    for y = 1:h
        for x = 1:w
            d = DL(y, x);

            % skip invalid disparities
            if isnan(d)
                continue
            end

            xr = round(x - d);

            % Is x-d inside the image?
            if xr < 1 || xr > w
                D_LR(y, x) = NaN;
                continue
            end

            dR = DR(y, xr);

            if isnan(dR)
                D_LR(y, x) = NaN;
                continue
            end

            % Check if consistent
            if abs(d - dR) > threshold
                D_LR(y, x) = NaN;
            end
        end
    end
end
