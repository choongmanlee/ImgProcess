% Image Signal Processing
% Title: HW #2 Image Enhancement
% Date: 2023.09.20
% Revised Date: 2023.09.24
% Author: choongman.lee

LPF_TYPE=1;     % 0: Box Filter, 1: Gaussian Filter
L=7;            % filter size(L x L)
alpha=3;        % for enhancement

PADARR=true;    % true: use padarray function

img=imread('tiger.jpg');
%img=imread('squirrel.jpg');
%img=imread('pizza.jpg');
gray_img = rgb2gray(img);
[A,B,C]=size(img);
img=double(img)/255;
Ri=zeros(A,B);
Gi=zeros(A,B);
Bi=zeros(A,B);

for a=1:A
    for b=1:B
        Ri(a,b)=img(a,b,1);
        Gi(a,b)=img(a,b,2);
        Bi(a,b)=img(a,b,3);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Low Pass Filter | L x L Gaussian or Box Filter %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lpf=ones(L,L);
M=(L+1)/2;

if(LPF_TYPE==1) % Gaussian Filter
    sigma=3;
    for m=1:L
        for n=1:L
            lpf(m,n)=(exp((-(m-M)^2-(n-M)^2)/2/sigma^2));
        end
    end
    s=sum(lpf(:));
    lpf=lpf/s;
else            % Box Filter
    lpf=1/L^2*lpf;
end

gray_img=double(gray_img)/255;
Glpf=conv2(gray_img,lpf,'same');

imwrite(gray_img,'gray_img.jpg');
imwrite(Glpf,'lpf_gray_img.jpg');

%subplot(1,2,1), imshow(gray_img), title('Gray Image')
%subplot(1,2,2), imshow(Glpf), title('Low-Pass Filtering Gray Image')

%[F,w1,w2]=freqz2(lpf);
%subplot(1,2,1), surf(lpf), title('Time domain')
%subplot(1,2,2), surf(w1,w2,abs(F)), title('Frequency domain')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edge Detector = High Pass Filter | edge=X-LPF(X) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=zeros(L,L);
x(M,M)=1;

edge=x-lpf;

if(PADARR)  % Return the central part of the convolution after zero-padding
    Rp=padarray(Ri,[M-1 M-1],'both');
    Gp=padarray(Gi,[M-1 M-1],'both');
    Bp=padarray(Bi,[M-1 M-1],'both');

    Rpe=conv2(Rp,edge);
    Gpe=conv2(Gp,edge);
    Bpe=conv2(Bp,edge);

    Xr=zeros(A,B);
    Xg=zeros(A,B);
    Xb=zeros(A,B);

    for a1=L:A+(L-1)
        for b1=L:B+(L-1)
            Xr(a1-(L-1),b1-(L-1))=Rpe(a1,b1);
            Xg(a1-(L-1),b1-(L-1))=Gpe(a1,b1);
            Xb(a1-(L-1),b1-(L-1))=Bpe(a1,b1);
        end
    end
else        % Return the central part of the convolution with same size as input array
    Xr=conv2(Ri,edge,'same');
    Xg=conv2(Gi,edge,'same');
    Xb=conv2(Bi,edge,'same');
end

edge_img=zeros(A,B,3);
edge_img(:,:,1)=Xr;
edge_img(:,:,2)=Xg;
edge_img(:,:,3)=Xb;

%imshow(edge_img)
imwrite(edge_img,'edge_img.jpg');

%surf(edge)         % time domain
%[E,w1,w2]=freqz2(edge);
%surf(w1,w2,abs(E)) % frequency domain

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enhancement | enhancement=X+alpha*edge %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y=x+alpha*edge;

Yr=conv2(Ri,y,'same');
Yg=conv2(Gi,y,'same');
Yb=conv2(Bi,y,'same');

enhance_img=zeros(A,B,3);
enhance_img(:,:,1)=Yr;
enhance_img(:,:,2)=Yg;
enhance_img(:,:,3)=Yb;

imwrite(enhance_img,'enhance_img.jpg');

subplot(1,2,1), imshow(img), title('Original Image')
subplot(1,2,2), imshow(enhance_img), title('Enhanced Image')

%surf(y)            % time domain
%[Y,w1,w2]=freqz2(y);
%surf(w1,w2,abs(Y)) % frequency domain
