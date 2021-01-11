function [DDIMAP1,DDIMAP2] = DDIMAP(DDI,w,b)
% T is cumulative times
% w is mapped weights
% b is center bias 
b1 = 0.3;
b2 = -0.2;
DDIMAP1 = sigmoid(DDI,w,b1+b);  % Non-linear mapping()
DDIMAP2 = sigmoid(DDI,w,b2+b);
end

