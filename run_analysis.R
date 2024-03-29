library(plyr)

# Step 1
# Merge  training and test sets to create single data set


x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

# Step 2
# Extract only measurements on mean and sd for each measurement

features <- read.table("features.txt")

# get only columns with mean() or std() in their names

mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset desired columns
x_data <- x_data[, mean_and_std_features]

# correct column names
names(x_data) <- features[mean_and_std_features, 2]

# Step 3
# Use descriptive activity names to name activities in data set

activities <- read.table("activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Step 4
# Appropriately label data set with descriptive variable names


# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# Step 5
# Create a second, independent tidy data set with means of each variable
# for each activity and each subject


# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)