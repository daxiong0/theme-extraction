function [ contour22 ] = remove_same( contour1,contour2 )
%��contour2������ȥ����contour1��������ͬ����
%   �˴���ʾ��ϸ˵��
contour22=[];
m=1;
   for i=1:size(contour2,1)
            flag=0;
       for j=1:size(contour1,1)
           if contour2(i,:)==contour1(j,:)
               flag=1;
               break;
           end
       end
       if flag==0
           contour22(m,:)=contour2(i,:);
           m=m+1;
       end
   end
 

end

