% The Function of Bilateral filter
% Date: 2023.10.04
% Author: choongman.lee

function out = btrl_filter(xn,sigma_d,sigma_s)
    %% Gaussian Filter
    [A,B]=size(xn);
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
    
    %% Bilateral Filter
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
    out=uint8(b_filter_img);
end