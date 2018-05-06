function [ contour] = viterbiSearchContour( x,y )
%用viterbi算法从前向后找出一段候选基频连成的所有旋律线
%  x为一段候选基音,y为对应的基频显著度，counter为viterbi算法搜索出来的旋律线
load deltaf0.mat                            %可以放到外层函数中去
fn=size(x,2);
%从第一帧开始到前一半的帧的候选基音是否有值，没有的帧全部保存为0，如果有，就保存，并且跳出
flag=0;
for d=1:round(2*fn/3)
    a=find(x(:,d));                         %找出第d帧非0元素的位置
    if ~isempty(a)
        contour=zeros(length(a),fn);        %最终旋律曲线的个数=第一列非0元素的个数
        contour(:,1:d)=repmat(x(a,d),1,d);     %是否需要将前面为0的值赋上值得斟酌
        break;
    end
    if d==round(2*fn/3)
        flag=1;
    end
end
if flag==1
    contour=[];
else
    %维特比算法跟踪
    for i=d+1:fn
        %先取出第i帧的候选基频及其显著值
        a1=find(x(:,i));              %找出第i帧非0元素的位置
        num=length(a1);
        houpit=x(a1,i);
        houval=y(a1,i);
        if num==0
            contour(:,i)=contour(:,i-1);
        else
            %分别跟踪contour条旋律线
            for j=1:length(a)
                %计算观察到的显著度概率
                p1=houval/sum(houval);      %值得斟酌
                %计算状态转移概率
                p2=0;
                b=round((houpit-contour(j,i-1))./contour(j,i-1)/0.002);
                for k=1:num
                    if b(k)<=200&&b(k)>=-200
                        p2(k)=deltaf0(201+b(k));
                    else
                        p2(k)=0;
                    end
                end
                %计算候选基频的概率
                p=p1'.*p2;
                [e,c]=max(p);            %找到概率最大的候选基频
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

