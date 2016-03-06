train = read_mixed_csv('training_classification_regression_2015.csv',',');
test = read_mixed_csv('challenge_public_test_classification_regression_2015.csv',',');
dataTrain = cellfun(@str2num,train(2:end,1:11));
dataTest = cellfun(@str2num,test(2:end,2:12));

NumRed = 0;
% mean_Red = zeros(11,1);
NumWhite = 0;
% mean_White = zeros(11,1);
class = char(train(2:end,13));
data = sortrows(train(2:end,:), 13);
data1 = cellfun(@str2num,data(:,1:11));
r = zeros(5000,1);
for j = 1:5000
    if (class(j,1) == 'R')
        NumRed = NumRed+1;
        r(j)=1;
    end
end
NumWhite = length(dataTrain(:,1)) - NumRed;
pr = NumRed/length(dataTrain(:,1)); %Treating Red as 1 and white as 0
train1 = data1(1:NumRed,:);
train0 = data1(NumRed+1:end,:);
alpha = 1;
K = 2;

for j = 1:11;
    p0(j) = (alpha + sum(train0(:,j)))/(K*alpha+NumWhite);
end

for j = 1:11;
    p1(j) = (alpha + sum(train1(:,j)))/(K*alpha+NumRed);
end
r_train = zeros(5000,1);
% function probRequalto1 = probRequalto1(dataset(:,:))
num = zeros(5000,11);
den = zeros(5000,11);
Num = zeros(1,11);
Den = zeros(1,11);

for i = 1:length(data1(:,1))
    for j = 1:11;
        num(i,j) = p0(j)^dataTrain(i,j)*(1-p0(j))^(1-dataTrain(i,j));
        den(i,j) = p1(j)^dataTrain(i,j)*(1-p1(j))^(1-dataTrain(i,j));
    end
    Num(i) = prod(num(i,:));
    Den(i) = prod(den(i,:));
    r1(i) = 1/(1+Num(i)/Den(i)*(1-pr)/pr);
    if (r1(i)>=0.5)
        r_train(i) = 1;
    end
end
cMat_train = confusionmat(r_train,r);
accuracy_train = 100*trace(cMat_train)/5000;

% r_test = zeros(5000,1);
% for i = 1:length(dataTest(:,1))
%     for j = 1:length(dataTest(1,:));
%         num(i,j) = p0(j)^dataTest(i,j)*(1-p0(j))^(1-dataTest(i,j));
%         den(i,j) = p1(j)^dataTest(i,j)*(1-p1(j))^(1-dataTest(i,j));
%     end
%     Num(i) = prod(num(i,:));
%     Den(i) = prod(den(i,:));
%     r1(i) = 1/(1+Num(i)/Den(i)*(1-pr)/pr);
%     if (r1(i)>=0.5)
%         r_test(i,:) = 1;
%     end
% end
% cMat_test = confusionmat(r_test,test(2:end,14));
% accuracy_test = 100*trace(cMat_test)/1000;
% w0 = log((1-pr)/pr);