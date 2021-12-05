rm(list=ls())

#Loading Packages
library(caret)
library(data.table)
library(dplyr)
library(ggplot2)
library(ggcorrplot)
library(tidyverse) 

set.seed(9001)

# Loading in the Melbourne data 
df <- read.csv("~/Downloads/Melbourne_housing_FULL 2.csv")

#Understanding our data 
summary(df)

#Checking correlations through the numeric values 
df$Propertycount <- as.numeric(as.character(df$Propertycount))
df$Distance <- as.numeric(as.character(df$Distance)
                          )
#Check data to see which attributes are numeric & choose them 
numericvalues <- df[,c("Price","Rooms","Bedroom2","Bathroom",
                       "Car", "Landsize","Propertycount", "BuildingArea", "Distance", "Longtitude", "Lattitude")]
# Find how many NA values there are 
sum(is.na(numericvalues))

#Set the NA to = 0 
numericvalues<- na.omit(numericvalues)

#Snap shot of the correlation values 
cor(numericvalues)

#Set correlation variable and round the numbers to the nearest tenth
corr_numeric <- round(cor(numericvalues), 1)

#plot to visualize the correlations 
ggcorrplot(corr_numeric,
           type = "lower",
           lab = TRUE, 
           lab_size = 5,  
           colors = c("tomato2", "white", "springgreen3"),
           title="Correlogram of Housing Dataset", 
           ggtheme=theme_bw)

# From this correlation plot we can see that the highest correlations with Price come from rooms, bedroom2,
# Bathroom and car 
# This allows us to have a better understanding of what columns to use when working on our prediction codes

#ATTRIBUTE SELECTION 
#remove unneeded columns
df2 <- select(df, -Address,-Date, -SellerG, -Propertycount, 
                    -Regionname, -CouncilArea, -Distance)

#change NA values to 0
df2 <- na.omit(df2)

#Saving df2 to be used somewhere else
fwrite(df2,'./project/volume/data/interim/df2.csv')
