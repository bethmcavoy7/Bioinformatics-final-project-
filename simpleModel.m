clear
clc
[Num,~,dataSet]=xlsread('Dataset_C_MD_outcome2.gct(og).xlsx');
[row, col]=size(dataSet);
num=0;

name=dataSet(4:row,1)';
name=string(name);

patientData=Num(3:row-1,3:col);

patientData=patientData';
% adding the outcome column to make it train later 
outcome=[repmat({'dead'}, 21,1); repmat({'alive'}, 39,1)];
outcome=string(outcome);
patientNum=[1:60]';
patientData=[outcome patientData];
dead=randperm(21);

alive=randperm(39);
alive=alive+21;

trainingidx=[dead(1:10) alive(1:20)]';
testidx=[dead(11:21) alive(21:39)]';

for ind=1:30
    train(ind,:)=patientData(trainingidx(ind),:);
    test(ind,:)=patientData(testidx(ind),:);
end

%first col is what number patient we are testing
%second col is the outcome 
%everything else is the gene test 
out=train(:,1);
train=train(:,2:end);
train=array2table(train);

test=array2table(test);

outnm=string(train.Properties.VariableNames(1));

Mdl = fitcknn(train,out,'NumNeighbors',4);
Mdl.PredictorNames
resubLoss(Mdl)
cvMdl=crossval(Mdl,'Leaveout','on');
resubLoss(cvMdl)
% test(1,:)
[label,score,cost] = predict(cvMdl,train(1,:))
