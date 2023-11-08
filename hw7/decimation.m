% The Function of Decimation
% Date: 2023.11.04
% Author: choongman.lee

function xd = decimation(img,M)
    [H,W,c]=size(img);
    for i=1:(H/M)
        for j=1:(W/M)
            for k=1:c
                xd(i,j,k)=img(M*(i-1)+1,M*(j-1)+1,k);
            end
        end
    end
end