#Since decision trees can be tricky due to overfitting and underfitting we can 
#Use Random Forest to take predictions from multiple trees 

rm(list=ls())

library(tidyverse) 
library(rpart) 
library(randomForest)
library(modelr)

#Load in the data set 
df2 <- fread("./project/volume/data/interim/df2.csv")

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

#finding the mean average error for model, based on our test data
mae(model = fitRandomForest, data = split_data$test)
