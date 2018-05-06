function [contour5 ] = searchmelody( x,y )
%功能：输出为几条最显著的旋律线
% 输入：该段的候选基频和候选基频对应的值

fn=size(x,2);
%从前往后找的所有旋律曲线
contour1=viterbiSearchContour(x,y);
%从后往前找的所有旋律曲线
x1=fliplr(x);
y1=fliplr(y);
contour2=viterbiSearchContour(x1,y1);
contour2=fliplr(contour2);                  
%从中间往两边找的所有旋律曲线
fn1=ceil(fn/2);
xs=x(:,1:fn1);                              %前半部分
ys=y(:,1:fn1);
xx=x(:,fn1:end);                            %后半部分
yx=y(:,fn1:end);
%先找前半部分
xs=fliplr(xs);
ys=fliplr(ys);
contour31=viterbiSearchContour(xs,ys);
contour31=fliplr(contour31);                %上半部分的所有旋律曲线

contour32=viterbiSearchContour(xx,yx);      %下半部分所有的旋律曲线
[p,~,val]=find(x(:,fn1));
c=1;
contour3=[];                                %保存从中间向两边找的所有旋律线
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
%去除3个矩阵中完全相同的旋律曲线
contour22=remove_same(contour1,contour2);
contour33=remove_same(contour1,contour3);
contour34=remove_same(contour2,contour33);
contour=[contour1;contour22;contour34];

%%
%计算所有曲线的显著值
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
[~,loc1]=sort(pre,'descend');               %将显著度和从高到低排序
contour4=contour(loc1,:);                   %将所有的旋律曲线按显著度从高到低排序
%按照一定的规则，最终只保留不超过candidate段候选旋律
candidate=1;
if kuan1<=candidate
    contour5=contour4;
else    
    con1=1;
    con2=1;
    contour5(con1,:)=contour4(con2,:);      %将显著度最大的赋给第一行
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
                if s<5                          %如果与已存在的候选旋律有5个以下不同的就删去
                    flag=0;
                    break;
                end
            else
                if s<round(fn/3)                %如果与已存在的候选旋律有fn/3个以下不同的就删去
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

