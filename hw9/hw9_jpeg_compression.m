% Image Signal Processing
% Title: HW #9 JPEG Compression
% Date: 2023.11.14
% Author: choongman.lee

close all;
clear all;

%% Load image
x=imread("lena.gif");
imwrite(x,'out_matlab.jpg')
xc=imread('out_matlab.jpg');
[H,W]=size(x);

%% Quantization matrix design
% Standard Quantization matrix(for Luminance)
QL=[16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];

% Scaling Quantization matrix by QF
QF=75;
if(QF<50)
    S=5000/QF;
else
    S=200-2*QF;
end

Q=S*QL+50;
Q=floor(Q/100);
for j=1:8
    for i=1:8
        Q(i,j)=max(Q(i,j),1);
    end
end

%% Image(8x8 block)->DCT->Quantization->Dequantization->IDCT->Image(8x8 block)=>Final Image(HxW)
for n=1:W/8
    for m=1:H/8
        for b=(8*n-7):8*n
            for a=(8*m-7):8*m
                xb(a-8*(m-1),b-8*(n-1))=x(a,b);
                yb=dct2(xb);    % dct
            end
        end
        y_q=round(yb./Q);       % quantization
        y_dq=y_q.*Q;            % dequantization
        y_t=idct2(y_dq);        % inverse dct
        y(8*m-7:8*m,8*n-7:8*n)=y_t;
    end
end
y=uint8(y);
imwrite(y,'out_coding.jpg')

%% Compare
figure, subplot(1,3,1), imshow(x), title('original')
subplot(1,3,2), imshow(y), title('jpeg(coding)')
subplot(1,3,3), imshow(xc), title('jpeg(matlab)')
psnr_jpeg_coding=psnr(y,x);
psnr_jpeg_matlab=psnr(xc,x);