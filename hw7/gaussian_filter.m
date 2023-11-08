% The Function of Gaussian filter
% Date: 2023.10.04
% Modifed: 2023.11.04
% Author: choongman.lee

function [g_filter,out] = gaussian_filter(xn,L,sigma_d)
    if(~exist('sigma_d','var'))
        sigma_d=3;
    end
    if(~exist('L','var'))
        L=7;
    end

    [H,W]=size(xn);
    g_filter=zeros(L,L);
    M=(L+1)/2;    
    for m=1:L
        for n=1:L
            g_filter(m,n)=(exp((-(m-M)^2-(n-M)^2)/2/sigma_d^2));
        end
    end
    s=sum(g_filter(:));
    g_filter=g_filter/s;

    xp=padarray(xn,[M-1 M-1],'both','replicate');
    x_t=conv2(xp,g_filter);

    out=zeros(H,W);
    for i=L:H+(L-1)
        for j=L:W+(L-1)
            out(i-(L-1),j-(L-1))=x_t(i,j);
        end
    end
end