%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p,q]=quqibian(qibiazhi,P,Q)
%功能：去除距离小于qibiazhi帧的切分点
%输入：qibiazhi为切分点之间的最小距离，P为每个切分点对应的dis值，Q为每个切分点的位置
%输出：p为保留的切分点的dis值，q为保留的切分点的位置
for a=2:length(Q)
    if abs(Q(a)-Q(a-1))<=qibiazhi
        if P(a)>=P(a-1)
            P(a)=P(a);
            Q(a)=Q(a);
            P(a-1)=0;
            Q(a-1)=0;
        else
            P(a)=P(a-1);
            Q(a)=Q(a-1); 
            P(a-1)=0;
            Q(a-1)=0;
        end
    end
end
%将其中0值对应的切分点去除
k=1;
for b=1:length(Q)
    if Q(b)>0
        q(k)=Q(b);
        p(k)=P(b);
        k=k+1;
    end
end