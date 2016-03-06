function [rHat, doubtfulStrict, doubtfulLenient] = ourDT(X, mean_Red, mean_White)
doubtfulStrict = 0;
doubtfulLenient = 0;
for i = 1 : size(X,1)
    count = 0;
    for j = 1: size(X,2)
        if (abs(X(i,j)-mean_Red(j))<abs(X(i,j)-mean_White(j)))
            count = count+1;
        end
    end
    if (count>size(X,2)/2)
        rHat(i,1:3) = 'Red';
    else
        rHat(i,1:5) = 'White';
    end
    if (count>= ceil(size(X,2))-2 && count<= floor(size(X,2))+2)
        doubtfulStrict = doubtfulStrict + 1;
    end
    if (count>= ceil(size(X,2))-1 && count<= floor(size(X,2))+1)
        doubtfulLenient = doubtfulLenient + 1;
    end
end
doubtfulStrict =  doubtfulStrict/size(X,1)*100;
doubtfulLenient =  doubtfulLenient/size(X,1)*100;