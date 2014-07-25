## Getting and Cleaning Data Project
## Alireza Tajic
##
## Original Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## Original Data Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##
## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Checking and installing the required packages:
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

library("data.table")
library("reshape2")



## Create the folder ./Data in the working directory:
if (!file.exists("Data")){
  dir.create("./Data")
}

#Download the zip file:
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destFile)
DateDownloaded <- date()

#Extract the zip file into ./Data:
unzip(zipfile=destFile, exdir="./Data")
#Deleting the zip file from the working directory:
file.remove(destFile)
#Getting the name of the extracted file:
dirName <- list.files("./Data")
dirName <- paste("./Data", dirName, sep='/')

 

## Load: activity labels
activity_labels <- read.table(paste(dirName, "activity_labels.txt", sep='/'))[,2]

## Load: data column names
features <- read.table(paste(dirName, "features.txt", sep='/'))[,2]

## Extract only the measurements on the mean and standard deviation for each measurement.
extractedFeatures <- grepl("mean|std", features)



## Load and process X_test & y_test data.
message("Load and process X_test & y_test data.")
X_test <- read.table(paste(dirName, "test", "X_test.txt", sep='/'))
y_test <- read.table(paste(dirName, "test", "y_test.txt", sep='/'))
subject_test <- read.table(paste(dirName, "test", "subject_test.txt", sep='/'))

## Setting the X_test column names
names(X_test) <- features

## Extract only the measurements on the mean and standard deviation for each measurement.
X_test <- X_test[,extractedFeatures]

## Load activity labels
y_test[,2] <- activity_labels[y_test[,1]]
names(y_test) <- c("Activity_ID", "Activity_Label")
names(subject_test) <- "subject"
 
## Bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
message("The test_data has been bounded.")
 


## Load and process X_train & y_train data.
message("Load and process X_train & y_train data.")
X_train <- read.table(paste(dirName, "train", "X_train.txt", sep='/'))
y_train <- read.table(paste(dirName, "train", "y_train.txt", sep='/'))
subject_train <- read.table(paste(dirName, "train", "subject_train.txt", sep='/'))

## Setting the X_train column names
names(X_train) <- features
 
## Extract only the measurements on the mean and standard deviation for each measurement.
X_train <- X_train[,extractedFeatures]

## Load activity data
y_train[,2] <- activity_labels[y_train[,1]]
names(y_train) <- c("Activity_ID", "Activity_Label")
names(subject_train) <- "subject"

## Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)
message("The test_data has been bounded.")



## Merge test and train data
data <- rbind(test_data, train_data)
message("The test_data and train_data have been bounded into data.")

## Write data into tidyData.txt
write.table(data, file="./tidyData.txt", row.names=F)
message("writing data into tidyData.txt DONE.")



## Melting and dcasting data based on subjects and activities
id_labels <- c("subject", "Activity_ID", "Activity_Label")
measure_labels <- setdiff(colnames(data), id_labels)
melt_data <- melt(data, id = id_labels, measure.vars = measure_labels)
 
## Apply mean function to dataset using dcast function
tidy_data <- dcast(melt_data, subject + Activity_Label ~ variable, mean)
 
## Write tidy_data into tidyData_mean.txt
write.table(tidy_data, file = "./tidyData_mean.txt", row.names=F)
message("writing tidy_data into tidyData_mean.txt DONE.")
