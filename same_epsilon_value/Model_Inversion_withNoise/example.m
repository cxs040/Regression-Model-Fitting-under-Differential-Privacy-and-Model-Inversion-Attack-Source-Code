function [w1, b1] = example(Test, Train, epsilon)

  errSum = 0;
  m=[]; 
%   
  
  
for rep = 1:500


   
    [w, b] = Functional_Logistic(Train, epsilon);
    
    % Call function
    errorRate = logClassification(Test, w, b)/size(Test, 1);
    
    errSum = errSum + errorRate;
     s(rep) = errorRate;
     t= [w' b errorRate];
     
     m = [t;m];
    % Evaluation
end
  disp(1-errSum/500);

   err= errSum/500; 

  %find the best w and b which has less error  
   [~,I] = min(abs(s-err));
    c = s(I);

  for i = 1:500 
    if ( m(i,15) == c)
        k = i;
    end;
   end; 

 w1 = m(k,1:13); 
 b1 = m(k,14); 
