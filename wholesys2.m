%用PEFAC法提取基频，考虑将倍频和半频删去
%加入判别神经网络
%并与正确的基频标签做对比，得到基频提取的旋律定位查全率、旋律定位虚警率、原始音高准确率、原始色度准确率和总体准确率
clear all;clc;close all;
load wav65.mat
load label65.mat

fs=8000;

s=0;                    %统计总帧数
s1=0;                   %统计算法正确的帧数
s3=0;                   %统计算法估计正确的旋律帧数量
s4=0;                   %统计基准数据中全部被标记为旋律的帧数量。
s5=0;                   %统计算法错误地估计为旋律的帧数量
s6=0;                   %统计基准数据中被标记为非旋律的帧数量
s7=0;                   %在基准数据的旋律帧中，算法正确估计音高（检测音高与基准音高的差别在半个半音之内）的帧
s8=0;                   %在基准数据的旋律帧中，算法正确估计音高（忽略八度错误）的帧

for k=1:10
    pplabel=label65{k};    
    wavdata{k}=resample(wav65{k},1,1);                      %将两个声道分别重新采样
    x=wavdata{k}(:,1)+wavdata{k}(:,2);                      %1声道是伴奏，2声道歌声
    s2=0;                                                   %用于保存每首歌曲正确基频的数量    
    %用PEFAC法+神经网络模型提取旋律线
    [pit{k},frameTime] = F2(x,fs);
    %并与正确的基频标签做对比，计算算法的准确率
    fn=length(pit{k});
    l1=find(pplabel~=0);
    s=s+fn;
    s4=s4+length(l1);
    
    for i=1:fn
        if pit{k}(i)==0&&pplabel(i)==0
            s1=s1+1;
            s2=s2+1;
        end
        if pit{k}(i)~=0&&pplabel(i)~=0
            s3=s3+1;
            if abs(pplabel(i)-pit{k}(i))/pplabel(i)<0.0285
                s1=s1+1;
                s2=s2+1;
                s7=s7+1;
            end
            if pplabel(i)<=pit{k}(i)
                if abs(pit{k}(i)/pplabel(i)-round(pit{k}(i)/pplabel(i)))<0.0285*round(pit{k}(i)/pplabel(i))
                    s8=s8+1;
                end
            else
                 if abs(pplabel(i)/pit{k}(i)-round(pplabel(i)/pit{k}(i)))<0.0285*round(pplabel(i)/pit{k}(i))*1.0285
                     s8=s8+1;
                 end
            end
            
        end
        if pplabel(i)==0&&pit{k}(i)~=0
            s5=s5+1;
        end
    end
    k
    allaccur(k)=s1 / s;
    eachaccur(k)=s2/fn;
    figure(1)
    plot(frameTime,pplabel,'r*');
    hold on;
    plot(frameTime,pit{k},'k+');
    hold off;
end
s6=s-s4;
vcc=s3/s4;              %旋律定位查全率
vfar=s5/s6;             %旋律定位虚警率
rpa=s7/s4;              %原始音高准确率(始终小于旋律定位查全率)
rca=s8/s4;              %原始色度准确率（raw chroma accuracy）（应该高于原始音高准确率）
oa=s1/s;                %整体准确率