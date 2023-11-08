% The Function of Expansion
% Date: 2023.11.04
% Author: choongman.lee

function xe = expansion(x,L)
    [H,W,c]=size(x);
    p=1;
    x=padarray(x,[p p],'replicate','post');
    xe=zeros(H*L+p,W*L+p);
    for i=1:(H+p)
        for j=1:(W+p)
            for k=1:c
                xe(L*(i-1)+1,L*(j-1)+1,k)=x(i,j,k);
            end
        end
    end
end