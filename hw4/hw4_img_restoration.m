% Image Signal Processing
% Title: HW #4 Image Restoration
% Date: 2023.10.11
% Author: choongman.lee

clear all;

BlurMode=0;   % 0: by Gaussian filter, 1: Motion Blur
Apply_ExtPAD=true;
ImgCrop=true;

img=imread('tiger.jpg'); img=rgb2gray(img);
%img=imread('chart3.bmp');
[A,B]=size(img);
img=double(img)/255;

%% Make a blurred image by Gaussian Filter or Motion blur function
L=7;
M=(L+1)/2;

if(BlurMode==0) % Gaussian filter
    g_filter=zeros(L,L);
    sigma_d=3;    
    for m=1:L
        for n=1:L
            g_filter(m,n)=(exp((-(m-M)^2-(n-M)^2)/2/sigma_d^2));
        end
    end
    s=sum(g_filter(:));
    g_filter=g_filter/s;
    filter_img=conv2(img,g_filter,'same');
    filter_img([1:3,A-2:A],:)=[]; filter_img(:,[1:3,B-2:B])=[];
else            % Motion Blur
    m_blur=fspecial('motion',9,45);
    filter_img=conv2(img,m_blur,'same');
    g_filter=m_blur;
end

blur_img=filter_img;

%% Image extension and zero-padding
E=0; zp=0;
if(Apply_ExtPAD)
    E=5;
    filter_img=padarray(filter_img,[E E],'both','replicate');
    zp=15;
    filter_img=padarray(filter_img,[zp zp],0,'both');
end

%% Wiener filtering
af=padarray(filter_img,[M-1 M-1],0,'post');
[Nn,Mm]=size(af);

hf=padarray(g_filter,[Nn-L Mm-L],0,'post');
HF=fft2(hf);
YF=fft2(af);

eps=0.01;
D=HF.*conj(HF)+eps;
W=conj(HF)./D;
XH=W.*YF;
xh=ifft2(XH);
xx=real(xh(1:A-2*L+2*(E+zp),1:B-2*L+2*(E+zp)));

%% Image Cropping
if(ImgCrop)
    x1=2*(E+zp); x2=A-2*L; x3=A-2*L+2*(E+zp);
    xx([1:x1,A-2*L:A-2*L+2*(E+zp)],:)=[]; xx(:,[1:x1,B-2*L:B-2*L+2*(E+zp)])=[];
end

%% Deblurring using deconvwnr or deconvlucy, Matlab built-in function
y=deconvwnr(blur_img,g_filter,0.01);
y_luc=deconvlucy(blur_img,g_filter);

%% Deblurring using deconvwnr with edgetaper, Matlab built-in function
bb=edgetaper(blur_img,g_filter);
yy=deconvwnr(bb,g_filter,0.01);

%% Plot
figure, subplot(1,4,1), imshow(blur_img), title('Blurred Image')
subplot(1,4,2), imshow(xx), title('Deblurred Image')
subplot(1,4,3), imshow(y), title('Deblurred Image by deconvwnr function')
subplot(1,4,4), imshow(yy), title('Deblurred Image by edgetaper & deconvwnr')
figure, subplot(1,2,1), imshow(y), title('Deblurred Image by deconvwnr')
subplot(1,2,2), imshow(y_luc), title('Deblurred Image by deconvlucy')

%% Denoising using Wiener filter
noise_var=40/255;
nn=noise_var*randn([A,B]);
noisy_img=double(img)+noise_var*randn([A,B]);
for a=1:A
    for b=1:B
        noisy_img(a,b)=min(1,noisy_img(a,b));
        noisy_img(a,b)=max(0,noisy_img(a,b));
    end
end

NN=fft2(nn);
Npower=NN.*conj(NN);
nYF=fft2(noisy_img);
Spower=nYF.*conj(nYF);
HHF=1;
NSR=Npower./abs(Spower-Npower);
DD=HHF.*conj(HHF)+NSR+eps;
WW=conj(HHF)./DD;
XXH=WW.*nYF;
xxh=ifft2(XXH);

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

%% Plot
figure, subplot(1,3,1), imshow(img), title('Original Image')
subplot(1,3,2), imshow(noisy_img), title('Noisy Image')
subplot(1,3,3), imshow(xxh), title('Denoised Image by weiner filter')
figure, subplot(1,2,1), imshow(xxh), title('Denoised Image by weiner filter')
subplot(1,2,2), imshow(b_filter_img), title('Denoised Image by bilateral filter')

%% PSNR
psnr_n=psnr(noisy_img,img);
psnr_wnr=psnr(xxh,img);
psnr_btr=psnr(b_filter_img,img);