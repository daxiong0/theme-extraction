function [h,predot,q ] = shuchilvboqi2( interval,num)
%����ε�����˲���
% ����intervalΪ������Ĳ������ ,numΪ����˲����ĵ���
%���Ϊ����˲�����qΪ�˲����ĺ����꣬predotΪ����˲�����һ����ֵ֮ǰ�ĵ���
q=log(0.5):interval:log(10.5);
h=1./(1.045-cos(2*pi*exp(q)));            
h=h-min(h);
h=h./max(h);

l1=find(h>0.34);   %�����ֵ
l2=find(h<=0.34);
h(l1)=1.3;           %�ȷ�
h(l2)=-0.24;        %�ȵ�

predot=round(-log(0.5)/interval);           %������˲�����һ����ֵ֮ǰ�ĵ���

end

