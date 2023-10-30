% The Function of WLS filter
% Date: 2023.10.24
% Author: choongman.lee

function [out1,out2] = wls_filter(img,lambda,alpha)
    [H,W]=size(img);
    x=img(:);
    P=H*W;
    eps=0.1;
    L=log(x+eps);
    img_t=reshape(x,H,W);
    out1=img_t;

    diag1=ones(P,1);
    diag2=-diag1;
    B(:,1)=diag1;
    B(:,2)=diag2;
    d=[0,-1];
    Dy=spdiags(B,d,P,P);
    [iy,jy,sy]=find(Dy);
    k=size(iy);
    for n=1:k
        if(mod(iy(n),H)==1)
            sy(n)=0;
        end
    end
    Dy=sparse(iy,jy,sy,P,P);

    dx=[0,H];
    Dx=spdiags(B,dx,P,P);
    [ix,jx,sx]=find(Dx);
    k=size(ix);
    for n=1:k
        if(ix(n)>P-H)
            sx(n)=0;
        end
    end
    Dx=sparse(ix,jx,sx,P,P);

    if(~exist('alpha','var'))
        alpha=1.2;
    end
    if(~exist('lambda','var'))
        lambda = 1;
    end
    smallNum = 0.0001;
    
    ax=Dx*L;
    ax=lambda./(abs(ax).^alpha+smallNum);
    ay=Dy*L;
    ay=lambda./(abs(ay).^alpha+smallNum);
    Ax=spdiags(ax,0,P,P);
    Ay=spdiags(ay,0,P,P);
    
    D=Dx'*Ax*Dx+Dy'*Ay*Dy;
    D=speye(P)+D;
    
    yy=D\x;
    
    y=reshape(yy,H,W);
    
    y=min(y,1);
    y=max(y,0);

    out2=y;
end