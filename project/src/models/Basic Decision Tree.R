rm(list=ls())

library(data.table)
library(dplyr)
library(tidyverse) 
library(rpart) 
library(randomForest)
library(modelr)

#Loading in df2
df2 <- fread("./project/volume/data/interim/df2.csv")

#Fitting our data to the DT model using numeric variables 
fit <- rpart(Price ~ Rooms + Bathroom + Landsize + BuildingArea + Bedroom2 +
               YearBuilt + Lattitude + Longtitude, data = df2)

#Plotting our decision tree and adding in what the model is doing as text above it 
plot(fit, uniform=TRUE)
text(fit, cex=.5)

#predicting the house prices and comparing them the actual prices 
print(predict(fit, head(df2)))
print(head(df2$Price))

#Finding the mean average error for our model
mae(model = fit, data = df2)
