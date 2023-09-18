function distance=ave_HEOM_Hausdorff(Bag1,Bag2, max_values, min_values)
% aveHausdorff compute the average Hausdorff distance between two bags Bag1 and Bag2 as defined in [1]
% aveHausdorff takes,
%   Bag1 - one bag of instances
%   Bag2 - the other bag of instances
% and returns,
%   distance - the average Hausdorff distance between Bag1 and Bag2
%
%[1] M.-L. Zhang and Z.-H. Zhou. Multi-instance clustering with applications to multi-instance prediction. Applied Intelligence, in press.

    size1=size(Bag1);
    size2=size(Bag2);
    inst_bag1=size1(1);    
    inst_bag2=size2(1);
    
    dist = HEOM(Bag1, Bag2, min_values, max_values);     
       
    distance=(sum(min(dist))+sum(min(dist')))/(inst_bag1+inst_bag2);  
