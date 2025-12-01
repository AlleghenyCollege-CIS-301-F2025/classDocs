# Neural Networks: Demos

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console


if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}

# Essential packages for Neural Networks in R
#install.packages(c(
#  "neuralnet",    # Neural network implementation
#  "nnet",         # Feed-forward neural networks
#  "tidyverse",    # Data manipulation & visualization
#  "caret"         # Machine learning tools
#))

# Load the libraries
library(neuralnet)
library(nnet)
library(caret)


# Create XOR dataset
xor_data <- data.frame(
  X1 = c(0, 0, 1, 1),
  X2 = c(0, 1, 0, 1),
  Y = c(0, 1, 1, 0)
)

cat("XOR Training Data:\n")

print(xor_data)

# Build neural network
set.seed(123)
xor_nn <- neuralnet(
  Y ~ X1 + X2,
  data = xor_data,
  hidden = 2,              # 2 neurons in hidden layer
  linear.output = FALSE,   # Use activation function
  threshold = 0.01,        # Training threshold
  stepmax = 1e6            # Max iterations
)

cat("\nTraining completed!\n")
cat("Error:", xor_nn$result.matrix[1], "\n")

# Plot the neural network structure
plot(xor_nn, 
     rep = "best",
     main = "XOR Neural Network")

# Test the network
predictions <- predict(xor_nn, xor_data[, c("X1", "X2")])

# Round to binary output
results <- data.frame(
  X1 = xor_data$X1,
  X2 = xor_data$X2,
  Actual = xor_data$Y,
  Predicted = round(predictions, 3),
  Binary = round(predictions)
)

cat("\nPredictions:\n")
print(results)
# Calculate accuracy
accuracy <- sum(results$Actual == results$Binary) / nrow(results)
cat("\nAccuracy:", accuracy * 100, "%\n")



#######
# iris
#######

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

# Load and prepare iris dataset
data(iris)

# Explore the data
cat("Iris Dataset Structure:\n")
str(iris)
cat("\nSpecies Distribution:\n")
table(iris$Species)

cat("\nFirst few rows:\n")
head(iris)


# Normalize features (important for neural networks!)
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

iris_normalized <- iris %>%
  mutate(across(1:4, normalize))

# Create dummy variables for species
iris_data <- iris_normalized %>%
  mutate(
    setosa = ifelse(Species == "setosa", 1, 0),
    versicolor = ifelse(Species == "versicolor", 1, 0),
    virginica = ifelse(Species == "virginica", 1, 0)
  )

# Split into train (80%) and test (20%)
set.seed(123)
train_idx <- sample(1:nrow(iris_data), 0.8 * nrow(iris_data))
train_data <- iris_data[train_idx, ]
test_data <- iris_data[-train_idx, ]

cat("Training samples:", nrow(train_data), "\n")
cat("Testing samples:", nrow(test_data), "\n")
# Build neural network for iris classification
iris_nn <- neuralnet(
  setosa + versicolor + virginica ~ 
    Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,
  data = train_data,
  hidden = c(5, 3),        # Two hidden layers: 5 and 3 neurons
  linear.output = FALSE,
  threshold = 0.01,
  stepmax = 1e6
)

cat("Training completed!\n")


cat("Error:", iris_nn$result.matrix[1], "\n")

# Plot the network
plot(iris_nn, 
     rep = "best",
     main = "Iris Classification Neural Network")


# Make predictions on test set
predictions <- predict(iris_nn, test_data)

# Convert predictions to species names
predicted_species <- apply(predictions, 1, which.max)
predicted_species <- c("setosa", "versicolor", "virginica")[predicted_species]

# Actual species
actual_species <- test_data$Species

# Create results table
results <- data.frame(
  Actual = actual_species,
  Predicted = predicted_species,
  Correct = actual_species == predicted_species
)

# Display sample results
cat("\nSample Predictions:\n")
print(head(results, 15))


# Calculate accuracy
accuracy <- sum(results$Correct) / nrow(results)
cat("\nTest Accuracy:", round(accuracy * 100, 2), "%\n")

# Confusion matrix
cat("\nConfusion Matrix:\n")
print(table(Actual = actual_species, Predicted = predicted_species))

