function [h,predot ,q] = shuchilvboqi1( interval,num )
%��Բ�ε�����˲���
% ����intervalΪ������Ĳ������ ,numΪ����˲����ĵ���
%���Ϊ����˲�����qΪ�˲����ĺ����꣬predotΪ����˲�����һ����ֵ֮ǰ�ĵ���
q=log(0.5):interval:log(10.5);
h=1./(1.045-cos(2*pi*exp(q)));             %1.045ʱΪ��ȷ����ߵ�ʱ��
h=h-min(h);
h=h./max(h);
h=h-0.21;
h=h./max(h);
predot=round(-log(0.5)/((log(21)/(num-1))));           %������˲�����һ����ֵ֮ǰ�ĵ���

end

