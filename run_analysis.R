# Load required packages
library(dplyr)

# Step 1: Download and unzip the dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "UCI_HAR_Dataset.zip", mode = "wb")
unzip("UCI_HAR_Dataset.zip")

# Step 2: Read in the data
# Load training data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Load testing data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Step 3: Read activity labels and feature names
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

# Step 4: Merge training and testing datasets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Step 5: Extract mean and standard deviation measurements
mean_std_features <- grep("mean\\(\\)|std\\(\\)", features[, 2])
x_data <- x_data[, mean_std_features]

# Step 6: Name the activities
y_data[, 1] <- activity_labels[y_data[, 1], 2]

# Step 7: Label the datasets with descriptive variable names
names(x_data) <- features[mean_std_features, 2]
names(subject_data) <- "subject"
names(y_data) <- "activity"

# Step 8: Create a tidy dataset
tidy_data <- cbind(subject_data, y_data, x_data)
tidy_data <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean))

# Step 9: Write the tidy dataset to a file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)

