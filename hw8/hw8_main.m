% Image Signal Processing
% Title: HW #8 Wavelet-Domain Image Denoising
% Date: 2023.11.08
% Author: choongman.lee

close all;
clear all;

%% Load image
x=imread("Lenna.png");
x=rgb2ycbcr(x);
x=x(:,:,1);
[A,B]=size(x);
wavelet_decomposition_level(x,3);

%% Make noisy image
noise_var=20;
noisy_img=double(x)+noise_var*randn([A,B]);

for a=1:A
    for b=1:B
        noisy_img(a,b)=min(255,noisy_img(a,b));
        noisy_img(a,b)=max(0,noisy_img(a,b));
    end
end
noisy_img=uint8(noisy_img);

%% Wavelet-Domain Image denoising
HARD_Th=true;   % true: hard thresholding, false: soft thresholding
th=50;
L=3;
wavelet_decomposition_level(noisy_img,L);
[c,s]=wavedec2(noisy_img,L,'bior2.2');
N=s(1,1)*s(1,2);
M=length(c);

for n=N+1:M
    if(abs(c(n))>th)
        if(HARD_Th)
            if(c(n)>0)
                c(n)=c(n)-th;
            else
                c(n)=c(n)+th;
            end
        end
    else
        c(n)=0;
    end
end

y=waverec2(c,s,'bior2.2');
y=uint8(y);

%% Compare
figure, subplot(1,3,1), imshow(x), title('original')
subplot(1,3,2), imshow(noisy_img), title('noisy')
subplot(1,3,3), imshow(y), title('denoising')
psnr_n=psnr(noisy_img,x);
psnr_dn=psnr(y,x);