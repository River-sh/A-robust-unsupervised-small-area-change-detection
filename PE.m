function [TN,TP,FN,FP,FA,MD,OER,PCC,Kappa,F1] = PE(PL,GT)
if isempty(PL)
    error('!!!Not exist reference map');
end
min_PL = min(min(PL));
max_PL = max(max(PL));
PL = PL/(max_PL-min_PL);

min_GT = min(min(GT));
max_GT = max(max(GT));
GT = GT/(max_GT-min_GT);

PL(find(PL >= 0.5))=1;
PL(find(PL < 0.5))=0;

GT(find(GT >= 0.5))=1;
GT(find(GT < 0.5))=0;

[x,y]=size(GT);
all_p = x*y;
TN = numel(find(GT==0&PL==0));
TP = numel(find(GT~=0&PL~=0));
FP = numel(find(GT==0&PL~=0));
FN = numel(find(GT~=0&PL==0));

MC = numel(find(PL ~= 0));     %the number of changed pixels
MU = numel(find(PL == 0));     %the number of unchanged pixels
RMC = numel(find(GT ~= 0));
RMU = numel(find(GT == 0));

FA = FP/MC;
MD = FN/RMC;
OER = (FP+FN)/all_p;         % overall error rate
PCC = (TP+TN)/all_p;         % percentage correct classification

PRE = (RMC*MC+RMU*MU)/(all_p*all_p) 
Kappa = (PCC-PRE)/(1-PRE);   % Kappa coefficient
precision = TP/(TP+FP);
recall = TP/(TP+FN);
F1 = (2*precision*recall)/(precision+recall);
end

