rm(list=ls())

library(Metrics)
library(data.table)
library(dplyr)
library(tidyverse) 
library(rpart) 
library(randomForest)
library(modelr)

#Loading in df2
df2 <- fread("./project/volume/data/interim/df2.csv")
test <- fread("./project/volume/data/interim/test.csv")

test_y <- test$Price

#Fitting our data to the DT model using numeric variables 
fit <- rpart(Price ~ Rooms + Bathroom + Landsize + BuildingArea + Bedroom2 +
               YearBuilt + Lattitude + Longtitude, data = df2)

#Plotting our decision tree and adding in what the model is doing as text above it 
plot(fit, uniform=TRUE)
text(fit, cex=.5)

#predicting the house prices and comparing them the actual prices 
print(predict(fit, head(df2)))
print(head(df2$Price))
 pred <- predict(fit, df2)
DTpred <- data.table(pred)

#Finding the mean average error for our model
mae(model = fit, data = df2)
rmse(actual = test_y, 
     predicted = pred)
testprice <- data.table(test_y)
#writing our DT prediction in csv
fwrite(DTpred,'./project/volume/data/interim/DTpred.csv')
fwrite(testprice,'./project/volume/data/interim/testprice.csv')
