library(dplyr)
  #1. Creating list of files
listD<-list.dirs("./data/UCI HAR Dataset")
listD<-listD[!grepl("Inertial Signals",listD)]
listF<-unlist(sapply(listD, list.files,full.names = TRUE))
listF<-listF[grep("txt$",listF)]
  #2. Loadind files into R
listN<-gsub("\\.(.*)","",gsub("(.*)/","",listF))
for (i in 1:length(listF)) {
    assign(listN[i], try(read.table(listF[i]),silent = TRUE))
}
  #3. Merges the training and the test sets to create one data set
DSet<-rbind(X_test,X_train)
  #4. Extracts only the measurements on the mean and standard deviation for each measurement
namesL<-grepl("mean|std",features[,2])&!grepl("meanFreq",features[,2])
n<-seq_along(namesL)[namesL]
DSet<-DSet[,n]
  #5. Uses descriptive activity names to name the activities in the data set
Activity<-merge(rbind(y_test,y_train),activity_labels)[,2]
Subject<-rbind(subject_test,subject_train)
names(Subject)<-"Subject"
  #6. Appropriately labels the data set with descriptive variable names
names(DSet)<-features[,2][namesL]
DSet<-cbind(Subject,Activity,DSet)
  #7. Create a second, independent tidy data set with the average of each variable for each activity and each subject
DSet%>%group_by(Subject,Activity)%>%summarise_all(mean)->MeanCleanDSet
