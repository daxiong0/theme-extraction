function [unvoicep] = unvoice_detect1( x,fn,c )
%非浊音段检测
% x为归一化音频.c为切分的位置,unvoicecep为基于切分段的清音段的位置
NFFT=1600;

Y=fft(x,NFFT);                                  % FFT变换
N2=NFFT/2+1;                                    % 取正频率部分
n2=1:N2;
Y_abs=(abs(Y(n2,:)));                           % 取幅值

for k=1:fn                                      % 计算每帧的频带方差
    Dvar(k)=var(Y_abs(20:400,k))+eps;
end
T1=1.2;     
unvoicep=zeros(1,length(c)+1);                  %用于保存每小块静音的标志
%%
%判断每个小块是清音段还是非清音段
loc1=find(Dvar(1:c(1))<T1 );                    %判断第一个小块是否是清音段，如果是则保存清音段的位置
if length(loc1)>round((c(1))/2) 
   unvoicep(1)=100;
end
for i=1:length(c)-1                             %判断第二个小块到倒数第二个小块是否为清音段，如果是则保存清音段的位置
    loc1=find(Dvar(c(i)+1:c(i+1))<T1);
    if length(loc1)>round((c(i+1)-c(i))/2) 
        unvoicep(i+1)=100;
    end
end
loc1=find(Dvar(c(i+1)+1:fn)<T1 );               %判断最后一个小块是否是清音段，如果是则保存清音段的位置
if length(loc1)>round((fn-c(i+1))/2) 
    unvoicep(i+2)=100;
end
end

