#read the test, training, subject, and activity data into R
features <- read.table("~/Data Science/UCI HAR Dataset/features.txt", quote="\"", comment.char="")

subject_train <- read.table("~/Data Science/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
y_train <- read.table("~/Data Science/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
X_train <- read.table("~/Data Science/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
activity_labels <- read.table("~/Data Science/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
subject_test <- read.table("~/Data Science/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
y_test <- read.table("~/Data Science/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
X_test <- read.table("~/Data Science/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")

#rename the columns of data
colnames(X_train)<-features$V2
colnames(X_test)<-features$V2
names(subject_test)[names(subject_test)=="V1"]<-"subject"
names(subject_train)[names(subject_train)=="V1"]<-"subject"
names(y_test)[names(y_test)=="V1"]<-"activity"
names(y_train)[names(y_train)=="V1"]<-"activity"

#merge subject, activity, and measurement data
test<-cbind(subject_test,X_test,y_test)
train<-cbind(subject_train,X_train,y_train)

#append training data to test data
whole<-rbind(test,train)

#label activities in complete dataset
whole$activity<-factor(whole$activity,levels=activity_labels$V1, labels=activity_labels$V2)

#keep all the variables with "mean" and "std" in the name
sub<-c("mean()","sd()","activity","subject")
subset<-whole[,grepl(paste(sub, collapse='|'), colnames(whole))]

#take averages over activity and subject
product<-aggregate(subset[, 1:46], list(subset$subject, subset$activity), mean)

#create dataset for submission
write.table(product, row.names = F, file = "assignment.txt")

product
