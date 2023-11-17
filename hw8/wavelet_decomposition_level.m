% The Function of wavelet decomposition by level
% Date: 2023.11.08
% Author: choongman.lee

function [] = wavelet_decomposition_level(x,Level)
    for i=1:Level
        [c,s]=wavedec2(x,1,'bior2.2');
        
        N=s(1,1)*s(1,2);
        LL=c(1:N);
        LL_image=reshape(LL,s(1,1),s(1,2));
        LL_image=LL_image/max(LL);
        x=LL_image;
        
        LH=c(N+1:N*2);
        LH_image=reshape(LH,s(2,1),s(2,2));
        LH_image=LH_image/max(LH);
        
        HL=c(2*N+1:N*3);
        HL_image=reshape(HL,s(2,1),s(2,2));
        HL_image=HL_image/max(HL);
        
        HH=c(3*N+1:N*4);
        HH_image=reshape(HH,s(2,1),s(2,2));
        HH_image=HH_image/max(HH);
        
        figure, subplot(2,2,1), imshow(LL_image), title('LL')
        subplot(2,2,2), imshow(LH_image), title('LH')
        subplot(2,2,3), imshow(HL_image), title('HL')
        subplot(2,2,4), imshow(HH_image), title('HH')
    end
end