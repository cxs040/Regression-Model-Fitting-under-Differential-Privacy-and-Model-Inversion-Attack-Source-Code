

RawData  =  importfile('MI_ALLCle_income.xlsx','Sheet1','A2:N30163');

[DataRow, DataCol] = size (RawData);
RawData(:,[9 14]) =RawData(:,[14 9]);

RawData_min = min(RawData,[],1);
RawData_max = max(RawData,[],1);

Data = (RawData-ones(DataRow,1)*RawData_min)./(ones(DataRow,1)*(RawData_max-RawData_min));  % Convert all attributes to [0, 1]
Data = [(Data(:,1:end-1)-0.5).*2, Data(:,end)];                                             % Convert X part to [-1, 1]; Y in binary {0, 1}



errSum = 0;

for rep = 1:500
       % Data are seperated into Train part (80%) and Test part (20%)
    fold = rand(DataRow, 1);
    SepLine = (0<fold) & (fold<=0.2);
    Test = Data(SepLine,:);
    Train = Data(not(SepLine),:);

    
    epsilon = 0.05;
    [w, b] = Functional_Logistic(Train, epsilon);
    
    % Call function
   
    
    
    errorRate = logClassification(Test, w, b)/size(Test, 1);
    errSum = errSum + errorRate;

end


disp(1-errSum/500);
