% The Function of interpolation by nyquist
% Date: 2023.11.04
% Author: choongman.lee

function y = interpolation_nyquist(x,N,L,bw)
    xe=expansion(x,L);
    [H,W,c]=size(xe);
    p=1;
    Hd=nyquist(N,L,bw);
    b=get(Hd,'Numerator');
    h=conv2(L*b,L*b');
    for k=1:3
        y1(:,:,k)=conv2(xe(:,:,k),h,'same');
    end
    for i=1:(H-p)
        for j=1:(W-p)
            for k=1:c
                y(i,j,k)=y1(i,j,k);
            end
        end
    end
end