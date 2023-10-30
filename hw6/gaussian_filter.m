% The Function of Gaussian filter
% Date: 2023.10.04
% Author: choongman.lee

function [g_filter,out] = gaussian_filter(xn,sigma_d)
    if(~exist('sigma_d','var'))
        sigma_d=3;
    end

    L=7;
    g_filter=zeros(L,L);
    M=(L+1)/2;    
    for m=1:L
        for n=1:L
            g_filter(m,n)=(exp((-(m-M)^2-(n-M)^2)/2/sigma_d^2));
        end
    end
    s=sum(g_filter(:));
    g_filter=g_filter/s;

    g_filter_img=conv2(xn,g_filter,'same');
    out=g_filter_img;
end