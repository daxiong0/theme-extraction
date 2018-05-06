function ccc=mfcc_gai(x,fs,p,frameSize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��������������е�Ƶ��x����MFCC��������ȡ������MFCC������һ��
%���MFCC������Mel�˲����ĸ���Ϊp������Ƶ��Ϊfs
%��xÿframeSize���Ϊһ֡��������֮֡���֡��Ϊinc
% ��ȡMel�˲����������ú���������
bank=melbankm(p,frameSize,fs,0,0.5,'m');
% ��һ��Mel�˲�����ϵ��
bank=full(bank);
bank=bank/max(bank(:));
bank=bank(:,2:4001);
p2=p/2;
% DCTϵ��,12*p
for k=1:p2
    n=0:p-1;
    dctcoef(k,:)=cos((2*n+1)*k*pi/(2*p));
end

% ��һ��������������
w = 1 + 6 * sin(pi * [1:p2] ./ p2);
w = w/max(w);

% ����ÿ֡��MFCC����
for i=1:size(x,2)
    t = x(:,i);
    t = t.^2;
    cc=bank * t;                     %ÿһ��MEL�˲�����Ƶ������ۼ�
    c1=dctcoef * log(cc+0.0001);
    c2 = c1.*w';
    m(i,:)=c2';
end

%���ϵ��
%dtm = zeros(size(m));
%for i=3:size(m,1)-2
% dtm(i,:) = -2*m(i-2,:) - m(i-1,:) + m(i+1,:) + 2*m(i+2,:);
%end
%dtm = dtm / 3;
%�ϲ�MFCC������һ�ײ��MFCC����
ccc = m;
%ȥ����β��֡����Ϊ����֡��һ�ײ�ֲ���Ϊ0
%ccc = ccc(3:size(m,1)-2,:);