function y= convyanbichpro(a,x,fs,NFFT)
%% 用卷积波形的方法进行掩蔽
%  convyanbi是用第一个峰进行卷积，改进后用几个峰求平均后卷积

%% 用卷积的方法进行掩蔽
%首先找到基频的那个峰，并根据每个峰的梯度进行补全，然后找倍频的峰值进行卷积
%a是基频，x是那一帧的频谱图,fs维采样频率，NFFT为傅里叶变换点数
%找对应倍频上的峰值归一化，最后卷积

a=ceil(a);
coe=fs/NFFT;                                         %用来控制NFFT变化对掩蔽影响的一个系数
%% 在混合语音中找第一个峰
for i=round(a/coe):1200/coe
    if(x(i)<x(i-1)&&x(i)<x(i+1))
        k2=i;  %后一个波谷
        break;
    end
    k2=i;
end
for j=round(a/coe):-1:50/coe
    if(x(j)<x(j-1)&&x(j)<x(j+1))
        k1=j;
        break;
    end
    k1=j;
end
y1=x(k1:k2);                                        %第一个波峰

%找第二个峰
for i=round(a*2/coe):2200/coe
    if(x(i)<x(i-1)&&x(i)<x(i+1))
        k4=i;                                       %后一个波谷
        break;
    end
    k4=i;
end
if round(2*a/coe)>=k2
    for j=round(a*2/coe):-1:k2
        if(x(j)<x(j-1)&&x(j)<x(j+1))
            k3=j;
            break;
        end
        k3=j;
    end
else
    k3=round(2*a/coe);
end

y2=x(k3:k4);                                        %第二个波峰
% figure(2)
[~,loc1]=max(y1);
[~,loc2]=max(y2);
if k1~=k2 && loc1>=3 && length(y1)-loc1>=2
    %先求前半部分需要补齐的点
    x1(1:3)=y1(3:-1:1);
    i=3;
    while x1(i)>0&&x1(i)<x1(i-1)
        diff1=x1(i-1)-x1(i);
        diff2=x1(i-2)-x1(i-1);
        ddiff=diff2-diff1;
        diff=diff1-ddiff;
        i=i+1;
        x1(i)=x1(i-1)-diff;
    end
    x1(i)=0;
    
    %再求后半部分需要补齐的点
    x2(1:3)=y1(end-2:end);
    i=3;
    while x2(i)>0&&x2(i)<x2(i-1)
        diff1=x2(i)-x2(i-1);
        diff2=x2(i-1)-x2(i-2);
        ddiff=diff1-diff2;
        diff=diff1+ddiff;
        i=i+1;
        x2(i)=x2(i-1)+diff;
    end
    x2(i)=0;
    %先将前半部分倒过来
    x3=fliplr(x1(4:end));
    %将三部分合并到一起
    y1=[x3 y1' x2(4:end)];
    
elseif k3~=k4 && loc2>=3 && length(y2)-loc2>=2
    %先求前半部分需要补齐的点
    x1(1:3)=y2(3:-1:1);
    i=3;
    while x1(i)>0&&x1(i)<x1(i-1)
        diff1=x1(i-1)-x1(i);
        diff2=x1(i-2)-x1(i-1);
        ddiff=diff2-diff1;
        diff=diff1-ddiff;
        i=i+1;
        x1(i)=x1(i-1)-diff;
    end
    x1(i)=0;
    
    %再求后半部分需要补齐的点
    x2(1:3)=y2(end-2:end);
    i=3;
    while x2(i)>0&&x2(i)<x2(i-1)
        diff1=x2(i)-x2(i-1);
        diff2=x2(i-1)-x2(i-2);
        ddiff=diff1-diff2;
        diff=diff1+ddiff;
        i=i+1;
        x2(i)=x2(i-1)+diff;
    end
    x2(i)=0;
    %先将前半部分倒过来
    x3=fliplr(x1(4:end));
    %将三部分合并到一起
    y1=[x3 y2' x2(4:end)];
else
    y1=y1'/max(y1);
    y2=y2'/max(y2);
    if loc1<loc2
        y3(loc2-loc1+1:loc2-loc1+length(y1))=y1;            %将y1的最大点平移到和y2对齐
        if length(y3)==length(y2)
            y1=y3+y2;
        elseif length(y3)<length(y2)
            y1=[y3 zeros(1,length(y2)-length(y3))]+y2;
        else
            y1=[y2 zeros(1,length(y3)-length(y2))]+y3;
        end
    else
        y3(loc1-loc2+1:loc1-loc2+length(y2))=y2;            %将y2的最大点平移到和y1对齐
        if length(y3)==length(y1)
            y1=y3+y1;
        elseif length(y3)<length(y1)
            y1=[y3 zeros(1,length(y1)-length(y3))]+y1;
        else
            y1=[y1 zeros(1,length(y3)-length(y1))]+y3;
        end
    end
end
y1=y1/max(y1);
[~,l]=max(y1);

%% 再找倍频处的峰值
aa=zeros(1,NFFT/2);
a1=a;                                                       %用来控制掩蔽之后基频的位置

for k=1:floor(fs/2/a)
    %将倍频处的幅值赋给ka，并寻找附近最大的值
    ka=x(round(a*k/coe));
    aa(round(a1*k/coe))=ka;
end
y=conv(y1,aa);
y=y(l:l+fs/2/coe-1);
end






