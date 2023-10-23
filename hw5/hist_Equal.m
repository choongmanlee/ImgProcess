% Histogram Equalization
% Date: 2023.10.21
% Author: choongman.lee

function he = hist_Equal(c,x)
    [H,W]=size(x);
    for i=1:H
        for j=1:W
            he(i,j)=255*c(x(i,j)+1);
        end
    end
end