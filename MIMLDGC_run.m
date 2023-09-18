%Performs a train/test experiment of MLDGC [1] with arff data input.
%
%    Syntax
%
%       [tr_time, te_time, HammingLoss, SubsetAccuracy, MacPrecision, MacRecall, MacFMeasure, MacAccuracy, MicPrecision, MicRecall, MicFMeasure, MicAccuracy, EBPrecision, EBRecall, EBFMeasure, EBAccuracy, RankingLoss, OneError, Coverage, Average_Precision]
%       = MLDGC_run(arff_train_file, arff_test_file, separator, k, distance, file_metrics, file_labels, file_outputs)
%
%    Description
%
%       MLDGC_run takes,
%           All arguments are strings to ease communication with java applications
%
%           arff_train_file  - Filename of arff for train
%           arff_test_file   - Filename of arff for test
%           separator        - Separator used for relational attribute in arrf file. It can be: '1' if separator is ' or '2' if separator is "
%           k                - The number of neighbors.
%           distance         - The distance function to be used 1:MaxHaussdorf, 2:minHaussdorf, 3:AveHaussdorf
%           extNeigh         - if 1 all instances with the same dinstance are included in the neighborhood
%
%     returns the following values:
%           tr_time          - training time in seconds           
%           te_time          - test time in seconds           
%           metrics          - HammingLoss, SubsetAccuracy, MacPrecision, MacRecall, MacFMeasure, MacAccuracy, MacSpecificity, MicPrecision, MicRecall, MicFMeasure, MicAccuracy, MicSpecificity, EBPrecision, EBRecall, EBFMeasure, EBAccuracy, EBSpecificity, RankingLoss, OneError, Coverage, Average_Precision
%
%      and writes the following files,    
%           file_metrics     - Filename for the following output metrics: train and test time, HammingLoss,
%           RankingLoss, OneError, Coverage, Average_Precision, EBPrecision, EBRecall, EBFMeasure, EBAccuracy, SubsetAccuracy, MacPrecision, MacRecall, MacFMeasure, MacAccuracy, MicPrecision, MicRecall, MicFMeasure, MicAccuracy.
%           file_labels      - Filename to store a matrix with label predictions as -1, 1 value
%           file_outputs     - Filename to store a matrix with predictions. The confidence output of the ith testing bag on the l-th class is stored in (l,i) position
%
% [1] Reyes, O., Morell, C., & Ventura, S. (2016). Effective lazy learning algorithm based on a data gravitation model for multi-label learning. Information Sciences, 340, 159-174.


function [tr_time, te_time, HammingLoss, SubsetAccuracy, MacPrecision, MacRecall, MacFMeasure, MacAccuracy, MacSpecificity, MicPrecision, MicRecall, MicFMeasure, MicAccuracy, MicSpecificity, EBPrecision, EBRecall, EBFMeasure, EBAccuracy, EBSpecificity, RankingLoss, OneError, Coverage, Average_Precision] = MIMLDGC_run(arff_train_file, arff_test_file, separator, k, distance, extNeigh, file_metrics, file_labels, file_outputs)

%reads dataset
[train_targets, train_bags] = readMIMLArff(arff_train_file, separator);
[test_targets, test_bags] = readMIMLArff(arff_test_file, separator); 

%conversion of parameters from char to number
k = str2num(k);
distance = str2num(distance);
if strcmp(extNeigh, '1')
    extNeigh = true;
else
    extNeigh = false;
end    
configuration = sprintf("MLDGC(k: %d dist: %d extNeigh: %d)", k, distance, extNeigh);

%train and test
[tr_time, NGC, max_values, min_values]=MIMLDGC_train(train_bags, train_targets, k, distance, extNeigh); 
[Outputs,Pre_Labels,te_time]=MIMLDGC_test(train_bags,train_targets,test_bags,k, NGC, max_values, min_values, distance, extNeigh);

%computes metrics
HammingLoss=Hamming_loss(Pre_Labels,test_targets);
RankingLoss=Ranking_loss(Outputs,test_targets);
OneError=One_error(Outputs,test_targets);
Coverage=coverage(Outputs,test_targets);
Average_Precision=Average_precision(Outputs,test_targets);

%computes additional metrics
[EBPrecision, EBRecall, EBFMeasure, EBAccuracy, EBSpecificity, SubsetAccuracy]=EB_Measures(Pre_Labels,test_targets);
[MacPrecision, MacRecall, MacFMeasure, MacAccuracy, MacSpecificity, MicPrecision, MicRecall, MicFMeasure, MicAccuracy, MicSpecificity]=LB_Measures(Pre_Labels,test_targets);

%saves outputs
exist = isfile(file_metrics);
fid = fopen(file_metrics,'a'); 
if ~exist % if file does not exist, the header is writen into file
    fprintf(fid, 'Algorithm(Configuration), TrainFile, TestFile, Tr_time (ms), Te_time (ms), HammingLoss, SubsetAcc, MacPrecision, MacRecall, MacFMeasure, MacAccuracy, MacSpecificity, MicPrecision, MicRecall, MicFMeasure, MicAccuracy, MicSpecificity, EBPrecision, EBRecall, EBFMeasure, EBAccuracy, EBSpecificity, RankingLoss, OneErrror, Coverage, Average_Precision\n');     
end

fprintf(fid,'%s, %s, %s, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f\n', configuration, arff_train_file, arff_test_file, tr_time*1000, te_time*1000, HammingLoss, SubsetAccuracy, MacPrecision, MacRecall, MacFMeasure, MacAccuracy, MacSpecificity, MicPrecision, MicRecall, MicFMeasure, MicAccuracy, MicSpecificity, EBPrecision, EBRecall, EBFMeasure, EBAccuracy, EBSpecificity, RankingLoss, OneError, Coverage, Average_Precision);
fclose(fid);

fid = fopen(file_outputs,'w');
[f,c] = size(Outputs);
fprintf(fid,  [repmat(' %f ', 1, c) '\n'], Outputs);
fclose(fid);

fid = fopen(file_labels,'w');
[f,c] = size(Pre_Labels);
fprintf(fid,  [repmat(' %d ', 1, c) '\n'], Pre_Labels);
fclose(fid);


fprintf('The program MLDGC_run has finished\n');
