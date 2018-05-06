function [contour5 ] = searchmelody( x,y )
%���ܣ����Ϊ������������������
% ���룺�öεĺ�ѡ��Ƶ�ͺ�ѡ��Ƶ��Ӧ��ֵ

fn=size(x,2);
%��ǰ�����ҵ�������������
contour1=viterbiSearchContour(x,y);
%�Ӻ���ǰ�ҵ�������������
x1=fliplr(x);
y1=fliplr(y);
contour2=viterbiSearchContour(x1,y1);
contour2=fliplr(contour2);                  
%���м��������ҵ�������������
fn1=ceil(fn/2);
xs=x(:,1:fn1);                              %ǰ�벿��
ys=y(:,1:fn1);
xx=x(:,fn1:end);                            %��벿��
yx=y(:,fn1:end);
%����ǰ�벿��
xs=fliplr(xs);
ys=fliplr(ys);
contour31=viterbiSearchContour(xs,ys);
contour31=fliplr(contour31);                %�ϰ벿�ֵ�������������

contour32=viterbiSearchContour(xx,yx);      %�°벿�����е���������
[p,~,val]=find(x(:,fn1));
c=1;
contour3=[];                                %������м��������ҵ�����������
for i=1:length(p)
    p1=find(contour31(:,fn1)==val(i));
    p2=find(contour32(:,1)==val(i));    
    for j=1:length(p1)
        for k=1:length(p2)
            contour3(c,:)=[contour31(p1(j),:) contour32(p2(k),2:end)];
            c=c+1;
        end
    end
end
%ȥ��3����������ȫ��ͬ����������
contour22=remove_same(contour1,contour2);
contour33=remove_same(contour1,contour3);
contour34=remove_same(contour2,contour33);
contour=[contour1;contour22;contour34];

%%
%�����������ߵ�����ֵ
kuan1=size(contour,1);
pre=zeros(kuan1,1);
for i=1:kuan1
    
    for j=1:fn
        if contour(i,j)==0
            pre(i)=pre(i)+0;
        else
            p1=find(x(:,j)==contour(i,j));
            if isempty(p1)
                pre(i)=pre(i)+0;
            else
                pre(i)=pre(i)+y(p1(1),j);
            end
        end
    end
end
[~,loc1]=sort(pre,'descend');               %�������ȺʹӸߵ�������
contour4=contour(loc1,:);                   %�����е��������߰������ȴӸߵ�������
%����һ���Ĺ�������ֻ����������candidate�κ�ѡ����
candidate=1;
if kuan1<=candidate
    contour5=contour4;
else    
    con1=1;
    con2=1;
    contour5(con1,:)=contour4(con2,:);      %�����������ĸ�����һ��
    while con1<candidate&&con2<kuan1
        flag=1;
        con2=con2+1;
        
        for j=1:con1
            s=0;
            for k=1:fn
                if contour4(con2,k)~=contour5(j,k)
                    s=s+1;
                end
            end
            if fn>=12
                if s<5                          %������Ѵ��ڵĺ�ѡ������5�����²�ͬ�ľ�ɾȥ
                    flag=0;
                    break;
                end
            else
                if s<round(fn/3)                %������Ѵ��ڵĺ�ѡ������fn/3�����²�ͬ�ľ�ɾȥ
                    flag=0;
                    break;
                end
            end
        end
        if flag==1
            con1=con1+1;
            contour5(con1,:)=contour4(con2,:);
        end
        
    end
end
if isempty(contour5)
    contour5=zeros(1,fn);
end
end

