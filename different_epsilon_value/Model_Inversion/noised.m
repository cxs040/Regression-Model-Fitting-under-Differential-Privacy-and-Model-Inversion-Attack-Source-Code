function y = noised(w)

global Coe2;
global Coe1;

y = w'*Coe2*w + Coe1'*w;