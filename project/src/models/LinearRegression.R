rm(list=ls())

library(Metrics)
library(tidyverse) 
library(caret)
library(data.table)
library(dplyr)

#Load in the data set 
train <- fread("./project/volume/data/interim/train.csv")
test <- fread("./project/volume/data/interim/test.csv")
df2 <- fread("./project/volume/data/interim/df2.csv")

#Dropping suburb and method
train <- select(train, -Suburb, -Method)
test <- select(test, -Suburb, -Method)

#Saving our Price because creating dumby variables will drop the Price column
train_y <- train$Price
test_y <- test$Price

#Set dummy variables 
dummies <- dummyVars(Price ~ ., data = train) 
dummies

#Implementing the new variables into the training data and test
train <- predict(dummies, newdata = train)
train <- data.table(train)
test <- predict(dummies, newdata = test)
test <- data.table(test)

#Bring the lost data back 
train$Price <- train_y

#Fitting our linear model
fit <- lm(Price ~., data = train)

#prediction
test$Pred_Price <- predict(fit,newdata = test)

#Creating data frame with our predicted prices 
prediction <- test[,.(Pred_Price)]

#Comparing our Predictions to our original data set df2
print(head(prediction))
print(head(df2$Price))

#Finding our root mean squared to assess our model
rmse(test_y,prediction$Pred_Price)
