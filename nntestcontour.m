function [ contour] = nntestcontour( x,y)
%ʹ��������ģ�Ͳ����������Ƿ�Ϊ������������
%  xΪ��ѡ�����ߣ�yΪ��Ӧ��Ƶ��,contourΪ�öε�������
load net7.mat                                      %����������ģ��
[a,b]=size(x);
fs=8000;
p=24;
NFFT=8000;
for i=1:a
    for k=1:b
        yy{i}(:,k)= convyanbichpro(x(i,k),y(:,k),fs,NFFT);      %���ݻ�Ƶ��Ƶ�׽����ڱ�
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

