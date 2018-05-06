function ccc=mfcc_gai(x,fs,p,frameSize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%对输入的语音序列的频谱x进行MFCC参数的提取，返回MFCC参数和一阶
%差分MFCC参数，Mel滤波器的个数为p，采样频率为fs
%对x每frameSize点分为一帧，相邻两帧之间的帧移为inc
% 提取Mel滤波器参数，用汉明窗函数
bank=melbankm(p,frameSize,fs,0,0.5,'m');
% 归一化Mel滤波器组系数
bank=full(bank);
bank=bank/max(bank(:));
bank=bank(:,2:4001);
p2=p/2;
% DCT系数,12*p
for k=1:p2
    n=0:p-1;
    dctcoef(k,:)=cos((2*n+1)*k*pi/(2*p));
end

% 归一化倒谱提升窗口
w = 1 + 6 * sin(pi * [1:p2] ./ p2);
w = w/max(w);

% 计算每帧的MFCC参数
for i=1:size(x,2)
    t = x(:,i);
    t = t.^2;
    cc=bank * t;                     %每一个MEL滤波器与频谱相乘累加
    c1=dctcoef * log(cc+0.0001);
    c2 = c1.*w';
    m(i,:)=c2';
end

%差分系数
%dtm = zeros(size(m));
%for i=3:size(m,1)-2
% dtm(i,:) = -2*m(i-2,:) - m(i-1,:) + m(i+1,:) + 2*m(i+2,:);
%end
%dtm = dtm / 3;
%合并MFCC参数和一阶差分MFCC参数
ccc = m;
%去除首尾两帧，因为这两帧的一阶差分参数为0
%ccc = ccc(3:size(m,1)-2,:);