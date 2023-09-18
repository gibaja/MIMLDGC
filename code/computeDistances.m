function [Dist] = computeDistances(bags, max_values, min_values, distance)
 
   if nargin <4            
      distance=3;
   end;   

   [num_bags, ~]=size(bags);       
   %disp('Computing distance...');
   
   Dist=zeros(num_bags,num_bags);
   for i=1:(num_bags-1)
        bag1 = bags{i,1};
        for j=(i+1):num_bags
            bag2 = bags{j,1};
                switch distance
                       case 1
                            Dist(i,j)=max_HEOM_Hausdorff(bag1, bag2, max_values, min_values);
                       case 2
                            Dist(i,j)=min_HEOM_Hausdorff(bag1, bag2, max_values, min_values); 
                       case 3
                            Dist(i,j)=ave_HEOM_Hausdorff(bag1, bag2, max_values, min_values);
                       case 4    
                            Dist(i,j)=ave_pdist_Hausdorff(bag1, bag2, 'cosine');
                end %switch                  
        end
    end
    Dist=Dist+Dist';