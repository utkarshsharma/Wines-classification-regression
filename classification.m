trainData = read_mixed_csv('training_classification_regression_2015.csv',',');
testData = read_mixed_csv('challenge_public_test_classification_regression_2015.csv',',');
XTrain = cellfun(@str2num,trainData(2:end,1:11));
XTest = cellfun(@str2num,testData(2:end,2:12));

NumRed = 0;
mean_Red = zeros(11,1);
mean_White = zeros(11,1);
midpoint = zeros(11,1);
class = char(trainData(2:end,13));
for j = 1:5000
    if (class(j,1) == 'R')
        NumRed = NumRed+1;
    end
end
NumWhite = 5000 - NumRed;

for i = 1:length(dataTrain(1,1:end))
    for j = 1 : 5000
        if (class(j,1) == 'R')
            mean_Red(i) = mean_Red(i) + dataTrain(j,i);
        else
            mean_White(i) = mean_White(i) + dataTrain(j,i);
        end
    end
    
    mean_Red(i) = mean_Red(i)/NumRed;
    mean_White(i) = mean_White(i)/NumWhite;
end

rHat_train = ourDT(XTrain, mean_Red, mean_White);
rHat_test = ourDT(XTest, mean_Red, mean_White);
rHat_test = cellstr(rHat_test);
for i = 1:size(XTest,1)
    yHat(i+1,1:2) = [i  rHat_test(i)];
end

yHat(1, 1:2) = [cellstr('id') cellstr('type')];
xlswrite('prediction-12345X-519520.xlsx', yHat);
cMat_ourDT = confusionmat(rHat_train,class);
Accuracy_ourDT = 100*trace(cMat_ourDT)/5000;