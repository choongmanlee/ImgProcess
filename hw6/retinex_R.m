% The Function of Retinex for Reflectance
% Date: 2023.10.24
% Author: choongman.lee

function [R,out] = retinex_R(img_org,img,I,eps)
    if(~exist('eps','var'))
        eps=0.1;
    end
    I=double(I);
    R=img./(I+eps);
    for n=1:3
        out(:,:,n)=img_org(:,:,n)./(I+eps);
    end
end