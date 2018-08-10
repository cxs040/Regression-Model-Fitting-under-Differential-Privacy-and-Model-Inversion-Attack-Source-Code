function [pi] = pi_value(y,y1,fnr,fpr)
    tpr = 1 - fnr; %true postive rate  
    tnr = 1 - fpr; %true negative rate
    if(y1 == 1 && y == 1) 
       pi = tpr; 
    elseif(y1 == 0 && y == 0)
       pi = tnr; 
    elseif(y1 == 1 && y == 0)
       pi = fnr; 
    else 
       pi = fpr; 
    end; 
