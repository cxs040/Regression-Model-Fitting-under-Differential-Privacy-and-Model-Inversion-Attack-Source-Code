  RawData = importfile('MI_ALLCle_income.xlsx','Sheet1','A2:N30163');
[DataRow, DataCol] = size (RawData);
RawData(:,[13 14]) =RawData(:,[14 13]);
% Each row in data represents an object [x1, x2, x3, ..., xd, y], where x's
% are features and y is the label in binary.




RawData_min = min(RawData,[],1);
RawData_max = max(RawData,[],1);

Data = (RawData-ones(DataRow,1)*RawData_min)./(ones(DataRow,1)*(RawData_max-RawData_min));  % Convert all attributes to [0, 1]
Data = [(Data(:,1:end-1)-0.5).*2, Data(:,end)];                                             % Convert X part to [-1, 1]; Y in binary {0, 1}

 errSum = 0;
 m = [];
 for rep = 1:500
    %splite data set into Train data set(80%) and Test data set(20%)
    fold = rand(DataRow, 1);
    SepLine = (0<fold) & (fold<=0.2);
    Test = Data(SepLine,:);
    Train = Data(not(SepLine),:); 
    X= Train(:,1:end-1);
    Y= Train(:,end);
    Z= Test(:,end);
    
    %based on Train data set, generate a new logistic regression model
    B = glmfit(X, [Y ones(size(Y,1),1)], 'binomial', 'link', 'logit'); 
    constant = B(1,:); 
    B(1,:) = []; 
    
    %based on this new model, compute the response value by using Test
    %data set
    input= constant+Test(:,1:end-1)*(B);
    Y1= Logistic(input);

    s = zeros(size(Y1,1),1);
    for j = 1: size(Y1) 
      if(Y1(j)<0.5)
        s(j) = 0; 
      else 
        s(j) = 1; 
      end; 
    end;     
    
     
      tp = 0;
    %compare the true value and estimate value of response variable with
    %test data set. 
    for i = 1: size(Z,1)
       if((s(i) == 1 && Z(i) == 1)||(s(i) == 0 && Z(i) == 0)) 
         tp = tp+1; 
       end; 
    end; 
    
      errorRate=tp/size(Z,1);
      errSum = errSum + errorRate;
 end
   
   rate = errSum/500;