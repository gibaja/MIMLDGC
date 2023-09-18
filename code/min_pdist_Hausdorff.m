function distance=min_pdist_Hausdorff(Bag1,Bag2, distance)

 dist = pdist2(Bag1, Bag2,  distance);       
    distance=min(min(dist));

        
    