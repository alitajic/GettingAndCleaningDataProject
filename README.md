##GettingAndCleaningDataProject


###Course Project
You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###Steps to work on this course project
1. Put "run_analysis.R" in your working directory.
2. Run source("run_analysis.R"). It will downlowd the zip data file from the web, unzip the data into directory "Data", 
   and delete the ziped data file. Then, it will execute the code to generate two new files  "tidyData.txt" and "tidyData_mean.txt" in 
   your working directory.
   
###Dependencies
"run_analysis.R" file will help you to install the dependencies automatically. It depends on reshape2 and data.table.