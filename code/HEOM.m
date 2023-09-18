%Returns matrix of  Bag1_numInstances x Bag2_numInstances where
%dist(i, j)= is the distance between instace i of Bag1 and instance j of Bag2.

function dist=HEOM(Bag1,Bag2, min_values, max_values)

    size1=size(Bag1);
    size2=size(Bag2);
    inst_bag1=size1(1);    
    inst_bag2=size2(1);
    num_attr = size1(2);
    dist=zeros(inst_bag1, inst_bag2);
    epsilon_near_zero = 1.0e-10;
    
    for i=1:inst_bag1
        for j=1:inst_bag2
            %EUCLIDEAN distance:           
            %dist(i,j)=sqrt(sum((Bag1(i,:)-Bag2(j,:)).^2));
            
            %Normalized HEOM distance
            sum = 0;             
            for k=1:num_attr                
               if abs(max_values(k)-min_values(k))>epsilon_near_zero                   
                   delta = abs(Bag1(i, k)-Bag2(j, k))/(max_values(k)-min_values(k));
                   sum = sum +(delta*delta);                   
               end
            end %for k     
            
            dist(i,j)=sqrt(sum);
        end
    end
end