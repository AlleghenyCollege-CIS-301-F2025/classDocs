# Clear the environment for a fresh start
rm(list = ls())
graphics.off()
cat("\014") # clear the console

library(rpart)
library(rpart.plot)

# Create expanded animal dataset with more samples
set.seed(42)
animals <- data.frame(
  size = c("small", "medium", "large", "small", "medium", "small", 
           "large", "small", "medium", "large", "small", "medium",
           "small", "medium", "large", "small", "small", "medium",
           "large", "small", "medium", "large", "small", "medium",
           "small", "large", "medium", "small", "large", "medium"),
  color = c("brown", "black", "white", "gray", "brown", "white",
            "black", "gray", "brown", "white", "orange", "black",
            "orange", "brown", "black", "gray", "brown", "black",
            "white", "white", "brown", "black", "orange", "black",
            "gray", "white", "brown", "brown", "white", "black"),
  type = c("cat", "dog", "dog", "rabbit", "dog", "bird",
           "dog", "rabbit", "cat", "dog", "cat", "dog",
           "cat", "dog", "dog", "rabbit", "cat", "dog",
           "dog", "bird", "cat", "dog", "cat", "dog",
           "rabbit", "dog", "dog", "cat", "dog", "dog")
)

# Display dataset overview
cat("Dataset size:", nrow(animals), "animals\n")
cat("\nClass distribution:\n")
print(table(animals$type)) # numbers of each animal
cat("\nFirst few rows:\n")
head(animals, 6)

# Split into training (80%) and testing (20%) sets
# set.seed(42)
train_indices <- sample(1:nrow(animals), size = 0.8 * nrow(animals))
train_data <- animals[train_indices, ]
test_data <- animals[-train_indices, ]

cat("\nTraining set size:", nrow(train_data))
cat("\nTesting set size:", nrow(test_data), "\n")

# Build decision tree on training data
animal_model <- rpart(type ~ size + color, data = train_data, method = "class",
                     control = rpart.control(minsplit = 2, cp = 0.01))

# Display model summary
print(animal_model)

# Make predictions on test set
predictions <- predict(animal_model, test_data, type = "class")
cat("\n\nTest Set Predictions:\n")
comparison <- data.frame(
  Actual = test_data$type,
  Predicted = predictions,
  Size = test_data$size,
  Color = test_data$color
)
print(comparison)

# Calculate accuracy
accuracy <- sum(predictions == test_data$type) / nrow(test_data)
cat("\n\nTest Accuracy:", round(accuracy * 100, 2), "%\n")



# Visualize the tree
rpart.plot(animal_model, 
           main = "Animal Classification Tree",
           extra = 104,  # Show probabilities
           fallen.leaves = TRUE,
           box.palette = "GnBu")
