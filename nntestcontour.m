function [ contour] = nntestcontour( x,y)
%使用神经网络模型测试旋律线是否为人声的旋律线
%  x为候选旋律线，y为对应的频谱,contour为该段的旋律线
load net7.mat                                      %导入神经网络模型
[a,b]=size(x);
fs=8000;
p=24;
NFFT=8000;
for i=1:a
    for k=1:b
        yy{i}(:,k)= convyanbichpro(x(i,k),y(:,k),fs,NFFT);      %根据基频对频谱进行掩蔽
    end
    c=mfcc_gai(yy{i},fs,p,NFFT)';
    yfit=sim(net,c);
    s1=0;
    for k=1:b
        [~,Index]=max(yfit(:,k));
        if Index==1
            s1=s1+1;
        end
        
    end
    p1(i)=s1/b;
end
% [pp,index1]=max(p1);
if p1>0.5
    contour=x;
else
    contour=zeros(1,b);
end
end

