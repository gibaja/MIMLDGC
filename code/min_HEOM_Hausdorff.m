function distance=min_HEOM_Hausdorff(Bag1,Bag2, min_values, max_values)
% minHausdorff  Compute the minimum Hausdorff distance between two bags Bag1 and Bag2
% minHausdorff takes,
%   Bag1 - one bag of instances
%   Bag2 - the other bag of instanes
% and returns,
%   distance - the minimum Hausdorff distance between Bag1 and Bag2

    dist = HEOM(Bag1, Bag2, min_values, max_values);    
    distance=min(min(dist));

        
    