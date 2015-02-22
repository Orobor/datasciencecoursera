# Working directory
setwd("C:/Users/iBOX/Documents/coursera")

# Path to data files
dir <- file.path("UCI HAR Dataset")

# Read data files
xTest  <- read.table(file.path(dir, "test/X_test.txt" ))
xTrain <- read.table(file.path(dir, "train/X_train.txt"))
yTest  <- read.table(file.path(dir, "test/Y_test.txt" ))
yTrain <- read.table(file.path(dir, "train/Y_train.txt"))
subjectTrain <- read.table(file.path(dir, "train/subject_train.txt"))
subjectTest  <- read.table(file.path(dir, "test/subject_test.txt"))
features<- read.table(file.path(dir, "features.txt"))
label <- read.table(file.path(dir, "activity_labels.txt"))

## 1. Merges the training and the test sets to create one data set

xTrainTest <- rbind(xTrain, xTest)
yTrainTest <- rbind(yTrain, yTest)
subjectTrainTest <- rbind(subjectTrain, subjectTest)

names(xTrainTest) <- features$V2
names(yTrainTest) <- c("activity")
names(subjectTrainTest) <- c("subject")

mergeTrainTest <- cbind(subjectTrainTest, yTrainTest, xTrainTest)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement

featureNames <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
extractedMeanSD <- subset(mergeTrainTest, select = c(as.character(featureNames), "subject", "activity" ))


## 3. Uses descriptive activity names to name the activities in the data set



## 4. Appropriately labels the data set with descriptive variable names

names(extractedMeanSD)<-sub("^t", "time", names(extractedMeanSD))
names(extractedMeanSD)<-sub("^f", "frequency", names(extractedMeanSD))
names(extractedMeanSD)<-sub("Acc", "Accelerometer", names(extractedMeanSD))
names(extractedMeanSD)<-sub("Gyro", "Gyroscope", names(extractedMeanSD))
names(extractedMeanSD)<-sub("Mag", "Magnitude", names(extractedMeanSD))
names(extractedMeanSD)<-sub("BodyBody", "Body", names(extractedMeanSD))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

tidyData <- aggregate(. ~subject + activity, extractedMeanSD, mean)
tidyData <- tidyData [order(tidyData$subject,tidyData$activity),]

write.table(tidyData, file = "tidydata.txt",row.name=FALSE)

