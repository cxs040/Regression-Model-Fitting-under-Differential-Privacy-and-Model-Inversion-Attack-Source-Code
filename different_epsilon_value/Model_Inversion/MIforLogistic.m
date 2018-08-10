RawData = importfile('MI_ALLCle_income.xlsx','Sheet1','A2:N30163');
[DataRow, DataCol] = size (RawData);

RawData(:,[7 14]) =RawData(:,[14 7]);

% Each row in data represents an object [x1, x2, x3, ..., xd, y], where x's
% are features and y is the label in binary.

RawData_min = min(RawData,[],1);
RawData_max = max(RawData,[],1);

Data = (RawData-ones(DataRow,1)*RawData_min)./(ones(DataRow,1)*(RawData_max-RawData_min));  % Convert all attributes to [0, 1]
Data = [(Data(:,1:end-1)-0.5).*2, Data(:,end)];                                             % Convert X part to [-1, 1]; Y in binary {0, 1}


%find Marginal Probability
marginalPro=zeros(14,14); 
for i= 1 : 14

       h = unique(Data(:,i));
       for t = 1: length(h)
           marginalPro(t,i) = sum(Data(:,i)== h(t,1))/size(Data,1);
       end; 
end; 
%find distint value of each attribute 
distintValue = zeros(14,14);
for i= 1 : 14
       h = unique(Data(:,i));
       for t = 1: length(h)
           distintValue(t,i) =  h(t,1);
       end; 
end; 

MI =[];
every=[];



 for rep = 1 : 10
   % Data are seperated into Train part (80%) and Test part (20%)
    fold = rand(DataRow, 1);
    SepLine = (0<fold) & (fold<=0.2);
    Test = Data(SepLine,:);
    Train = Data(not(SepLine),:);    
   
    [B, constant] = example(Test, Train);
    B=B'; 
    X=Train(:,1:end-1); 
    Y=Train(:,end); 
 %predicated value based on released model
    input= constant+Train(:,1:end-1)*(B);
    Y1= Logistic(input);

    s = zeros(size(Y1,1),1);
    for j = 1: size(Y1) 
      if(Y1(j)<0.5)
        s(j) = 0; 
      else 
        s(j) = 1; 
      end; 
    end;     

%set up a confusion matrix based on the true value and predicated value
   [tp, tn, fn, fp] = deal(0);
    for i = 1: size(Y,1)
       if(s(i) == 1 && Y(i) == 1) 
         tp = tp+1; 
       elseif(s(i) == 0 && Y(i) == 0)
         tn = tn+1; 
       elseif(s(i) == 1 && Y(i) == 0)
         fn = fn+1; 
       else 
         fp = fp+1; 
       end; 
    end; 
   fnr = 0; %false negative rate
   fpr = 0; %false positive rate
   fnr = fn/(fn+tp); 
   fpr = fp/(fp+tn); 

   
    sample = Test; 
[result]=Model_Inversion(B,constant,sample, fnr, fpr,distintValue,marginalPro);
 
 p=0; 
    %compute the accury of model inversion result. 
      for i = 1 : size(result) 
        if(result(i)== sample(i,5))
        p = p+1; 
        end;     
      end;  
    disp(p/size(sample,1));
    t(rep) = p/size(sample,1); 
  
 end; 
   disp(t); 
