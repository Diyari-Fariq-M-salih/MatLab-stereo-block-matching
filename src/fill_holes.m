function D_filled = fill_holes(D)
% FILL_HOLES Fill NaN holes in disparity map using morphological dilation + smoothing.

    % Replace NaN with 0 temporarily for dilation
    mask = isnan(D);
    Dtemp = D;
    Dtemp(mask) = 0;

    % Structuring element (3x3)
    se = strel('square', 3);

    % Morphological dilation
    D_dilated = imdilate(Dtemp, se);

    % Now restore NaN positions but replace them with dilated values
    D_filled = D;
    D_filled(mask) = D_dilated(mask);

    % Optional: Median filter to remove artifacts
    D_filled = medfilt2(D_filled, [5 5]);
end
