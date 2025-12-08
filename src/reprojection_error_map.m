function Emap = reprojection_error_map(I1, I2, D)
% REPROJECTION_ERROR_MAP
% Computes a pixel-wise reprojection error map for visualization.
%
% For each pixel (x,y):
%   E(x,y) = | I1(x,y) - I2(x - d, y) |
%
% If disparity is invalid or out of bounds → error = 0

    I1 = double(I1);
    I2 = double(I2);
    [h, w] = size(I1);

    Emap = zeros(h, w);

    for y = 1:h
        for x = 1:w
            d = D(y, x);

            if isnan(d)
                Emap(y, x) = 0;
                continue;
            end

            xr = round(x - d);

            if xr < 1 || xr > w
                Emap(y, x) = 0;
                continue;
            end

            Emap(y, x) = abs(I1(y, x) - I2(y, xr));
        end
    end
end
