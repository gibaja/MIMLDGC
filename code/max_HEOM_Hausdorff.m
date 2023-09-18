function distance=max_HEOM_Hausdorff(Bag1,Bag2, min_values, max_values)
% maxHausdorff  Compute the maximum Hausdorff distance between two bags Bag1 and Bag2
% maxHausdorff takes,
%   Bag1 - one bag of instances
%   Bag2 - the other bag of instances
% and returns,
%   distance - the maximum Hausdorff distance between Bag1 and Bag2

    
    dist = HEOM(Bag1, Bag2, min_values, max_values); 
    
    dist1=max(min(dist));
    dist2=max(min(dist'));
    distance=max(dist1,dist2);

        
    