function [EBPrecision, EBRecall, EBFMeasure, EBAccuracy, EBSpecificity, SubsetAccuracy]=EB_Measures(Pre_Labels,test_target)
%Computing EB measures
%Pre_Labels: the predicted labels of the classifier, if the ith instance belong to the jth class, Pre_Labels(j,i)=1, otherwise Pre_Labels(j,i)=-1
%test_target: the actual labels of the test instances, if the ith instance belong to the jth class, test_target(j,i)=1, otherwise test_target(j,i)=-1

   [num_labels,num_instances]=size(Pre_Labels);

    EBPrecision = 0;
    EBRecall = 0;
    EBFMeasure  =0;
    EBAccuracy =0; 
    EBSpecificity = 0;
    SubsetAccuracy = 0;
    for j=1:num_instances           
            P = 0;
            Y = 0;
            Union = 0;
            Inter = 0;
            exactMatch = 1;            
            notY = 0;
            notInter = 0;
        for i=1:num_labels
           if (Pre_Labels(i,j)==1)
               P=P+1;    
           end   
           if (test_target(i,j)==1)
               Y=Y+1;
           else
               notY =notY+1;
           end   
           
           if (Pre_Labels(i,j)==1) || (test_target(i,j)==1)
               Union=Union+1;
           end
           
           if (Pre_Labels(i,j)==1) && (test_target(i,j)==1)
               Inter=Inter+1;
           end 
           
           if (Pre_Labels(i,j)==-1) && (test_target(i,j)==-1)
               notInter=notInter+1;
           end 
           
           if(Pre_Labels(i,j)~=test_target(i,j))
              exactMatch=0;
           end    
        end
        
        if P~=0
        EBPrecision = EBPrecision+(Inter/P);
        end
        if Y~=0
        EBRecall = EBRecall+(Inter/Y);
        end
        if (P+Y)~=0
        EBFMeasure = EBFMeasure+(2*Inter)/(P+Y);
        end
        if Union~=0
        EBAccuracy = EBAccuracy+(Inter/Union); 
        end
        SubsetAccuracy = SubsetAccuracy + exactMatch; 
        if notY~=0
        EBSpecificity = EBSpecificity+(notInter/notY);
        end    
    end
    
    EBPrecision = EBPrecision/num_instances;
    EBRecall = EBRecall/num_instances;
    EBFMeasure = EBFMeasure/num_instances;
    EBAccuracy = EBAccuracy/num_instances;
    SubsetAccuracy = SubsetAccuracy/num_instances;
    EBSpecificity = EBSpecificity/num_instances;
    
    
    