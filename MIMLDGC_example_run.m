%% Executing MLDGC_run
clear();

separator='2'; %example_data
arff_train_file='miml_example_train.arff';
arff_test_file='miml_example_test.arff';

%Default parameters:
k='10'; % Setting the number of neighbors
distance = '3'; %AveHaussdorf
%distance = '4'; %aveCosine
extNeigh = '0'; % 0: false 1: true  


file_metrics='metrics.txt';
file_labels='predictions.txt';
file_outputs='output.txt';

[tr_time, te_time, HammingLoss, SubsetAccuracy, MacPrecision, MacRecall, MacFMeasure, MacAccuracy, MacSpecificity, MicPrecision, MicRecall, MicFMeasure, MicAccuracy, MicSpecificity, EBPrecision, EBRecall, EBFMeasure, EBAccuracy, EBSpecificity, RankingLoss, OneError, Coverage, Average_Precision] = MIMLDGC_run(arff_train_file, arff_test_file, separator, k, distance, extNeigh, file_metrics, file_labels, file_outputs);



