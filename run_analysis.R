#get data, set working directory and unzip files
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "./Getting and Cleaning Data Course Project")
unzip("Getting and Cleaning Data Course Project")
setwd("./UCI HAR Dataset")
library(data.table)

#Reading data into R and labelling columns to prepare for merging, sorting and formatting later
subject_test<-read.table("./test/subject_test.txt")
x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")
subject_train<-read.table("./train/subject_train")
subject_train<-read.table("./train/subject_train.txt")
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")
activity_names<-read.table("activity_labels.txt")

#read in feature names and name columns with the features outlined in features.txt
feature_names<-read.table("./features.txt")
names(x_test)<-feature_names$V2
names(x_train)<-feature_names$V2
names(subject_train)<-"Subject"
names(subject_test)<-"Subject"
names(y_train)<-"activity"
names(y_test)<-"activity"

#merging test and train data, compiling into one dataset
train_data<-cbind(subject_train, x_train, y_train)
test_data<-cbind(subject_test, x_test, y_test)
all_data<-rbind(train_data, test_data)

#extract only mean and standard deviation measurements
mean_col<-all_data[, grep("mean", names(all_data))]
std_col<-all_data[, grep("std", names(all_data))]
subject_id_col<-all_data[, 1]
cbind(subject_id, mean_col, std_col)
mean_std_data<-cbind(subject_id_col, mean_col, std_col)

#label activities based on activity_names
all_data$activity[all_data$activity==1]="WALKING"
all_data$activity[all_data$activity==2]="WALKING_UPSTAIRS"
all_data$activity[all_data$activity==3]="WALKING_DOWNSTAIRS"
all_data$activity[all_data$activity==4]="SITTING"
all_data$activity[all_data$activity==5]="STANDING"
all_data$activity[all_data$activity==6]="LAYING"

#create more descriptive variable names
colNameAllData<-colnames(all_data)> colNameAllData<-gsub("^t", "timeDomain", colNameAllData)
colNameAllData<-gsub("^f", "frequencyDomain", colNameAllData)
colNameAllData<-gsub("std()", "standardDeviation", colNameAllData)
colNameAllData<-gsub("mean()", "mean", colNameAllData)
colNameAllData<-gsub("mad()", "medianAbsoluteDeviation", colNameAllData)
colNameAllData<-gsub("max()", "maximumArrayValue", colNameAllData)
colNameAllData<-gsub("min()", "minimumArrayValue", colNameAllData)
colNameAllData<-gsub("sma()", "signalMagnitudeArea", colNameAllData)
colNameAllData<-gsub("energy()", "energyMeasure", colNameAllData)
colNameAllData<-gsub("iqr()", "interquartileRange", colNameAllData)
colNameAllData<-gsub("entropy()", "signalEntropy", colNameAllData)
colNameAllData<-gsub("arCoeff()", "autorregresionCoefficient", colNameAllData)
colNameAllData<-gsub("correlation()", "correlation", colNameAllData)
colNameAllData<-gsub("maxInds()", "largestMagnitudeFrequency", colNameAllData)
colNameAllData<-gsub("meanFreq()", "meanFrequency", colNameAllData)
colNameAllData<-gsub("skewness()", "skewness", colNameAllData)
colNameAllData<-gsub("kurtosis()", "kurtosis", colNameAllData)
colNameAllData<-gsub("bandsEnergy()", "frequencyIntervalEnergy", colNameAllData)
colNameAllData<-gsub("angle()", "angle", colNameAllData)
colNameAllData<-gsub("Acc", "Accelerometer", colNameAllData)
colNameAllData<-gsub("Gyro", "Gyroscope", colNameAllData)
colNameAllData<-gsub("Mag", "Magnitude", colNameAllData)
colNameAllData<-gsub("BodyBody", "Body", colNameAllData)
colnames(all_data)<-colNameAllData

#creating the final tidy dataset
tidyData<-all_data #creating a copy of all_data to manipulate 
tidyData<-melt(tidyData, id.vars=c("Subject", "activity")) #melt data down by subject/activity
tidyData<-dcast(tidyData, Subject+activity~variable, fun.aggregate = mean) #recombine by taking means 
write.table(tidyData, file="tidyData.txt", row.names = FALSE)