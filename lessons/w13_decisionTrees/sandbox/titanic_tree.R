# Clear the environment for a fresh start
rm(list = ls())
graphics.off()
cat("\014") # clear the console

library(rpart)
library(rpart.plot)
library(titanic)
library(tidyverse)

# Load and explore Titanic data
data("titanic_train")
titanic_train$Survived <- as.factor(ifelse(titanic_train$Survived==0, "Died", "Survived"))
titanic_data <- titanic_train %>%
  select(Survived, Pclass, Sex, Age, Fare, SibSp, Parch) %>%
  na.omit()  # Remove missing values for simplicity

# Quick look at the data
glimpse(titanic_data)

# Summary statistics
cat("\nTotal observations:", nrow(titanic_data), "\n")
cat("Survival rate:", round(mean(titanic_data$Survived) * 100, 1), "%\n")

# Build decision tree for Titanic survival
titanic_model <- rpart(
  Survived ~ Pclass + Sex + Age + Fare + SibSp + Parch,
  data = titanic_data,
  method = "class",
  control = rpart.control(cp = 0.02)  # Complexity parameter
)

# Display model summary
print(titanic_model)


# Visualize the tree
rpart.plot(titanic_model,
           main = "🚢 Titanic Survival Prediction Tree",
           extra = 104,
           box.palette = "RdYlGn",
           shadow.col = "gray",
           fallen.leaves = TRUE)


# Get predictions
predictions <- predict(titanic_model, titanic_data, type = "class")

# Create confusion matrix
confusion_matrix <- table(Actual = titanic_data$Survived, 
                          Predicted = predictions)
print(confusion_matrix)

# Calculate additional metrics
precision <- confusion_matrix[2,2] / sum(confusion_matrix[,2])
recall <- confusion_matrix[2,2] / sum(confusion_matrix[2,])
cat("Precision:", round(precision * 100, 2), "%\n")
cat("Recall:", round(recall * 100, 2), "%\n")




