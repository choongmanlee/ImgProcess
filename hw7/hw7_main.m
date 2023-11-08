% Image Signal Processing
% Title: HW #7 Image interpolation by Nyquist filter
% Date: 2023.11.03
% Author: choongman.lee

clear all;
close all;

M=4;    % decimation(1/M)
L=4;    % interpolation by L
N=28;   % filter order
bw=0.2; % Bandwidth, BW=bw*(L/2)

interpolation_5_7=false;   % 5:7 interpolation

%% Load Image
img=imread('tiger.jpg');
x=img;
[H,W,~]=size(x);
img=rgb2ycbcr(img);
img_y=(img(:,:,1));
img_y=double(img_y);
img_y=img_y/255;

%% LPF(Gaussian Filter)
[~,out_y]=gaussian_filter(img_y,5); % 5x5 Guassian filter
img(:,:,1)=255*out_y;
img=ycbcr2rgb(img);

%% Decimation(1/M)
xd=decimation(img,M);
figure(1), imshow(x), title('original')
figure(2), imshow(xd), title('decimination')
imwrite(xd,'decimination.jpg');

%% Expansion(x L)
xe=expansion(xd,L);
figure(3), imshow(uint8(xe))

%% Image interpolation by Nyquist filter
y=interpolation_nyquist(xd,N,L,bw); % order:28, band:4, bw:0.2
y=uint8(y);
[Hy,Wy,~]=size(y);
if(abs(H-Hy)~=0 || abs(W-Wy)~=0)
    pdH=abs(H-Hy);
    pdW=abs(W-Wy);
    y=padarray(y,[pdH pdW],'replicate','post');
end

%% Bicubic interpolation
y_bc=imresize(xd,L);
[Hy,Wy,~]=size(y_bc);
if(abs(H-Hy)~=0 || abs(W-Wy)~=0)
    pdH=abs(H-Hy);
    pdW=abs(W-Wy);
    y_bc=padarray(y_bc,[pdH pdW],'replicate','post');
end

%% Compare
psnr_nq=psnr(y,x);      % nyquist
psnr_bc=psnr(y_bc,x);   % bicubic
figure(4), subplot(1,3,1), imshow(x), title('Original')
subplot(1,3,2), imshow(y), title('Nyquist')
subplot(1,3,3), imshow(y_bc), title('Bicubic')
imwrite(y,'interpolation_nyquist.jpg');
imwrite(y_bc,'interpolation_bicubic.jpg');

%% Frequency response of Niquist filter
Hd=nyquist(N,L,bw);
b=get(Hd,'Numerator');
[B,w]=freqz(b,1);
figure(5), plot(w,abs(B))

%% upsampling by 7 & decimation by 5
if(interpolation_5_7)
    xx=imread('building.jpg');
    N1=42; L1=7; bw1=0.1;
    y1=interpolation_nyquist(xx,N1,L1,bw); % order:42, band:7, bw:0.1
    xd1=decimation(y1,5);
    figure(6), imshow(uint8(y1))
    figure(7), imshow(uint8(xd1))

    Hd1=nyquist(N1,L1,bw);
    b1=get(Hd1,'Numerator');
    [B1,w1]=freqz(b1,1);
    figure(8), plot(w1,abs(B1))
end