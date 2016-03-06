# Wines-classification-regression
This project was done as a part of a Machine Learning course with Hannu Tiitu.

Two models, one for classification and one for regression, is implemented for determining the qualities for given wines. The training data set contains 11 chemical properties, a quality value from 1 to 7 and color information (red or white) for 5000 different wines. This set is used for training the algorithms which are used for determining the quality and color of other 1000 wines which constitutes the test set. This set has only the 11 chemical properties for each wine. Decision tree was implemented for the classification and linear regression for the regression. The performance of the classification was rather good as regression could find only about half of the correct quality values.

# Classification 

We decided to compare how all the classification algorithms already present in Matlab’s libraries worked against each other. We checked for Linear and Quadratic Discriminant analysis, k-means, Naive Bayes, SVM and Decision Trees. Out of these the decision trees gave one of the best accuracy (greater than 99 %) while k-means gave an accuracy of only around 69 %. Looking at the results, we decided to make a decision tree by ourselves. The biggest problem was that a Decision tree for 11 attributes would be too complicated. So we wrote a decision tree (ourDT.m) which would be much simpler than usual classification trees but would still give a good accuracy on the training set (greater than 96 %).

#Regression

The selected model for this task was linear regression. The testing against the training set itself gave 53.0 % of accuracy for the homogeneous linear regression and a slightly worse performance 52.8 % for the non-homogeneous linear regression. The built in Matlab linear regression functions give same results. As seen on the data produced by the regression analysis, only the middle values from 3 to 5 were obtained. This shows that linear model is not the optimal for this data set. Higher order polynomial fitting should be done for the future improvement.
