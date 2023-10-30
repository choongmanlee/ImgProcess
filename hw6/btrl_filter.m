% The Function of Bilateral filter
% Date: 2023.10.04
% Author: choongman.lee

function [b_filter,out] = btrl_filter(xn,sigma_d,sigma_s)
    if(~exist('sigma_d','var'))
        sigma_d=3;
    end
    if(~exist('sigma_s','var'))
        sigma_s=40;
    end

    xn=xn*255;
    [A,B]=size(xn);
    L=7;
    M=(L+1)/2;    
    [g_filter,~] = gaussian_filter(xn,sigma_d);

    noisy_img_p=padarray(xn,[M-1 M-1],'both');
    noisy_img_p=double(noisy_img_p);    
    for i=1+(M-1):A+(M-1)
        for j=1+(M-1):B+(M-1)
            I_pq=noisy_img_p(i-(M-1):i+(M-1),j-(M-1):j+(M-1))-noisy_img_p(i,j);
            b_filter_t=exp(-((I_pq).^2)/(2*sigma_s^2));
            b_filter=b_filter_t.*g_filter;
            b_filter=b_filter/sum(b_filter(:));
            temp=noisy_img_p(i-(M-1):i+(M-1),j-(M-1):j+(M-1)).*b_filter;
            b_filter_img(i-(M-1),j-(M-1))=sum(temp(:));
        end
    end
    out=b_filter_img/255;
end