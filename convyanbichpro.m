function y= convyanbichpro(a,x,fs,NFFT)
%% �þ�����εķ��������ڱ�
%  convyanbi���õ�һ������о�����Ľ����ü�������ƽ������

%% �þ���ķ��������ڱ�
%�����ҵ���Ƶ���Ǹ��壬������ÿ������ݶȽ��в�ȫ��Ȼ���ұ�Ƶ�ķ�ֵ���о��
%a�ǻ�Ƶ��x����һ֡��Ƶ��ͼ,fsά����Ƶ�ʣ�NFFTΪ����Ҷ�任����
%�Ҷ�Ӧ��Ƶ�ϵķ�ֵ��һ���������

a=ceil(a);
coe=fs/NFFT;                                         %��������NFFT�仯���ڱ�Ӱ���һ��ϵ��
%% �ڻ���������ҵ�һ����
for i=round(a/coe):1200/coe
    if(x(i)<x(i-1)&&x(i)<x(i+1))
        k2=i;  %��һ������
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
y1=x(k1:k2);                                        %��һ������

%�ҵڶ�����
for i=round(a*2/coe):2200/coe
    if(x(i)<x(i-1)&&x(i)<x(i+1))
        k4=i;                                       %��һ������
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

y2=x(k3:k4);                                        %�ڶ�������
% figure(2)
[~,loc1]=max(y1);
[~,loc2]=max(y2);
if k1~=k2 && loc1>=3 && length(y1)-loc1>=2
    %����ǰ�벿����Ҫ����ĵ�
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
    
    %�����벿����Ҫ����ĵ�
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
    %�Ƚ�ǰ�벿�ֵ�����
    x3=fliplr(x1(4:end));
    %�������ֺϲ���һ��
    y1=[x3 y1' x2(4:end)];
    
elseif k3~=k4 && loc2>=3 && length(y2)-loc2>=2
    %����ǰ�벿����Ҫ����ĵ�
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
    
    %�����벿����Ҫ����ĵ�
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
    %�Ƚ�ǰ�벿�ֵ�����
    x3=fliplr(x1(4:end));
    %�������ֺϲ���һ��
    y1=[x3 y2' x2(4:end)];
else
    y1=y1'/max(y1);
    y2=y2'/max(y2);
    if loc1<loc2
        y3(loc2-loc1+1:loc2-loc1+length(y1))=y1;            %��y1������ƽ�Ƶ���y2����
        if length(y3)==length(y2)
            y1=y3+y2;
        elseif length(y3)<length(y2)
            y1=[y3 zeros(1,length(y2)-length(y3))]+y2;
        else
            y1=[y2 zeros(1,length(y3)-length(y2))]+y3;
        end
    else
        y3(loc1-loc2+1:loc1-loc2+length(y2))=y2;            %��y2������ƽ�Ƶ���y1����
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

%% ���ұ�Ƶ���ķ�ֵ
aa=zeros(1,NFFT/2);
a1=a;                                                       %���������ڱ�֮���Ƶ��λ��

for k=1:floor(fs/2/a)
    %����Ƶ���ķ�ֵ����ka����Ѱ�Ҹ�������ֵ
    ka=x(round(a*k/coe));
    aa(round(a1*k/coe))=ka;
end
y=conv(y1,aa);
y=y(l:l+fs/2/coe-1);
end






