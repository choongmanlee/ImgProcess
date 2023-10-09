% Image Signal Processing
% Title: HW #3 Image Denoising
% Date: 2023.10.04
% Author: choongman.lee

%% Load image
img=imread('Lenna.png'); img=rgb2gray(img);
%img=imread('text_img.jpg');
[A,B]=size(img);
b_filter_img=zeros(A,B);

%% Make noisy image
noise_var=30;
noisy_img=double(img)+noise_var*randn([A,B]);

for a=1:A
    for b=1:B
        noisy_img(a,b)=min(255,noisy_img(a,b));
        noisy_img(a,b)=max(0,noisy_img(a,b));
    end
end

%% Denosing by Gaussian Filter
L=7;
g_filter=zeros(L,L);
M=(L+1)/2;
sigma_d=3;

for m=1:L
    for n=1:L
        g_filter(m,n)=(exp((-(m-M)^2-(n-M)^2)/2/sigma_d^2));
    end
end
s=sum(g_filter(:));
lpf_t=g_filter;
g_filter=g_filter/s;
g_filter_img=conv2(noisy_img,g_filter,'same');
g_filter_img=uint8(g_filter_img);

%% Denoising by Bilateral Filter
noisy_img_p=padarray(noisy_img,[M-1 M-1],'both');
sigma_s=40;

for i=1+(M-1):A+(M-1)
    for j=1+(M-1):B+(M-1)
        I_pq=noisy_img_p(i-(M-1):i+(M-1),j-(M-1):j+(M-1))-noisy_img_p(i,j);
        b_filter_t=exp(-I_pq.^2/2/sigma_s^2);
        b_filter=b_filter_t.*g_filter;
        b_filter=b_filter/sum(b_filter(:));
        temp=noisy_img_p(i-(M-1):i+(M-1),j-(M-1):j+(M-1)).*b_filter;
        b_filter_img(i-(M-1),j-(M-1))=sum(temp(:));
    end
end
b_filter_img=uint8(b_filter_img);

%% Plot
noisy_img=uint8(noisy_img);
subplot(1,4,1), imshow(img), title('Original Image')
subplot(1,4,2), imshow(noisy_img), title('Noisy Image')
subplot(1,4,3), imshow(g_filter_img), title('Gaussian Filtering Image')
subplot(1,4,4), imshow(b_filter_img), title('Bilateral Filtering Image')

%% PSNR
PSNR_n=psnr(noisy_img,img);
PSNR_g=psnr(g_filter_img,img);
PSNR_b=psnr(b_filter_img,img);

%% SSIM
SSIM_n=ssim(noisy_img,img);
SSIM_g=ssim(g_filter_img,img);
SSIM_b=ssim(b_filter_img,img);
