function [truepit,frameTime] = F2( x1,fs )
%求基频
% x为输入音频，truepit为基频
%先用DIS切分，再对一段音频用PEFAC提取多基音候选值（将候选基频中将在频谱中小于某一阈值的删去）
candidate=3;                                       %候选基频的数量
%%
%预处理归一化，预加重，分帧，求语谱图
xx=x1-mean(x1);
x=xx/max(abs(xx));                      %归一化信号

%分帧
wlen=320;                               % 设置帧长为40ms
win=hamming(wlen);                      % 设置窗函数
inc=160;                                % 求帧移
y=enframe(x,win,inc)';                  % 分帧
fn=size(y,2);                           % 求帧数
frameTime=(((1:fn)-1)*inc+wlen/2)/fs;   % 计算每帧对应的时间
%求语谱图
NFFT=8000;
W2=NFFT/2+1;
n2=2:W2;
freq=(n2-1)*fs/NFFT;                    % 计算FFT后的频率刻度
Y=fft(y,NFFT);
Y=abs(Y(n2, : ));                       %取1-4000hz之内的频率点
%%
%作图
figure(1)
colormap(1-gray);
imagesc(frameTime,freq,Y);
axis xy; ylabel('频率/Hz');xlabel('时间/s');
title('语谱图');
grid on;
%%
%频谱切分得到分段的位置
dis=spectrum_dis(y,fs);
for i=1:length(dis)
    figure(1)
    line([frameTime(dis(i)),frameTime(dis(i))],[1,4000],'linewidth',1,'color','r','LineStyle','--');
    hold on;
end
%%
%方差法进行无声段检测
[unvoicep]=unvoice_detect1(y,fn,dis);
figure(1)
plot(frameTime(1:dis(1)),repmat(unvoicep(1),1,dis(1)));
for i=1:length(dis)-1
    plot(frameTime(dis(i)+1:dis(i+1)),repmat(unvoicep(i+1),1,dis(i+1)-dis(i)));
end

%%
num=1600;                                   %梳状滤波器点数
%========================================将一帧信号转换成对数间隔相等的信号
interval=log(21)/(num-1);                   %先设定变换之后的样点间隔
loginterval=exp(interval);                  %对数频率间隔转换成频率间隔
for i=1:fn                                  %对信号重新抽样
    l=1;
    resample(1,i)=Y(l,i);
    for j=2:1000000                         %1000要大于l>4000时的循环次数
        l=l*loginterval;                    %对应频率的位置
        if(l>NFFT/2)
            break;
        end
        pre=floor(l);
        next=ceil(l);
        resample(j,i)=(Y(pre,i)+Y(next,i))/2;           %由他附近的两个点取均值
    end
end

%%
%计算梳齿滤波器
[h,predot ,q] = shuchilvboqi2( interval,num );
%%
%作梳齿滤波器得图
% figure(2)
% plot(exp(q),h);
% title('训练好的矩形梳齿滤波器');
% xlabel('峰的个数');
% ylabel('幅度');
%%
%多基频提取houpit
%========================使用卷积求基频
h2=fliplr(h);                                       %将顺序调换

houpit=zeros(candidate,fn);                         %用于保存最后的候选基音
houval=zeros(candidate,fn);
% pit3=cell(1,fn);                                  %用于保存每帧去完倍频之后的频率
% val3=cell(1,fn);
cor=floor(log(1000)/interval);                      %1hz--1000hz之间对应对数域的点数
freq1=exp([1:cor].*interval);                       %转换之后的对数频域坐标
predominance=zeros(cor,fn);                         %用于保存对数域的pefac显著度
TT1=0;                                              %显著度阈值(取舍值得斟酌)

for i=1:fn
    y=conv(h2,resample( : ,i));                     %求卷积
    y1=y(num-predot:end);
    predominance( : ,i)=y1(1:cor);                  %1hz-1000hz的显著度
    [loc2,val]=findpeaks(predominance( : ,i));      %首先找出1hz-1000hz内所有的峰值
    pit=round(exp((loc2).*interval));               %转换成对应的实际频率(取整),loc2可以减1，也可以不减1
    pit1=pit(pit>=70);                              %找出在》70HZ的频率
    val1=val(pit>=70);
    %下面这一句相当于改变TT1
    val1=val1+400;
    pit12=pit1(val1>TT1);                           %找出val值（显著值）大于TT1的频率
    val12=val1(val1>TT1);
    %用频谱的方法删去频谱过小的值
    if ~isempty(pit12)                              %判断是否非空
        [pit3,l]=f1(pit12,Y(:,i));                  %在所有的显著度峰值对应的频率中找出在频谱中大于某一阈值的频率
        val3=val12(l);
    else
        pit3=[];
        val3=[];
    end
    if ~isempty(pit3)
        %先按照显著度大小排序
        [val2,loc1]=sort(val3,'descend');
        pit2=pit3(loc1);
        %--------------------------------------------------------------------------------
        con1=1;                                         %用来控制保存数据的位置
        houpit(con1,i)=pit2(1);
        houval(con1,i)=val2(1);
        for j=2:length(pit2)                            %将在频域成倍频半频关系的峰值去掉
            flag=0;
            for k=1:con1
                if abs((pit2(j)-houpit(k,i))/houpit(k,i))<0.029
                    flag=1;
                    break;
                end
            end
            
            if flag==0
                con1=con1+1;
                houpit(con1,i)=pit2(j);
                houval(con1,i)=val2(j);
            end
            if con1>=candidate
                break;
            end
        end
        %----------------------------------------------------------------------------
    end
end
% figure(4)
% plot(freq1,predominance( : ,fn1));
% axis xy;
% xlabel('频率/hz');
% ylabel('显著度');
% title([num2str(fn1),'帧,1-1000hz的PEFAC显著图']);
% grid on;
%%
%基音跟踪candidate,houpit,houval,dis
if unvoicep(1)~=100
    houcontour{1}=searchmelody1(houpit(:,1:dis(1)),houval(:,1:dis(1)));
    truepit=nntestcontour(houcontour{1}(1,:),Y(:,1:dis(1)));
    % truepit=houcontour{1}(1,:);
    %基于段用神经网络模型判别统计该段是否为人声主旋律
    
else
    houcontour{1}=[];
    truepit=zeros(1,dis(1));
end
for i=1:length(dis)-1
    if unvoicep(i+1)~=100
        houcontour{i+1}=searchmelody1(houpit(:,dis(i)+1:dis(i+1)),houval(:,dis(i)+1:dis(i+1)));
        truepit=[truepit nntestcontour(houcontour{i+1}(1,:),Y(:,dis(i)+1:dis(i+1)))];
        %         truepit=[truepit houcontour{i+1}(1,:)];
        %基于段用神经网络模型判别统计该段是否为人声主旋律
        
    else
        houcontour{i+1}=[];
        truepit=[truepit zeros(1,dis(i+1)-dis(i))];
    end
end
if unvoicep(i+2)~=100
    houcontour{i+2}=searchmelody1(houpit(:,dis(i+1)+1:fn),houval(:,dis(i+1)+1:fn));
    truepit=[truepit nntestcontour(houcontour{i+2}(1,:),Y(:,dis(i+1)+1:fn))];
    %     truepit=[truepit houcontour{i+2}(1,:)];
    %基于段用神经网络模型判别统计该段是否为人声主旋律
    
else
    houcontour{i+2}=[];
    truepit=[truepit zeros(1,fn-dis(i+1))];
end

end

