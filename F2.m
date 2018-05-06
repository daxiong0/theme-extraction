function [truepit,frameTime] = F2( x1,fs )
%���Ƶ
% xΪ������Ƶ��truepitΪ��Ƶ
%����DIS�з֣��ٶ�һ����Ƶ��PEFAC��ȡ�������ѡֵ������ѡ��Ƶ�н���Ƶ����С��ĳһ��ֵ��ɾȥ��
candidate=3;                                       %��ѡ��Ƶ������
%%
%Ԥ�����һ����Ԥ���أ���֡��������ͼ
xx=x1-mean(x1);
x=xx/max(abs(xx));                      %��һ���ź�

%��֡
wlen=320;                               % ����֡��Ϊ40ms
win=hamming(wlen);                      % ���ô�����
inc=160;                                % ��֡��
y=enframe(x,win,inc)';                  % ��֡
fn=size(y,2);                           % ��֡��
frameTime=(((1:fn)-1)*inc+wlen/2)/fs;   % ����ÿ֡��Ӧ��ʱ��
%������ͼ
NFFT=8000;
W2=NFFT/2+1;
n2=2:W2;
freq=(n2-1)*fs/NFFT;                    % ����FFT���Ƶ�ʿ̶�
Y=fft(y,NFFT);
Y=abs(Y(n2, : ));                       %ȡ1-4000hz֮�ڵ�Ƶ�ʵ�
%%
%��ͼ
figure(1)
colormap(1-gray);
imagesc(frameTime,freq,Y);
axis xy; ylabel('Ƶ��/Hz');xlabel('ʱ��/s');
title('����ͼ');
grid on;
%%
%Ƶ���зֵõ��ֶε�λ��
dis=spectrum_dis(y,fs);
for i=1:length(dis)
    figure(1)
    line([frameTime(dis(i)),frameTime(dis(i))],[1,4000],'linewidth',1,'color','r','LineStyle','--');
    hold on;
end
%%
%������������μ��
[unvoicep]=unvoice_detect1(y,fn,dis);
figure(1)
plot(frameTime(1:dis(1)),repmat(unvoicep(1),1,dis(1)));
for i=1:length(dis)-1
    plot(frameTime(dis(i)+1:dis(i+1)),repmat(unvoicep(i+1),1,dis(i+1)-dis(i)));
end

%%
num=1600;                                   %��״�˲�������
%========================================��һ֡�ź�ת���ɶ��������ȵ��ź�
interval=log(21)/(num-1);                   %���趨�任֮���������
loginterval=exp(interval);                  %����Ƶ�ʼ��ת����Ƶ�ʼ��
for i=1:fn                                  %���ź����³���
    l=1;
    resample(1,i)=Y(l,i);
    for j=2:1000000                         %1000Ҫ����l>4000ʱ��ѭ������
        l=l*loginterval;                    %��ӦƵ�ʵ�λ��
        if(l>NFFT/2)
            break;
        end
        pre=floor(l);
        next=ceil(l);
        resample(j,i)=(Y(pre,i)+Y(next,i))/2;           %����������������ȡ��ֵ
    end
end

%%
%��������˲���
[h,predot ,q] = shuchilvboqi2( interval,num );
%%
%������˲�����ͼ
% figure(2)
% plot(exp(q),h);
% title('ѵ���õľ�������˲���');
% xlabel('��ĸ���');
% ylabel('����');
%%
%���Ƶ��ȡhoupit
%========================ʹ�þ�����Ƶ
h2=fliplr(h);                                       %��˳�����

houpit=zeros(candidate,fn);                         %���ڱ������ĺ�ѡ����
houval=zeros(candidate,fn);
% pit3=cell(1,fn);                                  %���ڱ���ÿ֡ȥ�걶Ƶ֮���Ƶ��
% val3=cell(1,fn);
cor=floor(log(1000)/interval);                      %1hz--1000hz֮���Ӧ������ĵ���
freq1=exp([1:cor].*interval);                       %ת��֮��Ķ���Ƶ������
predominance=zeros(cor,fn);                         %���ڱ���������pefac������
TT1=0;                                              %��������ֵ(ȡ��ֵ������)

