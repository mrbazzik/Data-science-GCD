library(dplyr)

## read all necessary data from files
features_names <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt")
activity_labels <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt")

d_train <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
subjects_train <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt")
activities_train <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt")

d_test <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")
subjects_test <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")
activities_test <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt")

## 1. Merges the training and the test sets to create one data set
d_full<-rbind(d_train, d_test)

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
means_sds <- filter(features_names, grepl("mean\\(\\)|std\\(\\)",V2))
d_full<-d_full[,means_sds$V1]

##4. Appropriately labels the data set with descriptive variable names. 
names(d_full) <- means_sds$V2

## Adds subjects to dataset
d_full$Subject <- c(subjects_train$V1,subjects_test$V1)

## Adds activities to dataset
d_full$Activity <- c(activities_train$V1, activities_test$V1)
##3. Uses descriptive activity names to name the activities in the data set
d_full$Activity <- factor(d_full$Activity)
levels(d_full$Activity) <- levels(activity_labels$V2)

##4. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
d_full_grouped <- group_by(d_full, Activity, Subject)
d_full_grouped <- summarise_each(d_full_grouped, funs(mean))

write.table(d_full_grouped, file="tidy_dataset.txt", row.names=FALSE)
