function [unvoicep] = unvoice_detect1( x,fn,c )
%�������μ��
% xΪ��һ����Ƶ.cΪ�зֵ�λ��,unvoicecepΪ�����зֶε������ε�λ��
NFFT=1600;

Y=fft(x,NFFT);                                  % FFT�任
N2=NFFT/2+1;                                    % ȡ��Ƶ�ʲ���
n2=1:N2;
Y_abs=(abs(Y(n2,:)));                           % ȡ��ֵ

for k=1:fn                                      % ����ÿ֡��Ƶ������
    Dvar(k)=var(Y_abs(20:400,k))+eps;
end
T1=1.2;     
unvoicep=zeros(1,length(c)+1);                  %���ڱ���ÿС�龲���ı�־
%%
%�ж�ÿ��С���������λ��Ƿ�������
loc1=find(Dvar(1:c(1))<T1 );                    %�жϵ�һ��С���Ƿ��������Σ�������򱣴������ε�λ��
if length(loc1)>round((c(1))/2) 
   unvoicep(1)=100;
end
for i=1:length(c)-1                             %�жϵڶ���С�鵽�����ڶ���С���Ƿ�Ϊ�����Σ�������򱣴������ε�λ��
    loc1=find(Dvar(c(i)+1:c(i+1))<T1);
    if length(loc1)>round((c(i+1)-c(i))/2) 
        unvoicep(i+1)=100;
    end
end
loc1=find(Dvar(c(i+1)+1:fn)<T1 );               %�ж����һ��С���Ƿ��������Σ�������򱣴������ε�λ��
if length(loc1)>round((fn-c(i+1))/2) 
    unvoicep(i+2)=100;
end
end

