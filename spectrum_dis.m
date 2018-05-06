function [ q ] = spectrum_dis(x,fs)
%输出为切分点的位置（帧数）
% 频谱切分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=5; %t为帧数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 求DIS
 NFFT=800;                              %做傅里叶变换的点数
fn=size(x,2);                           % 帧数
W2=NFFT/2+1; n2=1:W2;
Y=fft(x,NFFT);                          % 短时傅里叶变换
xx=20*log10(abs(Y(n2,:)));
[yy,psy]=mapminmax(xx,0,1);             %对频谱每一维进行0-1的归一化
y1=yy';                                 %为了适应mean和std，求转置

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
    m1=mean(dis(dis~=0))-0.05;%门限大小
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    k=1;
    for j=2:fn-1
        if dis(j-1)<dis(j)&&dis(j)>dis(j+1)&&dis(j)>=m1
            p_1(k)=dis(j);                      %保存dis值
            q_1(k)=j;                           %保存对应的位置
            k=k+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    qibiazhi=5;%用于消除两个相邻太近的峰
    [p,q]=quqibian(qibiazhi,p_1,q_1);   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 画图
% figure(1)
% plot(time,x);
% xlim([0 max(time)]);
% ylim([-1 1]);
% xlabel('时间/s'); ylabel('幅值');
% title('语音信号波形');
% for b=1:length(m5)
%     line([m5(b),m5(b)],[-1,1],'linewidth',1,'color','r','LineStyle','-');
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(2)
% colormap(1-gray); 
% imagesc(frameTime,freq(1:NFFT/2),abs(Y(n2,:)));
% % xlim([0 max(frameTime)]);
% axis xy; ylabel('频率/Hz');xlabel('时间/s');
% title('语谱图');
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
% axis xy; ylabel('DIS');xlabel('时间');
% timu=['相邻',num2str(t),'帧的DIS的值'];
% title(timu);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

