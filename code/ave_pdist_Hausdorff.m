function distance=ave_pdist_Hausdorff(Bag1,Bag2, distance)

    size1=size(Bag1);
    size2=size(Bag2);
    inst_bag1=size1(1);    
    inst_bag2=size2(1);
    
    dist = pdist2(Bag1, Bag2, distance);     
       
    distance=(sum(min(dist))+sum(min(dist')))/(inst_bag1+inst_bag2);  
