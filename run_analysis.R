#set working directory 
setwd("~/R/Coursera/get_clean_data/peer_assesment_assignment/processed_data")


#read in the data 
x_test<- read.table("./X_test.txt", header=FALSE,sep="")
y_test<- read.table("./y_test.txt", header=FALSE,sep="")
subject_test<-read.table("./subject_test.txt", header=FALSE,sep="")

x_train<- read.table("./X_train.txt", header=FALSE,sep="")
y_train<- read.table("./y_train.txt", header=FALSE,sep="")
subject_train<-read.table("./subject_train.txt", header=FALSE,sep="")

#merge the data 
test<-cbind(subject_test,y_test,x_test)
train<-cbind(subject_train,y_train,x_train)
test_train <-rbind(test,train)

#take a gander at the merged data
View(test_train)

#activities are coded 1:6, read in meaningful labels 
labels <- read.table("./activity_labels.txt",stringsAsFactors =FALSE, header=FALSE, sep="")

#Assign the descriptive labels - walking, running, etc - to the coded activities 1:6
for(i in 1:length(test_train[,2])){
  test_train[i,2]<-labels[test_train[i,2],2]
}

##read in the column names of the various data, or features.  
features <- read.table("./features.txt",stringsAsFactors =FALSE, header=FALSE, sep="")

#Assign descriptive column names
colnames(test_train) <- c("Subject", "Activity", "3:563" = features[,2] )
View(test_train)

#get the features containing mean and std 
mean_features <-grep("mean()",features[,2],fixed=TRUE)
std_features <-grep("std()",features[,2],fixed=TRUE)

#use the features names containing mean and std to get data data
mean_std_features <-c(mean_features,std_features)

#get just subject, activity, mean and std features
sub_act_test_train <- test_train[,mean_std_features]
View(sub_act_test_train)

#convert from wide to long data
sub_act_test_train_long <- melt(sub_act_test_train, id.vars = c("Subject", "Activity"))

#and to get the second independent data set
tidydata <-aggregate(sub_act_test_train[,c(3:ncol(sub_act_test_train))],
                     by=list(Subject=sub_act_test_train$Subject, Activity=sub_act_test_train$Activity),
                     FUN=mean, na.rm=TRUE)

