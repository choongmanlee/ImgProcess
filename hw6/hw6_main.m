% Image Signal Processing
% Title: HW #6 WLS Filtering
% Date: 2023.10.24
% Author: choongman.lee

clear all;
close all;

%% Denoising by Wiener filter
img=imread('tiger.jpg'); img=rgb2ycbcr(img);
%img=imread('chart3.bmp');
img=(img(:,:,1));
img=double(img);
img=img/255;
[H,W]=size(img);

% Make a noisy image
noise_var=30/255;
img_n=double(img)+noise_var*randn([H,W]);
for h=1:H
    for w=1:W
        img_n(h,w)=min(1,img_n(h,w));
        img_n(h,w)=max(0,img_n(h,w));
    end
end

% WLS filter
[~,y]=wls_filter(img_n,1,0.1);

% Compare
figure(1), subplot(1,3,1), imshow(img), title('original')
subplot(1,3,2), imshow(img_n), title('noisy')
subplot(1,3,3), imshow(y), title('WLS filter')

% PSNR
PSNR_n=psnr(img_n,img);
PSNR_w=psnr(y,img);

%% Image decomposition & Enhancement by WLS filter
img1=imread('grandcanal.PNG');
%img1=imread('262A2497.PNG');
img_org=double(img1);
img1=rgb2ycbcr(img1);
img1=(img1(:,:,1));
img1=double(img1);
img1=img1/255;

% WLS filter
[oimg,Iw]=wls_filter(img1,2,1.2);
[Rw,out_w]=retinex_R(img_org,img1,Iw);

figure(2), subplot(1,3,1), imshow(oimg), title('Luminance(Y)')
subplot(1,3,2), imshow(Iw), title('Illumination(I)')
subplot(1,3,3), imshow(Rw), title('Reflectance(R)')

figure(3), subplot(1,2,1), imshow(uint8(img_org)), title('Original')
subplot(1,2,2), imshow(uint8(out_w)), title('Retinex')

% Gaussian filter
[g_filter,Ig] = gaussian_filter(img1);
[Rg,out_g]=retinex_R(img_org,img1,Ig);

% Bilateral filter
[b_filter,Ib]=btrl_filter(img1);
[Rb,out_b]=retinex_R(img_org,img1,Ib);

% Compare
figure(4), subplot(1,3,1), imshow(uint8(out_w)), title('wls')
subplot(1,3,2), imshow(uint8(out_g)), title('gaussian')
subplot(1,3,3), imshow(uint8(out_b)), title('bilateral')