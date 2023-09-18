function [Outputs,Pre_Labels,te_time]=MIMLDGC_test(train_bags,train_targets,test_bags,num_neighbours, NGC, max_values, min_values, distance, extNeigh)

if nargin <8 
    distance = 3;  %AveHEOMHaussdorf
end

if nargin <9 
    extNeigh = false;      
end

start_time=cputime;

[num_labels, num_train]=size(train_targets);
num_test = size(test_bags, 1);
Pre_Labels = zeros(num_labels,num_test);
Outputs = zeros(num_labels, num_test);

%updates max_values and min_values
[max_values, min_values] = computeStats(test_bags, max_values, min_values);

%for each test bag
for i=1:num_test
   %computes the distances of ith test bag to each to each training bag
    Dist=zeros(1,num_train);
    bag1 = test_bags{i,1};
    for j=1:num_train  
        bag2 = train_bags{j,1};
        switch distance
           case 1
                Dist(1,j)=max_HEOM_Hausdorff(bag1,bag2, max_values, min_values);
           case 2
                Dist(1,j)=min_HEOM_Hausdorff(bag1,bag2, max_values, min_values); 
           case 3
                Dist(1,j)=ave_HEOM_Hausdorff(bag1,bag2, max_values, min_values);
           case 4
                Dist(1,j)=ave_pdist_Hausdorff(bag1,bag2, 'cosine');           
        end %switch
    end
    
    %computes the knearest neighbors    
    [sorted_dist,ref_index]=sort(Dist,'ascend');    

    %all instances with the same distance are included in the
    %neighborhood
    k=num_neighbours;
    if(extNeigh)
       while (sorted_dist(k) == sorted_dist(k+1)) && ((k+1) < size(sorted_dist, 2))    
           k=k+1;          
       end
    end
    
    %computes gforce of each neighbor
    gforce = zeros(1, k);
    %nAttr = size(max_values,1);
    for n=1:k
        index = ref_index(n);
        distance = sorted_dist(n);
        gforce(n) = NGC(index)/(distance^2);       
    end %for n
    
    bipartition = zeros(num_labels, 1); 
    confidence = zeros(num_labels, 1);     
    
    for l=1:num_labels
        positiveGF = 0.0;
        negativeGF = 0.0;
        
        % computes positiveGF and negativeGF
        for n=1:k
           index = ref_index(n);
           if train_targets(l, index) == 1
               positiveGF = positiveGF + gforce(n);
           else
               negativeGF = negativeGF + gforce(n); 
           end    
        end% for n      
        
        % computes bipartition and confidence        
        if positiveGF > negativeGF
		   bipartition(l) = 1; % label is relevant
        else
		   bipartition(l) = -1; %label is not relevant
        end
        
        confidence(l) = positiveGF / (positiveGF + negativeGF);          
    end %for l
    
    Pre_Labels(:, i) = bipartition';
    Outputs(:, i) = confidence';    
    
end % for i

te_time=cputime-start_time;
end % function