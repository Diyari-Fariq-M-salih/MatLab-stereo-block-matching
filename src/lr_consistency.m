function D_out = lr_consistency(DL, DR, tol)
% LR-CONSISTENCY that supports sign ambiguities.

    [h, w] = size(DL);

    % Ensure both disparities have same sign orientation
    if nanmean(DL(:)) * nanmean(DR(:)) < 0
        DR = -DR;
    end

    D_out = DL;

    for y = 1:h
        for x = 1:w
            d = DL(y,x);
            if isnan(d), D_out(y,x)=NaN; continue; end

            xr = round(x - d);

            if xr < 1 || xr > w
                D_out(y,x) = NaN;
                continue;
            end

            dR = DR(y,xr);

            if isnan(dR) || abs(d-dR) > tol
                D_out(y,x) = NaN;
            end
        end
    end
end
