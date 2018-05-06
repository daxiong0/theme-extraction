function [h,predot ,q] = shuchilvboqi1( interval,num )
%椭圆形的梳齿滤波器
% 输入interval为对数域的采样间隔 ,num为梳齿滤波器的点数
%输出为梳齿滤波器，q为滤波器的横坐标，predot为梳齿滤波器第一个峰值之前的点数
q=log(0.5):interval:log(10.5);
h=1./(1.045-cos(2*pi*exp(q)));             %1.045时为正确率最高的时候
h=h-min(h);
h=h./max(h);
h=h-0.21;
h=h./max(h);
predot=round(-log(0.5)/((log(21)/(num-1))));           %求梳齿滤波器第一个峰值之前的点数

end

