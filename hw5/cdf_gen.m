% cdf(Cumulative Density Function)
% Date: 2023.10.21
% Author: choongman.lee

function c = cdf_gen(x)
    [H,W]=size(x);
    
    h=imhist(x);
    p=h/(H*W);
    
    c=zeros(256,1);
    c(1)=p(1);
    for n=1:255
        c(n+1)=c(n)+p(n+1);
    end
    figure, plot(c)
end