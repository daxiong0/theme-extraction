%��PEFAC����ȡ��Ƶ�����ǽ���Ƶ�Ͱ�Ƶɾȥ
%�����б�������
%������ȷ�Ļ�Ƶ��ǩ���Աȣ��õ���Ƶ��ȡ�����ɶ�λ��ȫ�ʡ����ɶ�λ�龯�ʡ�ԭʼ����׼ȷ�ʡ�ԭʼɫ��׼ȷ�ʺ�����׼ȷ��
clear all;clc;close all;
load wav65.mat
load label65.mat

fs=8000;

s=0;                    %ͳ����֡��
s1=0;                   %ͳ���㷨��ȷ��֡��
s3=0;                   %ͳ���㷨������ȷ������֡����
s4=0;                   %ͳ�ƻ�׼������ȫ�������Ϊ���ɵ�֡������
s5=0;                   %ͳ���㷨����ع���Ϊ���ɵ�֡����
s6=0;                   %ͳ�ƻ�׼�����б����Ϊ�����ɵ�֡����
s7=0;                   %�ڻ�׼���ݵ�����֡�У��㷨��ȷ�������ߣ�����������׼���ߵĲ���ڰ������֮�ڣ���֡
s8=0;                   %�ڻ�׼���ݵ�����֡�У��㷨��ȷ�������ߣ����԰˶ȴ��󣩵�֡

for k=1:10
    pplabel=label65{k};    
    wavdata{k}=resample(wav65{k},1,1);                      %�����������ֱ����²���
    x=wavdata{k}(:,1)+wavdata{k}(:,2);                      %1�����ǰ��࣬2��������
    s2=0;                                                   %���ڱ���ÿ�׸�����ȷ��Ƶ������    
    %��PEFAC��+������ģ����ȡ������
    [pit{k},frameTime] = F2(x,fs);
    %������ȷ�Ļ�Ƶ��ǩ���Աȣ������㷨��׼ȷ��
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
vcc=s3/s4;              %���ɶ�λ��ȫ��
vfar=s5/s6;             %���ɶ�λ�龯��
rpa=s7/s4;              %ԭʼ����׼ȷ��(ʼ��С�����ɶ�λ��ȫ��)
rca=s8/s4;              %ԭʼɫ��׼ȷ�ʣ�raw chroma accuracy����Ӧ�ø���ԭʼ����׼ȷ�ʣ�
oa=s1/s;                %����׼ȷ��