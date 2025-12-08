function err = reprojection_error(I1, I2, D)
% REPROJECTION_ERROR  Checks both (x-d) and (x+d) reprojection.

    I1 = double(I1);
    I2 = double(I2);
    [h, w] = size(I1);

    E1 = [];  % |I1 - I2(x-d)|
    E2 = [];  % |I1 - I2(x+d)|

    for y = 1:h
        for x = 1:w
            d = D(y,x);
            if isnan(d), continue; end

            % Case 1: shift right image left by d
            xr1 = x - d;
            if xr1 >= 1 && xr1 <= w
                E1(end+1) = abs(I1(y,x) - I2(y,xr1));
            end

            % Case 2: shift right image right by d
            xr2 = x + d;
            if xr2 >= 1 && xr2 <= w
                E2(end+1) = abs(I1(y,x) - I2(y,xr2));
            end
        end
    end

    % Choose direction with lowest reprojection error
    err = min(mean(E1), mean(E2));
end