for i=1:fn
    y=conv(h2,resample( : ,i));                     %����
    y1=y(num-predot:end);
    predominance( : ,i)=y1(1:cor);                  %1hz-1000hz��������
    [loc2,val]=findpeaks(predominance( : ,i));      %�����ҳ�1hz-1000hz�����еķ�ֵ
    pit=round(exp((loc2).*interval));               %ת���ɶ�Ӧ��ʵ��Ƶ��(ȡ��),loc2���Լ�1��Ҳ���Բ���1
    pit1=pit(pit>=70);                              %�ҳ��ڡ�70HZ��Ƶ��
    val1=val(pit>=70);
    %������һ���൱�ڸı�TT1
    val1=val1+400;
    pit12=pit1(val1>TT1);                           %�ҳ�valֵ������ֵ������TT1��Ƶ��
    val12=val1(val1>TT1);
    %��Ƶ�׵ķ���ɾȥƵ�׹�С��ֵ
    if ~isempty(pit12)                              %�ж��Ƿ�ǿ�
        [pit3,l]=f1(pit12,Y(:,i));                  %�����е������ȷ�ֵ��Ӧ��Ƶ�����ҳ���Ƶ���д���ĳһ��ֵ��Ƶ��
        val3=val12(l);
    else
        pit3=[];
        val3=[];
    end
    if ~isempty(pit3)
        %�Ȱ��������ȴ�С����
        [val2,loc1]=sort(val3,'descend');
        pit2=pit3(loc1);
        %--------------------------------------------------------------------------------
        con1=1;                                         %�������Ʊ������ݵ�λ��
        houpit(con1,i)=pit2(1);
        houval(con1,i)=val2(1);
        for j=2:length(pit2)                            %����Ƶ��ɱ�Ƶ��Ƶ��ϵ�ķ�ֵȥ��
            flag=0;
            for k=1:con1
                if abs((pit2(j)-houpit(k,i))/houpit(k,i))<0.029
                    flag=1;
                    break;
                end
            end
            
            if flag==0
                con1=con1+1;
                houpit(con1,i)=pit2(j);
                houval(con1,i)=val2(j);
            end
            if con1>=candidate
                break;
            end
        end
        %----------------------------------------------------------------------------
    end
end
% figure(4)
% plot(freq1,predominance( : ,fn1));
% axis xy;
% xlabel('Ƶ��/hz');
% ylabel('������');
% title([num2str(fn1),'֡,1-1000hz��PEFAC����ͼ']);
% grid on;
%%
%��������candidate,houpit,houval,dis
if unvoicep(1)~=100
    houcontour{1}=searchmelody1(houpit(:,1:dis(1)),houval(:,1:dis(1)));
    truepit=nntestcontour(houcontour{1}(1,:),Y(:,1:dis(1)));
    % truepit=houcontour{1}(1,:);
    %���ڶ���������ģ���б�ͳ�Ƹö��Ƿ�Ϊ����������
    
else
    houcontour{1}=[];
    truepit=zeros(1,dis(1));
end
for i=1:length(dis)-1
    if unvoicep(i+1)~=100
        houcontour{i+1}=searchmelody1(houpit(:,dis(i)+1:dis(i+1)),houval(:,dis(i)+1:dis(i+1)));
        truepit=[truepit nntestcontour(houcontour{i+1}(1,:),Y(:,dis(i)+1:dis(i+1)))];
        %         truepit=[truepit houcontour{i+1}(1,:)];
        %���ڶ���������ģ���б�ͳ�Ƹö��Ƿ�Ϊ����������
        
    else
        houcontour{i+1}=[];
        truepit=[truepit zeros(1,dis(i+1)-dis(i))];
    end
end
if unvoicep(i+2)~=100
    houcontour{i+2}=searchmelody1(houpit(:,dis(i+1)+1:fn),houval(:,dis(i+1)+1:fn));
    truepit=[truepit nntestcontour(houcontour{i+2}(1,:),Y(:,dis(i+1)+1:fn))];
    %     truepit=[truepit houcontour{i+2}(1,:)];
    %���ڶ���������ģ���б�ͳ�Ƹö��Ƿ�Ϊ����������
    
else
    houcontour{i+2}=[];
    truepit=[truepit zeros(1,fn-dis(i+1))];
end

end

