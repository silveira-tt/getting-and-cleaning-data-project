##########################################################################################
## You should create one R script called run_analysis.R that does the following.
#
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement.
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names.
#5.From the data set in step 4, creates a second, independent tidy data set with the 
#  average of each variable for each activity and each subject.
##########################################################################################

library(reshape2)
library(dplyr)

#downloading package...
filename <- "dataset.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#reading files...
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

#...renaming and adjusting...
featuresIndexMeanOrStd <- grep("*mean*|*std*", features$V2)
featuresIndexMeanOrStd.name <- features[featuresIndexMeanOrStd, 2]
featuresIndexMeanOrStd.name <- gsub("-mean", "Mean", featuresIndexMeanOrStd.name)
featuresIndexMeanOrStd.name <- gsub("-std", "Std", featuresIndexMeanOrStd.name)
featuresIndexMeanOrStd.name <- gsub("\\(\\)", "", featuresIndexMeanOrStd.name)
featuresIndexMeanOrStd.name <- gsub("-", "", featuresIndexMeanOrStd.name)

#continuing...
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresIndexMeanOrStd]
trainActivities <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresIndexMeanOrStd]
testActivities <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

#bringing up coluns
train <- bind_cols(trainActivities, trainSubjects, train)
test  <- bind_cols(testActivities,  testSubjects,  test)

#merging datasets
merged_data <- bind_rows(train, test)
colnames(merged_data) <- c("Activity", "Subject", featuresIndexMeanOrStd.name)
merged_data <- tbl_df(merged_data)

#creating a dataset with the mean of of each variable for each activity and each subject
merged_data$Activity <- factor(merged_data$Activity, levels = activityLabels$V1, labels = activityLabels$V2)
merged_data$Subject  <- factor(merged_data$Subject)

merged_data.melted <-melt(merged_data, id = c("Subject", "Activity"))
merged_data.meanBySubjAndActi   <-dcast(merged_data.melted, Subject + Activity ~ variable, mean)

#saving new file
write.table(merged_data.meanBySubjAndActi, "independent_tidy.txt", row.names = F, quote = F)
