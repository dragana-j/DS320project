#Since decision trees can be tricky due to overfitting and underfitting we can 
#Use Random Forest to take predictions from multiple trees 

rm(list=ls())
library(MLmetrics)
library(tidyverse) 
library(rpart) 
library(randomForest)
library(modelr)

#Load in the data set 
df2 <- fread("./project/volume/data/interim/df2.csv")
test <- fread("./project/volume/data/interim/test.csv")

test_y <-test$Price
test_y2 <- data.table(test_y)
dftest <- lapply(test_y2,as.numeric)
# To begin we want to split our data so that 30% is in the test set and 70% is in the training set
split_data <- resample_partition(df2, c(test = 0.3, train = 0.7))

train <- split_data$train
test <- split_data$test


#Saving our data
fwrite(train$data,'./project/volume/data/interim/train.csv')
fwrite(test$data,'./project/volume/data/interim/test.csv')

#fitting the random forest model to our training set
fitRandomForest <- randomForest(Price ~ Rooms + Bathroom + Landsize + BuildingArea + Bedroom2 +
                                  YearBuilt + Lattitude + Longtitude, data = split_data$train)

pred_values <- predict(fitRandomForest,test$data)
pred_table <- data.table(pred_values)

#finding the mean average error for model, based on our test data
mae(model = fitRandomForest, data = split_data$test)
rmse(actual = test_y, 
     predicted = pred_values)

#writing our RF predictions in csv
fwrite(pred_table,'./project/volume/data/interim/RFpred.csv')
