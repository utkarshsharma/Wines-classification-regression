train = read_mixed_csv('training_classification_regression_2015.csv',',');
test = read_mixed_csv('challenge_public_test_classification_regression_2015.csv',',');
dataTrain = cellfun(@str2num,train(2:end,1:11));
dataTest = cellfun(@str2num,test(2:end,2:12));


%Linear Discriminant Analysis
lda = fitcdiscr(dataTrain(:,1:11),train(2:end,13));
ldaClass = resubPredict(lda);
ldaErr = resubLoss(lda);
[cMat_lda,grpOrder] = confusionmat(train(2:end,13),ldaClass);
Accuracy_lda = (1-ldaErr)*100;


%Quadratic Discriminant Analysis
qda = fitcdiscr(dataTrain(:,1:11),train(2:end,13),'DiscrimType','quadratic');
qdaErr = resubLoss(qda);
qdaClass = resubPredict(qda);
cMat_qda = confusionmat(train(2:end,13),qdaClass);
Accuracy_qda = (1-qdaErr)*100;


%cross-validation of qda
cp = cvpartition(train(2:end,13),'KFold',10);
cvqda = crossval(qda,'CVPartition',cp);
qdaCVErr = kfoldLoss(cvqda);

% decisiontree
t = fitctree(dataTrain(:,1:11),train(2:end,13),'PredictorNames',train(1,1:11));
% view(t,'Mode','graph');
dtErr = resubLoss(t);
Accuracy_dt = (1-dtErr)*100;

cvt = crossval(t,'CVPartition',cp);
dtCVErr = kfoldLoss(cvt);


% KMeans
class = char(train(2:end,13));
data = sortrows(train(2:end,:), 13);
data1 = cellfun(@str2num,data(:,1:11));
r = ones(5000,1);
for j = 1:5000
    if (class(j,1) == 'R')
        r(j)=2;
    end
end
[idx,C] = kmeans(dataTrain(:,1:11),2);
% opts = statset('Display','final');
% [idx,C] = kmeans(dataTrain(:,1:11),2,'Distance','cityblock','Replicates',5,'Options',opts);
% a = 0;
% delete(gcp);
% pool = parpool;                      % Invokes workers
% stream = RandStream('mlfg6331_64');  % Random number stream
% options = statset('UseParallel',1,'UseSubstreams',1,'Streams',stream);
% tic; % Start stopwatch timer
% [idx,C,sumd,D] = kmeans(dataTrain(:,1:11),2,'Options',options,'MaxIter',10000,'Display','final','Replicates',10);
% toc % Terminate stopwatch timer
% for i = 1:5000
%     if (idx(i) == 1)
%         a = a + 1;
%     end
% end

cMat_kmeans = confusionmat(idx,r);
Accuracy_kmeans = trace(cMat_kmeans)/5000*100;

% SVM
SVMstruct = svmtrain (dataTrain,train(2:end,13));
Y_svm = svmclassify(SVMstruct,dataTrain);
cMat_svm = confusionmat(Y_svm,train(2:end,13));
Accuracy_svm = trace(cMat_svm)/5000*100;

%Naive-Bayes
nbstruct = fitNaiveBayes(dataTrain,train(2:end,13));
Y_nb = nbstruct.predict(dataTrain);
cMat_nb = confusionmat(Y_nb,train(2:end,13));
Accuracy_nb = trace(cMat_nb)/5000*100;