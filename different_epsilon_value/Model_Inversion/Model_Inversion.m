function [result]= Model_Inversion(coefvals,constant,Data,fnr,fpr,distintValue,marginalPro)


%get Data sample space



result = zeros(size(Data,1),1);


% suppose we already know the target attributes such as WS>120, WS>130, Ptc, etc.... 

for k = 1 : size(Data,1); 

Data_ss_sub = allcomb(Data(k,1),Data(k,2),Data(k,3),Data(k,4),distintValue(1:2,5),Data(k,6),Data(k,7),Data(k,8),Data(k,9),Data(k,10),Data(k,11),Data(k,12),Data(k,13));
 %Data_ss_sub = allcomb(Data(1:2,1),Data(1:2,2),Data(1:3,3),Data(k,4),Data(1:2,5),Data(k,6));

   
v1 = min(Data_ss_sub(:,5),[],1); 
v2 = max(Data_ss_sub(:,5),[],1);
  
m1 = Data_ss_sub(Data_ss_sub(:,5) == v1,:);  
m2 = Data_ss_sub(Data_ss_sub(:,5) == v2,:);    
% get marginal probability

% [p1, p2] = Marginal_Probability(m1, m2);


p1=zeros(size(m1,1),1);
p2=zeros(size(m2,1),1);
for i = 1 : size(m1 , 1) 
p = 1;
    for j = 1:13
        %[i1,j1] = deal(0); 
         I =0;
        %[i1, j1] = find(distintValue(:,j)== m1(i,j),1);
         I = find(distintValue(:,j)== m1(i,j),1);
         p = p*marginalPro(I,j); 
        
    end; 
         p1(i) = p; 
end 
for i = 1 : size(m2 , 1) 
p = 1;
    for j = 1:13 
       % [i1,j1] = deal(0); 
         I =0;
        %[i1, j1] = find(distintValue(:,j)== m1(i,j),1);
         I = find(distintValue(:,j)== m2(i,j),1);
         p = p*marginalPro(I,j); 
        
    end; 
         p2(i) = p; 
end 



s1 = Logistic(m1*coefvals + constant); 
d1 = zeros(size(s1,1),1);
for j = 1: size(s1) 
    if(s1(j)<0.5)
        d1(j) = 0; 
    else 
        d1(j) = 1; 
    end; 
end;

s2 = Logistic(m2*coefvals + constant); 
d2 = zeros(size(s2,1),1);
for j = 1: size(s2) 
    if(s2(j)<0.5)
        d2(j) = 0; 
    else 
        d2(j) = 1; 
    end; 
end;      
y=Data(k,end);
%initial pi 
pi1 = zeros(size(d1,1),1);
pi2 = zeros(size(d2,1),1);
% get corresponding pi.  
for i = 1 : size(d1,1) 
    pi1(i) = pi_value(y, d1(i), fnr, fpr); 
end; 
for j = 1 : size(d2,1) 
    pi2(j) = pi_value(y, d2(j), fnr, fpr); 
end; 

%compare result. 
 t1 = p1'*pi1; 
 t2 = p2'*pi2;

if t1>t2 
    r = v1; 
else 
    r = v2;
end;
result(k) = r; 
%   %Compare probability of t1 and t2; 
%   z1=t1/(t1+t2);  
%   z2=t2/(t1+t2); 
%  % z3=t3/(t1+t2); 
%   p = [z1 z2];
%   s(k,:) = p;

end;