function [distance, adjusted] = labelDistance(targets1, targets2)
   nLabels = size(targets1, 1);
   differences = sum(targets1~=targets2);
   active = (sum((targets1+targets2)>=0)); 
   distance = differences/nLabels;
   adjusted = differences/active;
