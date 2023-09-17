% Image Signal Processing
% Title: HW #1 Demosaic
% Date: 2023.09.17
% Author: choongman.lee

PADARR=true;    % true: use padarray function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verify demosaic algorithm using the synthetic cfa from a rgb image %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=imread('bird_img.png');
[M,N,P]=size(x);
x=double(x)/255;
R=zeros(M,N);
G=zeros(M,N);
B=zeros(M,N);

for m=1:M
    for n=1:N
        if(mod(m,2)==mod(n,2))
            G(m,n)=x(m,n,2);
        end
        if(mod(m,2)==1 && mod(n,2)==0)
            B(m,n)=x(m,n,3);
        end
        if(mod(m,2)==0 && mod(n,2)==1)
            R(m,n)=x(m,n,1);
        end
    end
end

cfa_synth=R+G+B;

Kg=[0.00 0.25 0.00;
    0.25 1.00 0.25;
    0.00 0.25 0.00];

Kbr=[0.25 0.50 0.25;
     0.50 1.00 0.50;
     0.25 0.50 0.25];

if(PADARR)
    Gp=padarray(G,[1 1],'both','replicate');
    Bp=padarray(B,[1 1],'both','replicate');
    Rp=padarray(R,[1 1],'both','replicate');

    Gii=conv2(Gp,Kg);
    Bii=conv2(Bp,Kbr);
    Rii=conv2(Rp,Kbr);

    Ri=zeros(M,N);
    Gi=zeros(M,N);
    Bi=zeros(M,N);

    for m1=3:M+2
        for n1=3:N+2
            Gi(m1-2,n1-2)=Gii(m1,n1);
            Bi(m1-2,n1-2)=Bii(m1,n1);
            Ri(m1-2,n1-2)=Rii(m1,n1);
        end
    end
else
    Gi=conv2(G,Kg,'same');
    Bi=conv2(B,Kbr,'same');
    Ri=conv2(R,Kbr,'same');
end

y=zeros(M,N,P);
y(:,:,1)=Ri;
y(:,:,2)=Gi;
y(:,:,3)=Bi;

%imshow(cfa_synth)
%imshow(y)
imwrite(cfa_synth,'bird_img_cfa_synth.bmp');
imwrite(y,'bird_img_demosaic.bmp');

psnr_val=psnr(y,x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply the demosaic algorithm to generate rgb image from cfa image %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

info=imfinfo('my_test_img.dng');
t=Tiff('my_test_img.dng');

cfa=read(t);
cfa=double(cfa);
pmax=double(max(max(cfa)));

ti=cfa/pmax;
imwrite(ti,'my_test_img_cfa.bmp');

cfa_gamma=sqrt(cfa);
pmax_gamma=double(max(max(cfa_gamma)));

ti_gamma=cfa_gamma/pmax_gamma;
imwrite(ti_gamma,'my_test_img_cfa_gamma.bmp');

z=imread('my_test_img_cfa_gamma.bmp');

[A,B]=size(z);
z=double(z)/255;
Rz=zeros(A,B);
Gz=zeros(A,B);
Bz=zeros(A,B);

for a=1:A
    for b=1:B
        if(mod(a,2)==mod(b,2))
            Gz(a,b)=z(a,b);
        end
        if(mod(a,2)==1 && mod(b,2)==0)
            Bz(a,b)=z(a,b);
        end
        if(mod(a,2)==0 && mod(b,2)==1)
            Rz(a,b)=z(a,b);
        end
    end
end

if(PADARR)
    Gzp=padarray(Gz,[1 1],'both','replicate');
    Bzp=padarray(Bz,[1 1],'both','replicate');
    Rzp=padarray(Rz,[1 1],'both','replicate');

    Gtemp=conv2(Gzp,Kg);
    Btemp=conv2(Bzp,Kbr);
    Rtemp=conv2(Rzp,Kbr);

    Ri_z=zeros(A,B);
    Gi_z=zeros(A,B);
    Bi_z=zeros(A,B);

    for c=3:A+2
        for d=3:B+2
            Gi_z(c-2,d-2)=Gtemp(c,d);
            Bi_z(c-2,d-2)=Btemp(c,d);
            Ri_z(c-2,d-2)=Rtemp(c,d);
        end
    end
else
    Gi_z=conv2(Gz,Kg,'same');
    Bi_z=conv2(Bz,Kbr,'same');
    Ri_z=conv2(Rz,Kbr,'same');
end

w=zeros(A,B,3);
w(:,:,1)=Bi_z;
w(:,:,2)=Gi_z;
w(:,:,3)=Ri_z;

imshow(w)
imwrite(w,'my_test_img_demosaic.bmp');
