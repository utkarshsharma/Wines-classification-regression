trainData = read_mixed_csv('training_classification_regression_2015.csv',',');
testData = read_mixed_csv('challenge_public_test_classification_regression_2015.csv',',');
XTrain = cellfun(@str2num,trainData(2:end,1:11));
XTest = cellfun(@str2num,testData(2:end,2:12));


X = [ones(5000, 1)  XTrain];
Y = cellfun(@str2num, trainData(2:end, 12));
W = pinv(X)*Y;
% H = zeros(5000,1);
accuracy = 0;
H = W'*X';
for i = 1:5000
    H(i) = round (H(i));
    if (H(i) < 1)
        H(i) = 1;
    elseif (H(i) > 7)
        H(i) = 7;
    end
    if (H(i) == Y(i))
        accuracy = accuracy + 1;
    end
end
X_test = [ones(1000, 1)  XTest];
H_test = W'*X_test';
for i = 1:1000
    H_test(i) = round (H_test(i));
    if (H_test(i) < 1)
        H_test(i) = 1;
    elseif (H_test(i) > 7)
        H_test(i) = 7;
    end
end
yy = regexp(sprintf('%i ',H_test),'(\d+)','match');
% yHat (2:1001, 1:2) = [1:size(XTest,1) yy];
for i = 1:size(XTest,1)
    yHat(i+1,1:2) = [i  yy(i)];
end
yHat(1, 1:2) = [cellstr('id') cellstr('quality')];
xlswrite('regression-12345X-519520.xlsx', yHat);
accuracy = accuracy/5000*100;