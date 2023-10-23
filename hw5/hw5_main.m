% Image Signal Processing
% Title: HW #5 Nonlinear Processing for Enhancement
% Date: 2023.10.21
% Author: choongman.lee

clear all;
close all;

%% Histogram Equalization
img=imread('low.png');
x=rgb2ycbcr(img);
%x=rgb2gray(img);
x=(x(:,:,1));

if(0)
x=double(x);
xmax=max(max(x));
xmin=min(min(x));
x=uint8(floor(((x-xmin)/(xmax-xmin))*255)); % [xmin,xmax]->[0,255]
end

c=cdf_gen(x);
out_Y=hist_Equal(c,x);
cdf_gen(uint8(out_Y));

figure, subplot(1,2,1), imshow(x), title('Y component from YCbCr')
subplot(1,2,2), imshow(uint8(out_Y)), title('Histogram Equalization using Y component of YCbCr')

xR=img(:,:,1);
xG=img(:,:,2);
xB=img(:,:,3);
y(:,:,1)=hist_Equal(c,xR);
y(:,:,2)=hist_Equal(c,xG);
y(:,:,3)=hist_Equal(c,xB);
figure, subplot(1,2,1), imshow(img), title('Original Color Image')
subplot(1,2,2), imshow(uint8(y)), title('Color Image by Histogram Equalization')

c_R=cdf_gen(xR);
c_G=cdf_gen(xG);
c_B=cdf_gen(xB);
y_indep(:,:,1)=hist_Equal(c_R,xR);
y_indep(:,:,2)=hist_Equal(c_G,xG);
y_indep(:,:,3)=hist_Equal(c_B,xB);
figure, subplot(1,3,1), imshow(img), title('Original Color Image')
subplot(1,3,2), imshow(uint8(y)), title('Color Image by Histogram Equalization(Y component)')
subplot(1,3,3), imshow(uint8(y_indep)), title('Color Image by Histogram Equalization(RGB independent)')

% CLAHE(Contrast Limitd Adaptive Histogram Equalization)
lab=rgb2lab(img);
L=lab(:,:,1)/100;
L=adapthisteq(L,'NumTiles',[8 8],'ClipLimit',0.03);
lab(:,:,1)=L*100;
J=lab2rgb(lab);
figure, subplot(1,2,1), imshow(img), title('Original Color Image')
subplot(1,2,2), imshow(J), title('Contrast Limited Adaptive Histogram Equalization')

%% Median Filter
img1=imread('Lenna.png');
x1=rgb2gray(img1);
[H1,W1]=size(x1);

sigma_d=3;
sigma_s=40;

% salt & pepper noise
xn_sp=imnoise(x1,'salt & pepper',0.05);

yb_sp=btrl_filter(xn_sp,sigma_d,sigma_s);   % Bilateral
ym_sp=medfilt2(xn_sp,[5 5]);                % Median

figure, subplot(1,3,1), imshow(xn_sp), title('Noisy Image(salt & pepper)')
subplot(1,3,2), imshow(yb_sp), title('Bilateral Filter')
subplot(1,3,3), imshow(ym_sp), title('Median Filter')

psnr_n_sp=psnr(x1,xn_sp,255);
psnr_b_sp=psnr(x1,yb_sp,255);
psnr_m_sp=psnr(x1,ym_sp,255);

% gaussian noise
xn_ga=imnoise(x1,'gaussian',0.05);

yb_ga=btrl_filter(xn_ga,sigma_d,sigma_s);   % Bilateral
ym_ga=medfilt2(xn_ga,[5 5]);                % Median

figure, subplot(1,3,1), imshow(xn_ga), title('Noisy Image(gaussian)')
subplot(1,3,2), imshow(yb_ga), title('Bilateral Filter')
subplot(1,3,3), imshow(ym_ga), title('Median Filter')

psnr_n_ga=psnr(x1,xn_ga,255);
psnr_b_ga=psnr(x1,yb_ga,255);
psnr_m_ga=psnr(x1,ym_ga,255);