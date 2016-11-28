# read variable labels
activity_labels <- read.table("activity_labels.txt", quote="\"", comment.char="")
features <- read.table("features.txt", quote="\"", comment.char="")

# read training data
X_train <- read.table("train/X_train.txt", quote="\"", comment.char="")
colnames(X_train) <- features[,'V2'] # label variables
Y_train <- read.table("train/y_train.txt", quote="\"", comment.char="")
activity <- activity_labels[Y_train$V1,'V2'] # re-code activities with label string
subject <- read.table("train/subject_train.txt", quote="\"", comment.char="")
colnames(subject) <- "subject" # label variables

# merge training data
mergeDat_train <- cbind(subject,activity,X_train)

# read testing data
X_test <- read.table("test/X_test.txt", quote="\"", comment.char="")
colnames(X_test) <- features[,'V2'] # label variables
Y_test <- read.table("test/y_test.txt", quote="\"", comment.char="")
activity <- activity_labels[Y_test$V1,'V2'] # re-code activities with label string
subject <- read.table("test/subject_test.txt", quote="\"", comment.char="")
colnames(subject) <- "subject" # label variables

# merge testing data
mergeDat_test <- cbind(subject,activity,X_test)

# merge testing and training data together
spam <- rbind(mergeDat_train,mergeDat_test)
# reorder based on subject number
spam <- spam[,c(1,2,grep("\\bmean()\\b|\\bstd()\\b",features[,2])+2)]
order(spam[,1])
# get the average of each variable for each activity and each subject
foo <- aggregate(spam[, -(1:2)], 
                 list(Subject = spam$subject,
                      Activity = spam$activity),mean)
finished_result <- foo[order(foo[,1]),]

write.table(finished_result, file = "tidyData_ajones.txt", row.names = FALSE, col.names = TRUE)