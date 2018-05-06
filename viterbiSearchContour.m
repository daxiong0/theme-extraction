function [ contour] = viterbiSearchContour( x,y )
%��viterbi�㷨��ǰ����ҳ�һ�κ�ѡ��Ƶ���ɵ�����������
%  xΪһ�κ�ѡ����,yΪ��Ӧ�Ļ�Ƶ�����ȣ�counterΪviterbi�㷨����������������
load deltaf0.mat                            %���Էŵ���㺯����ȥ
fn=size(x,2);
%�ӵ�һ֡��ʼ��ǰһ���֡�ĺ�ѡ�����Ƿ���ֵ��û�е�֡ȫ������Ϊ0������У��ͱ��棬��������
flag=0;
for d=1:round(2*fn/3)
    a=find(x(:,d));                         %�ҳ���d֡��0Ԫ�ص�λ��
    if ~isempty(a)
        contour=zeros(length(a),fn);        %�����������ߵĸ���=��һ�з�0Ԫ�صĸ���
        contour(:,1:d)=repmat(x(a,d),1,d);     %�Ƿ���Ҫ��ǰ��Ϊ0��ֵ����ֵ������
        break;
    end
    if d==round(2*fn/3)
        flag=1;
    end
end
if flag==1
    contour=[];
else
    %ά�ر��㷨����
    for i=d+1:fn
        %��ȡ����i֡�ĺ�ѡ��Ƶ��������ֵ
        a1=find(x(:,i));              %�ҳ���i֡��0Ԫ�ص�λ��
        num=length(a1);
        houpit=x(a1,i);
        houval=y(a1,i);
        if num==0
            contour(:,i)=contour(:,i-1);
        else
            %�ֱ����contour��������
            for j=1:length(a)
                %����۲쵽�������ȸ���
                p1=houval/sum(houval);      %ֵ������
                %����״̬ת�Ƹ���
                p2=0;
                b=round((houpit-contour(j,i-1))./contour(j,i-1)/0.002);
                for k=1:num
                    if b(k)<=200&&b(k)>=-200
                        p2(k)=deltaf0(201+b(k));
                    else
                        p2(k)=0;
                    end
                end
                %�����ѡ��Ƶ�ĸ���
                p=p1'.*p2;
                [e,c]=max(p);            %�ҵ��������ĺ�ѡ��Ƶ
                if e>10^-7
                    contour(j,i)=houpit(c);
                else
                    contour(j,i)=contour(j,i-1);
                end
                
            end
        end
    end
end
end

