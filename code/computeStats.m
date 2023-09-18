function [max_values, min_values] = computeStats(bags, max_values, min_values)
% Computes max and min values for all attributes of a set of bags
% computeStats takes
%    - bags A set of bags
%    - max_values
%    - min_values
% and returns
%    - max_values
%    - min_values

  [~, num_attr] = size(bags{1,1});
  
  if nargin <3      
     max_values = zeros(num_attr, 1);
     min_values = zeros(num_attr, 1);
     max_values(:) = realmin;
     min_values(:) = realmax;    
  end

   num_bags = size(bags, 1);
   for i=1: num_bags
     aBag = bags{i, 1};
     [num_inst, ~] = size(bags{i, 1});
     for j=1: num_inst         
        for k=1: num_attr
            if aBag(j, k) > max_values(k,1)
                max_values(k, 1) = aBag(j, k);
            end
            
            if aBag(j, k) < min_values(k,1)
                min_values(k, 1) = aBag(j, k);
            end 
        end            
     end    
   end
end

