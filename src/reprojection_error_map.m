function Emap = reprojection_error_map(I1, I2, D)
% Computes per-pixel reprojection error for best disparity direction.

    I1 = double(I1);
    I2 = double(I2);
    [h, w] = size(I1);

    Emap = zeros(h,w);

    for y = 1:h
        for x = 1:w
            d = D(y,x);
            if isnan(d), continue; end

            % Two options:
            xr1 = x - d;
            xr2 = x + d;

            e = Inf;

            if xr1 >= 1 && xr1 <= w
                e = min(e, abs(I1(y,x) - I2(y,xr1)));
            end

            if xr2 >= 1 && xr2 <= w
                e = min(e, abs(I1(y,x) - I2(y,xr2)));
            end

            if isfinite(e)
                Emap(y,x) = e;
            end
        end
    end
end
