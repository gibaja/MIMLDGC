function [MacPrecision, MacRecall, MacFMeasure, MacAccuracy, MacSpecificity, MicPrecision, MicRecall, MicFMeasure, MicAccuracy, MicSpecificity]=LB_Measures(Pre_Labels,test_target)
%Computing EB measures
%Pre_Labels: the predicted labels of the classifier, if the ith instance belong to the jth class, Pre_Labels(j,i)=1, otherwise Pre_Labels(j,i)=-1
%test_target: the actual labels of the test instances, if the ith instance belong to the jth class, test_target(j,i)=1, otherwise test_target(j,i)=-1

    [num_labels,num_instances]=size(Pre_Labels);
    %(i, 1):TP_i, (i,2):TN_i (i, 3):FP_i (i,4):FN_i
    %the last row is the sum of TP, TN, FP, FN
    TP=1;TN=2;FP=3;FN=4;all=num_labels+1;
    contingencyTable=zeros(num_labels+1, 4);
    
    %Computes contingency tables for all labels
    for j=1:num_instances
        for label=1:num_labels            
            %True positive
            if (Pre_Labels(label, j)==1)&& (Pre_Labels(label, j)==test_target(label, j))
                contingencyTable(label, TP)=contingencyTable(label, TP)+1;
                contingencyTable(all, TP)=contingencyTable(all, TP)+1;
            end;
            %True negative
            if (Pre_Labels(label, j)==-1)&& (Pre_Labels(label, j)==test_target(label, j))
                contingencyTable(label, TN)=contingencyTable(label, TN)+1;
                contingencyTable(all, TN)=contingencyTable(all, TN)+1;      
            end;            
            %False positive            
            if (Pre_Labels(label, j)==1)&& (Pre_Labels(label, j)~=test_target(label, j))
                contingencyTable(label, FP)=contingencyTable(label, FP)+1;
                contingencyTable(all, FP)=contingencyTable(all, FP)+1;
            end;            
            %False negative
            if (Pre_Labels(label, j)==-1)&& (Pre_Labels(label, j)~=test_target(label, j))
                contingencyTable(label, FN)=contingencyTable(label, FN)+1;
                contingencyTable(all, FN)=contingencyTable(all, FN)+1;
            end;            
        end;
    end;
   
   beta = 1;
   
   tp = contingencyTable(all, TP);
   fp = contingencyTable(all, FP);
   tn = contingencyTable(all, TN);
   fn = contingencyTable(all, FN);   
   [MicPrecision, MicRecall, MicFMeasure, MicAccuracy, MicSpecificity]=IR_Measures(tp, fp, tn, fn, beta);
   
   MacPrecision=0;
   MacRecall=0;
   MacAccuracy=0;
   MacFMeasure = 0;
   MacSpecificity = 0;
   
   for label=1:num_labels
       
       tp = contingencyTable(label, TP);
       fp = contingencyTable(label, FP);
       tn = contingencyTable(label, TN);
       fn = contingencyTable(label, FN);   
       [Precision, Recall, FMeasure, Accuracy, Specificity]=IR_Measures(tp, fp, tn, fn, beta);
       
       MacPrecision = MacPrecision+Precision;     
       MacRecall =MacRecall+Recall;             
       MacAccuracy = MacAccuracy+Accuracy;
       MacFMeasure = MacFMeasure+FMeasure;    
       MacSpecificity = MacSpecificity+Specificity;
   end
   
   MacPrecision = MacPrecision/num_labels;
   MacRecall=MacRecall/num_labels;   
   MacAccuracy=MacAccuracy/num_labels;
   MacFMeasure = MacFMeasure/num_labels;
   MacSpecificity = MacSpecificity/num_labels;
   
   
    