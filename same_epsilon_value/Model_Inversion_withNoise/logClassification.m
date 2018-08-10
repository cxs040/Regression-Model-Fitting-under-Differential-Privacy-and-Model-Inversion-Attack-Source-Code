function y = logClassification(Test, w, b)
TestX = Test(:,1:end-1);
TestY = Test(:,end);

Pred = TestX*w + b;
Pred(Pred>=0) = 1;
Pred(Pred<0) = 0;
y = sum(xor(TestY, Pred));