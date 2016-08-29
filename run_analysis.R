#creates a file ./data if it does not already exist
if(!file.exists("./data")){dir.create("./data")}
#downloads the hml file
FileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(FileURL, destfile = "./data/UCI HAR Dataset.zip")
unzip("./data/UCI HAR Dataset.zip")

#reads all the data tables and assigns them to variables
X_Train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_Train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
X_Test <- read.table("./data/UCI HAR Dataset/test/X_Test.txt")
Y_Test <- read.table("./data/UCI HAR Dataset/test/Y_Test.txt")
Activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
Features <- read.table("./data/UCI HAR Dataset/features.txt")[,2]
Subject_Train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
Subject_Test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#combine data into one dataset
activityData <- rbind(Y_Train, Y_Test)
SubjectData <- rbind(Subject_Train,Subject_Test)
featuresData <- rbind(X_Train,X_Test)


## creates appropriate titles for the data
names(activityData) = "Activity_ID"
names(featuresData) = Features
names(SubjectData) = "subject"
combine1 <- cbind(SubjectData, activityData)
myData <- cbind(combine1, featuresData)
myData$Activity_ID <- as.character(myData$Activity_ID)
for(i in 1:6){
  myData$Activity_ID[myData$Activity_ID == i] <- as.character(Activities[i,2])
}

#Extracts only the mean and standard deviation
Extract <- grepl("mean|std|subject|Activity_ID",names(myData))
myData2 <- myData[,Extract]

#lables the data set with descriptiove variable names
names(myData2) <- gsub("^t","time",names(myData2))
names(myData2) <- gsub("^f","frequency", names(myData2))
names(myData2) <- gsub("Acc", "Accelerometer", names(myData2))
names(myData2) <- gsub("Gyro", "Gyroscope", names(myData2))
names(myData2) <- gsub("Mag", "Magnitude", names(myData2))
names(myData2) <- gsub("BodyBody", "Body", names(myData2))


#creates a second tiny data set with the average of each variable for each activity and subject
library(plyr)
myData3 <- aggregate(.~subject +Activity_ID,myData2,mean)
myData3 <- myData3[order(myData3$subject,myData3$Activity_ID),]
write.table(myData3, file = "tidydata.txt", row.names = FALSE)

View(mydata3)