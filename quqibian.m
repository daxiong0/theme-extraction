%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p,q]=quqibian(qibiazhi,P,Q)
%���ܣ�ȥ������С��qibiazhi֡���зֵ�
%���룺qibiazhiΪ�зֵ�֮�����С���룬PΪÿ���зֵ��Ӧ��disֵ��QΪÿ���зֵ��λ��
%�����pΪ�������зֵ��disֵ��qΪ�������зֵ��λ��
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
%������0ֵ��Ӧ���зֵ�ȥ��
k=1;
for b=1:length(Q)
    if Q(b)>0
        q(k)=Q(b);
        p(k)=P(b);
        k=k+1;
    end
end