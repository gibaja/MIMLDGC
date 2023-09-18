function distance=max_pdist_Hausdorff(Bag1,Bag2, distance)
    
    dist = pdist2(Bag1, Bag2, distance);     
    
    dist1=max(min(dist));
    dist2=max(min(dist'));
    distance=max(dist1,dist2);

        
    