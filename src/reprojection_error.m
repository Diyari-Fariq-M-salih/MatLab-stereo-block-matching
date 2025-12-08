function err = reprojection_error(I1, I2, D)
% REPROJECTION_ERROR Compute average photometric reprojection error.
%
% Inputs:
%   I1 : left image
%   I2 : right image
%   D  : estimated disparity map
%
% Output:
%   err : average reprojection error over valid pixels

    I1 = double(I1);
    I2 = double(I2);

    [h, w] = size(I1);
    E = [];   % store valid errors

    for y = 1:h
        for x = 1:w
            d = D(y,x);

            if isnan(d)
                continue
            end

            xr = round(x - d);

            if xr < 1 || xr > w
                continue
            end

            photErr = abs(I1(y,x) - I2(y,xr));
            E = [E; photErr];
        end
    end

    err = mean(E);
end