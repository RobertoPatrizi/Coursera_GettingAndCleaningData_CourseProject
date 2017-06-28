## Course Project
## run_analysis code developed by Roberto Patrizi

library(reshape2)
library(data.table)

## working directory - if you want to perform this code
## using another directory, it is necessary to put
## the new directory into the variable wdir
wdir <- "G://Anno 2017/Johns_Hopkins_Data_Science/3. Getting and Cleaning Data/Week 4/Course Project/UCI HAR Dataset/"

# load activity's label
act_lab <- data.table::fread(
                paste(wdir, "activity_labels.txt", sep = "")
        , stringsAsFactors = FALSE
        , col.names=c("Code", "Name"))



# load features
feat <- data.table::fread(
            paste(wdir, "features.txt", sep = "")
        , stringsAsFactors = FALSE
        , col.names=c("Code", "Name"))

# select features with mean() and std() data
feat_id <- grep(".*mean.*|.*std.*", feat$Name)
feat_names <- feat[grep(".*mean.*|.*std.*", feat$Name), feat$Name]
feat_names <- feat_names[feat_id] ## select just mean, std measures

## load train data
xtrain <- read.table(paste(wdir, "/train/X_train.txt", sep = ""))
xtrain <- xtrain[feat_id] # extract only measures of mean and std

train_act <- read.table(
    paste(wdir, "/train/Y_train.txt", sep = ""))

train_sub <- read.table(
    paste(wdir, "/train/subject_train.txt", sep = ""))

train_dt <- cbind(train_sub, train_act, xtrain)

## load test data
xtest <- read.table(paste(wdir, "/test/X_test.txt", sep = ""))
xtest <- xtest[feat_id] # extract only measures of mean and std

test_act <- read.table(
    paste(wdir, "/test/Y_test.txt", sep = ""))

test_sub <- read.table(
    paste(wdir, "/test/subject_test.txt", sep = ""))

test_dt <- cbind(test_sub, test_act, xtest)

## putting together train and test
whole_data <- rbind(train_dt, test_dt)
colnames(whole_data) <- c("subject", "activity", feat_names)

## melting the whole_data table
melted_data <- as.data.table(melt(whole_data, 
                                  id = c("subject", "activity")))

## figuring out the tidy data table
tidy_dt <- dcast.data.table(melted_data, 
                            subject + activity ~ variable, 
                            fun = mean)

## write out the tidy data set

## destination directory - modify it if you have to run this code
## on your computer
setwd("G:/Anno 2017/Johns_Hopkins_Data_Science/3. Getting and Cleaning Data/Week 4/Course Project")
write.table(tidy_dt, 
            file = "tidy_dataset.txt", 
            row.names = FALSE, 
            quote = FALSE)
