train = read_mixed_csv('training_classification_regression_2015.csv',',');
test = read_mixed_csv('challenge_public_test_classification_regression_2015.csv',',');
dataTrain = cellfun(@str2num,train(2:end,1:11));
dataTest = cellfun(@str2num,test(2:end,2:12));
% %Linear Discriminant Analysis
% lda = fitcdiscr(dataTrain(:,1:11),train(2:end,13));
% ldaClass = resubPredict(lda);
% ldaResubErr = resubLoss(lda);
% [ldaResubCM,grpOrder] = confusionmat(train(2:end,13),ldaClass);
% %Quadratic Discriminant Analysis
% qda = fitcdiscr(dataTrain(:,1:11),train(2:end,13),'DiscrimType','quadratic');
% qdaResubErr = resubLoss(qda);
% qdaClass = resubPredict(qda);
% qdaResubCM = confusionmat(train(2:end,13),qdaClass);
% %cross-validation of qda
% cp = cvpartition(train(2:end,13),'KFold',10);
% cvqda = crossval(qda,'CVPartition',cp);
% qdaCVErr = kfoldLoss(cvqda);
%decisiontree
% t = fitctree(dataTrain(:,1:11),train(2:end,13),'PredictorNames',train(1,1:11));
% view(t,'Mode','graph');
% dtResubErr = resubLoss(t);
% 
% cvt = crossval(t,'CVPartition',cp);
% dtCVErr = kfoldLoss(cvt);
%KMeans
% rng(1); % For reproducibility
% [idx,C] = kmeans(dataTrain(:,1:11),2);
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


NumRed = 0;
mean_Red = zeros(11,1);
NumWhite = 0;
mean_White = zeros(11,1);
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
NumWhite = 5000 - NumRed;

% for i = 1:length(data1(1,:))
%     [pRed(i,:),xRed(i,:)] = hist(data1(1:NumRed,i));
%     [pWhite(i,:),xWhite(i,:)] = hist(data1(NumRed+1:end,i));
% end

for i = 1:length(dataTrain(1,1:end))
    for j = 1 : 5000
        if (class(j,1) == 'R')
            mean_Red(i) = mean_Red(i) + dataTrain(j,i);
        else
            mean_White(i) = mean_White(i) + dataTrain(j,i);
        end
    end
%     range (i) = mean(dataTrain(1:end,i));
    mean_Red(i) = mean_Red(i)/NumRed;
    mean_White(i) = mean_White(i)/NumWhite;
    midpoint (i) = (mean_Red(i)+mean_White(i))/2;
%     norm_diff (i) = abs(mean_Red (i) - mean_White(i))/range(i);
%     dataTrain(5001,i) = norm_diff (i);
end
% dataTrain = dataTrain';
% dataTrain = sortrows(dataTrain,5001);
% dataTrain = dataTrain';
% dataTrain = dataTrain(1:5000,1:11);
doubtfulStrict = 0;
doubtfulLenient = 0;
r_train = zeros(5000,1);
for i = 1 : 5000
    count = 0;
    for j = 1: 11
%         if (abs(dataTrain(i,j)-mean_Red(j))<abs(dataTrain(i,j)-mean_White(j)))
        if (dataTrain(i,j)>midpoint(j)&& mean_Red(j)>mean_White(j) || dataTrain(i,j)<midpoint(j)&& mean_Red(j)<mean_White(j))
            count = count+1;
        end
    end
    if (count>5)
        r_train(i) = 1;
    end
    if (count>= 4 && count <=8)
        doubtfulStrict = doubtfulStrict + 1;
    end
    if (count>=5 && count <=7)
        doubtfulLenient = doubtfulLenient + 1;
    end
end

cMat_train = confusionmat(r_train,r);
accuracy_train = 100*trace(cMat_train)/5000;
    
% % Using Info gain, C Ealculatingntropy
% [p,x] = hist(dataTrain(1:end,1),ceil(2*iqr(dataTrain(11:end,1)')/5000^(1/3)));
% dp = (x(2)-x(1));
% area = sum(p)*dp;
% p = p/area;
% H = -sum( (p.*dp) .* log2(p) );