function [h,predot,q ] = shuchilvboqi2( interval,num)
%求矩形的梳齿滤波器
% 输入interval为对数域的采样间隔 ,num为梳齿滤波器的点数
%输出为梳齿滤波器，q为滤波器的横坐标，predot为梳齿滤波器第一个峰值之前的点数
q=log(0.5):interval:log(10.5);
h=1./(1.045-cos(2*pi*exp(q)));            
h=h-min(h);
h=h./max(h);

l1=find(h>0.34);   %宽度阈值
l2=find(h<=0.34);
h(l1)=1.3;           %谷峰
h(l2)=-0.24;        %谷底

predot=round(-log(0.5)/interval);           %求梳齿滤波器第一个峰值之前的点数

end

