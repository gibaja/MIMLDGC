function [tr_time, NGC, max_values, min_values]=MIMLDGC_train(train_bags, train_target, num_neighbours, distance, extNeigh)
    
if nargin <4 
    distance = 3;  %AveHaussdorf
end

if nargin <5 
    extNeigh = false;  
end


start_time=cputime;
   
   [num_labels, num_train]=size(train_target);      
   weight_max = realmin;
   weight_min = realmax;

   %Computes max and min values for all attributes to normalize distance
   %mesauring
   [max_values, min_values] = computeStats(train_bags);   
   
   %the neighbors for the i-th bag are stored in sorted_index{i,1} in from nearest to furtherest
   Dist = computeDistances(train_bags, max_values, min_values, distance); 
   sorted_index=cell(num_train,1);
   for i=1:num_train
        dist_row=Dist(i,:);
        %differentiates 0 distance and distante to the current instance
        %with itself (-1)
        dist_row(1,i)=-1;
        %the first element of sorted_dist_row has -1 value
        [sorted_dist_row,ref_index]=sort(dist_row,'ascend');
        sorted_index{i,1}=ref_index(2:num_train);
   end  

   
  %Neighborhood-based Gravitation Coefficient for each training example
  NGC = zeros(num_train, 1); 
   
  %Densities
  densities=zeros(num_train, 1);
  
  %Weights
  weights= ones(num_train, 1); 
  
  
  for i=1:num_train
       
       %all instances with the same dinstance are included in the
       %neighborhood
       k=num_neighbours;
       if (extNeigh)
          while (Dist(i, sorted_index{i, 1}(k)) == Dist(i, sorted_index{i, 1}(k+1))) && ((k+1) < size(sorted_index{i, 1}, 2)) 
              k=k+1;
          end
       end       
      
       %gets the indexes of the k neighbours of instance i      
       ref_index=sorted_index{i,1}(1:k);       
       
       %computes weight and density       
       weights(i)=1;
       densities(i)=0;
       
       PdisY = 0;
       PdisF = 0;
       PdisY_disF = 0; 
      
      
       for j=1:k 
          index = ref_index(j);
          df = Dist(i, index);                    
          
          %retuns HLoss and adjustedHLoss
          [dl, adl] = labelDistance(train_target(:, i),train_target(:, index));          
          
          %original computing of densities
          densities(i) = densities(i) + ((1 - dl) / df);       
          
          PdisY = PdisY + dl;
	      PdisF = PdisF + df;
	      PdisY_disF = PdisY_disF + (dl * df);
       end
       
       %compute density
	   densities(i) = 1 + densities(i);
        
       %compute weight
	   PdisY = PdisY / k;
	   PdisF = PdisF / k;
	   PdisY_disF = PdisY_disF / k;
       if (PdisY == 0) || (PdisY == 1)
             weights(i) = 0; 
       else
             weights(i) = ((PdisY_disF * PdisF) / PdisY) - (((1 - PdisY_disF) * PdisF) / (1 - PdisY));
       end       
       
       if weight_max < weights(i)
			weight_max = weights(i);
       end
       
       if (weight_min > weights(i))
		    weight_min = weights(i);
       end       
   end%for i
    
   %Normalize weights and compute NGC
   for i=1:num_train 
      weights(i) = weights(i)/(weight_max-weight_min);
      NGC(i) = densities(i)^weights(i);
   end 
   
tr_time=cputime-start_time;