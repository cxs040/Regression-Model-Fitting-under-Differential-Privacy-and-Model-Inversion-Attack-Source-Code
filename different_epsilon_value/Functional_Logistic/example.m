
% Copyright 2012 Jun Zhang
RawData  =  importfile('MI_ALLCle_income.xlsx','Sheet1','A2:N30163');
%Data = struct2array(Data);
[DataRow, DataCol] = size (RawData);
RawData(:,[7 14]) =RawData(:,[14 7]);
%RawData(:,[5 7]) =RawData(:,[7 5]);
RawData_min = min(RawData,[],1);
RawData_max = max(RawData,[],1);

Data = (RawData-ones(DataRow,1)*RawData_min)./(ones(DataRow,1)*(RawData_max-RawData_min));  % Convert all attributes to [0, 1]
Data = [(Data(:,1:end-1)-0.5).*2, Data(:,end)];                                             % Convert X part to [-1, 1]; Y in binary {0, 1}



errSum = 0;
for rep = 1:500
    
 
    fold = rand(DataRow, 1);
    SepLine = (0<fold) & (fold<=0.2);
    Test = Data(SepLine,:);
    Train = Data(not(SepLine),:);
    
    %edit by chengsi 2015    
    %sensitive attribute
    epsilon =0.011;
    %non-senstive attribute
    epsilon2 =1.082;
    [w, b] = Functional_Logistic(Train, epsilon, epsilon2);
    
    % Call function
   
    
    
    errorRate = logClassification(Test, w, b)/size(Test, 1);
    errSum = errSum + errorRate;
      % s(rep) = errorRate; 
%     
%     t= [w' b errorRate];
%     %Save all returned w and b to a matrix
%     m = [t;m];
%     % Evaluation
end

disp(errSum/500);
disp(1-errSum/500);

