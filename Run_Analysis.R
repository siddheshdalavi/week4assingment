
# Clean up workspace
rm(list=ls())

#Create the Directory if not exists
getwd()
if(!file.exists("./data")){dir.create("./data")}
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile<-"./data/Dataset.zip"
download.file(fileurl,destfile)
date<-Sys.Date()

#unzipp the file
unzip(zipfile=destfile,exdir = "./data")

#Reading tables
# 1. Reading training tables
XTrain_table<-"./data/UCI HAR Dataset/train/X_train.txt"
YTrain_table<-"./data/UCI HAR Dataset/train/y_train.txt"
x_train<-read.table(XTrain_table,header=FALSE)
y_train<-read.table(YTrain_table,header=FALSE)
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt",header=FALSE)

#2.Reading test tables
XTest_table<-"./data/UCI HAR Dataset/test/X_test.txt"
YTest_table<-"./data/UCI HAR Dataset/test/y_test.txt"
x_test<-read.table(XTest_table,header=FALSE)
y_test<-read.table(YTest_table,header=FALSE)
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt",header=FALSE)

#3. Reading feature vector
features<-read.table("./data/UCI HAR Dataset/features.txt",header=FALSE)

#4. Reading activity labels:
activityLabels = read.table("./data/UCI HAR Dataset/activity_labels.txt",header=FALSE)

#Column names
colnames(x_train)<-features[,2]
colnames(y_train)<-"activityId"
colnames(subject_train)<-"subjectId"

colnames(x_test)<-features[,2]
colnames(y_test)<-"activityId"
colnames(subject_test)<-"subjectId"

colnames(activityLabels)<- c('activityId','activityType')

#merge tables
mrg_train<-cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
#subject_data <- cbind(subject_train, subject_test)
completeMerge<-rbind(mrg_train, mrg_test)

#column names of merged data
colnames<-colnames(completeMerge)

#create vector for ID,mean & STD
mean_std<-(grepl("activityId",colnames)
           |grepl("subjectId",colnames)
           |grepl("mean..",colnames)
           |grepl("std..",colnames))

setForMeanAndStd <- completeMerge[ , mean_std == TRUE]

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
