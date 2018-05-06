function [ q ] = spectrum_dis(x,fs)
%���Ϊ�зֵ��λ�ã�֡����
% Ƶ���з�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=5; %tΪ֡��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��DIS
 NFFT=800;                              %������Ҷ�任�ĵ���
fn=size(x,2);                           % ֡��
W2=NFFT/2+1; n2=1:W2;
Y=fft(x,NFFT);                          % ��ʱ����Ҷ�任
xx=20*log10(abs(Y(n2,:)));
[yy,psy]=mapminmax(xx,0,1);             %��Ƶ��ÿһά����0-1�Ĺ�һ��
y1=yy';                                 %Ϊ����Ӧmean��std����ת��

if fn-2*t+1<1
    q(1)=1;
    q(2)=fn;
else
    for i=1:fn-2*t+1
        u1=mean(y1(i:i+t-1,:));
        u2=mean(y1(i+t:i+2*t-1,:));
        sigma1=std(y1(i:i+t-1,:));
        sigma2=std(y1(i+t:i+2*t-1,:));
        if sigma1*sigma1'+sigma2*sigma2'>0
            dis_1(i)=(u1-u2)*(u1-u2)'/(sigma1*sigma1'+sigma2*sigma2');
        else
            dis_1(i)=0;
        end
        
    end
    dis=zeros(1,fn);
    dis(:,t:fn-t)=dis_1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    m1=mean(dis(dis~=0))-0.05;%���޴�С
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    k=1;
    for j=2:fn-1
        if dis(j-1)<dis(j)&&dis(j)>dis(j+1)&&dis(j)>=m1
            p_1(k)=dis(j);                      %����disֵ
            q_1(k)=j;                           %�����Ӧ��λ��
            k=k+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    qibiazhi=5;%����������������̫���ķ�
    [p,q]=quqibian(qibiazhi,p_1,q_1);   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ��ͼ
% figure(1)
% plot(time,x);
% xlim([0 max(time)]);
% ylim([-1 1]);
% xlabel('ʱ��/s'); ylabel('��ֵ');
% title('�����źŲ���');
% for b=1:length(m5)
%     line([m5(b),m5(b)],[-1,1],'linewidth',1,'color','r','LineStyle','-');
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(2)
% colormap(1-gray); 
% imagesc(frameTime,freq(1:NFFT/2),abs(Y(n2,:)));
% % xlim([0 max(frameTime)]);
% axis xy; ylabel('Ƶ��/Hz');xlabel('ʱ��/s');
% title('����ͼ');
% grid on;
% for b=1:length(m5)
%     line([m5(b),m5(b)],[0,24000],'linewidth',1,'color','r','LineStyle','-');
% end
% hold on;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(3)
% plot(frameTime,dis);
% xlim([0 max(frameTime)]);
% ylim([0 max(dis)]);
% for b=1:length(m5)
%     line([m5(b),m5(b)],[0,max(dis)],'linewidth',1,'color','r','LineStyle','-');
% end
% line([0,max(frameTime)],[m1,m1],'linewidth',1,'color','r','LineStyle','-');
% axis xy; ylabel('DIS');xlabel('ʱ��');
% timu=['����',num2str(t),'֡��DIS��ֵ'];
% title(timu);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

