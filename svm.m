train = read_mixed_csv('training_classification_regression_2015.csv',',');
test = read_mixed_csv('challenge_public_test_classification_regression_2015.csv',',');
dataTrain = cellfun(@str2num,train(2:end,1:11));
dataTest = cellfun(@str2num,test(2:end,2:12));
SVMstruct = svmtrain (dataTrain,train(2:end,13));
Group = svmclassify(SVMstruct,dataTrain);
NBstruct = fitNaiveBayes(dataTrain,train(2:end,13));
GroupNB = NBstruct.predict(dataTrain);
cMat1 = confusionmat(Group,train(2:end,13));
cMat2 = confusionmat(GroupNB,train(2:end,13));