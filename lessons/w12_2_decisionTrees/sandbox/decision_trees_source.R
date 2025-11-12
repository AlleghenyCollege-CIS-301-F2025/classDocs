# ============================================
# DECISION TREES IN R - INSTRUCTOR SOURCE CODE
# ============================================
# This file contains all executable R code from the slides
# for easy running in class demonstrations
# Date: November 11, 2025
# ============================================

# ============================================
# SECTION 1: SETUP AND LIBRARY LOADING
# ============================================

# Clear the environment for a fresh start
rm(list = ls())
graphics.off()

# Smart loading: Install if missing, then load rpart
if(!require('rpart')) {
  install.packages('rpart')
  library('rpart')
}

# Smart loading: Install if missing, then load rpart.plot
if(!require('rpart.plot')) {
  install.packages('rpart.plot')
  library('rpart.plot')
}

# Smart loading: Install if missing, then load tidyverse
if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}

# Load titanic dataset
if(!require('titanic')) {
  install.packages('titanic')
  library('titanic')
}

# ============================================
# SECTION 2: SIMPLE ANIMAL CLASSIFICATION EXAMPLE
# ============================================

# Create sample animal dataset
set.seed(42)
animals <- data.frame(
  size = c("small", "medium", "large", "small", "medium", "small", 
           "large", "small", "medium", "large", "small", "medium"),
  color = c("brown", "black", "white", "gray", "brown", "white",
            "black", "gray", "brown", "white", "orange", "black"),
  type = c("cat", "dog", "dog", "rabbit", "dog", "bird",
           "dog", "rabbit", "cat", "dog", "cat", "dog")
)

# Display first few rows
head(animals, 6)

# Build decision tree
animal_model1 <- rpart(type ~ color, data = animals, method = "class")
# Display model summary
print(animal_model1)

# Visualize the tree
rpart.plot(animal_model1, 
           main = "Animal Classification Tree",
           extra = 104,  # Show probabilities
           fallen.leaves = TRUE,
           box.palette = "GnBu")




# Build decision tree
animal_model <- rpart(type ~ size + color, data = animals, method = "class")

# Display model summary
print(animal_model)

# Visualize the tree
rpart.plot(animal_model, 
           main = "Animal Classification Tree",
           extra = 104,  # Show probabilities
           fallen.leaves = TRUE,
           box.palette = "GnBu")

# ============================================
# SECTION 3: TITANIC SURVIVAL PREDICTION
# ============================================

# Load and explore Titanic data
data("titanic_train")
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
           main = "Titanic Survival Prediction Tree",
           extra = 104,
           box.palette = "RdYlGn",
           shadow.col = "gray",
           fallen.leaves = TRUE)

# ============================================
# SECTION 4: MODEL PERFORMANCE EVALUATION
# ============================================

# Get predictions
predictions <- predict(titanic_model, titanic_data, type = "class")

# Create confusion matrix
confusion_matrix <- table(Actual = titanic_data$Survived, 
                          Predicted = predictions)
print(confusion_matrix)

# Calculate accuracy
accuracy <- sum(diag(confusion_matrix)) / sum(confusion_matrix)
cat("\nModel Accuracy:", round(accuracy * 100, 2), "%\n")

# Calculate additional metrics
precision <- confusion_matrix[2,2] / sum(confusion_matrix[,2])
recall <- confusion_matrix[2,2] / sum(confusion_matrix[2,])
cat("Precision:", round(precision * 100, 2), "%\n")
cat("Recall:", round(recall * 100, 2), "%\n")

# ============================================
# SECTION 5: TUNING - COMPARING TREE COMPLEXITIES
# ============================================

# Build trees with different settings
tree_default <- rpart(Survived ~ Pclass + Sex + Age, 
                      data = titanic_data, method = "class")

tree_complex <- rpart(Survived ~ Pclass + Sex + Age, 
                      data = titanic_data, method = "class",
                      control = rpart.control(cp = 0.001))

tree_simple <- rpart(Survived ~ Pclass + Sex + Age, 
                     data = titanic_data, method = "class",
                     control = rpart.control(cp = 0.05))

# Visualize default tree
rpart.plot(tree_default, main = "Default Settings", box.palette = "Blues")

# Visualize complex tree
rpart.plot(tree_complex, main = "More Complex (cp=0.001)", box.palette = "Greens")

# Visualize simple tree
rpart.plot(tree_simple, main = "Simpler (cp=0.05)", box.palette = "Oranges")

# ============================================
# SECTION 6: MEDICAL EXAMPLE - KYPHOSIS DATASET
# ============================================

# Load built-in kyphosis dataset
data(kyphosis)
head(kyphosis, 6)

# Build decision tree for kyphosis
kyphosis_model <- rpart(Kyphosis ~ Age + Number + Start, 
                        data = kyphosis,
                        method = "class")

# Display model structure
print(kyphosis_model)

# Visualize
rpart.plot(kyphosis_model,
           main = "Kyphosis Prediction Tree",
           extra = 104,
           box.palette = "Purples",
           fallen.leaves = TRUE)

# ============================================
# SECTION 7: VARIABLE IMPORTANCE ANALYSIS
# ============================================

# Get variable importance for Titanic model
importance <- titanic_model$variable.importance
importance_df <- data.frame(
  Variable = names(importance),
  Importance = importance
) %>% arrange(desc(Importance))

print(importance_df)

# Visualize variable importance
ggplot(importance_df, aes(x = reorder(Variable, Importance), y = Importance)) +
  geom_col(fill = "steelblue", alpha = 0.8) +
  coord_flip() +
  labs(title = "Feature Importance in Titanic Model",
       x = "Variable", y = "Importance Score") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14))

# ============================================
# SECTION 8: ADVANCED VISUALIZATION
# ============================================

# Create a fancy tree
rpart.plot(titanic_model,
           type = 4,
           extra = 106,
           box.palette = "RdYlGn",
           branch.lty = 3,
           shadow.col = "gray",
           nn = TRUE,
           fallen.leaves = TRUE,
           main = "Beautifully Styled Titanic Tree",
           tweak = 1.2)

# ============================================
# SECTION 9: COMPARING MULTIPLE MODELS
# ============================================

# Create three models with different parameters
model1 <- rpart(Kyphosis ~ Start, data = kyphosis)
model2 <- rpart(Kyphosis ~ Start, data = kyphosis,
                parms = list(prior = c(.65, .35), split = "information"))
model3 <- rpart(Kyphosis ~ Start, data = kyphosis,
                control = rpart.control(cp = 0.05))

# Visualize model 1
rpart.plot(model1, main = "Model 1: Default", box.palette = "Blues")

# Visualize model 2
rpart.plot(model2, main = "Model 2: Prior Probabilities", box.palette = "Greens")

# Visualize model 3
rpart.plot(model3, main = "Model 3: Higher CP", box.palette = "Oranges")

# ============================================
# SECTION 10: MAKING PREDICTIONS
# ============================================

# Create new patient data
new_patients <- data.frame(
  Age = c(50, 120, 80),
  Number = c(3, 5, 4),
  Start = c(5, 12, 9)
)

# Make predictions
predictions_kyphosis <- predict(kyphosis_model, new_patients, type = "class")
probabilities <- predict(kyphosis_model, new_patients, type = "prob")

# Display results
results <- cbind(new_patients, 
                 Prediction = predictions_kyphosis,
                 Prob_Absent = round(probabilities[, 1], 3),
                 Prob_Present = round(probabilities[, 2], 3))
print(results)

# ============================================
# SECTION 11: CUSTOM DEMO - STUDENT PERFORMANCE
# ============================================

# Create your own classification problem
set.seed(123)
custom_data <- data.frame(
  study_hours = sample(1:10, 100, replace = TRUE),
  attendance = sample(60:100, 100, replace = TRUE),
  assignments = sample(0:10, 100, replace = TRUE),
  grade = sample(c("Pass", "Fail"), 100, replace = TRUE, 
                 prob = c(0.7, 0.3))
)

# Build tree
student_model <- rpart(grade ~ study_hours + attendance + assignments,
                       data = custom_data, method = "class")

# Visualize
rpart.plot(student_model,
           main = "Student Performance Predictor",
           box.palette = "GnBu",
           extra = 104)

# ============================================
# SECTION 12: PRUNING - PREVENTING OVERFITTING
# ============================================

# Build a complex tree
complex_tree <- rpart(Survived ~ ., data = titanic_data, 
                      control = rpart.control(cp = 0.001))

# Check complexity parameter table
printcp(complex_tree)

# Find optimal CP
optimal_cp <- complex_tree$cptable[which.min(complex_tree$cptable[,"xerror"]),"CP"]

# Prune the tree
pruned_tree <- prune(complex_tree, cp = optimal_cp)

# Visualize before pruning
rpart.plot(complex_tree, main = "Before Pruning", box.palette = "Reds")

# Visualize after pruning
rpart.plot(pruned_tree, main = "After Pruning", box.palette = "Greens")

# ============================================
# SECTION 13: FUN EXAMPLE - GAME CHARACTERS
# ============================================

# Create game character data
set.seed(456)
game_chars <- data.frame(
  strength = sample(1:100, 50, replace = TRUE),
  magic = sample(1:100, 50, replace = TRUE),
  speed = sample(1:100, 50, replace = TRUE),
  class = sample(c("Warrior", "Mage", "Rogue", "Paladin"), 
                 50, replace = TRUE)
)

# Build classifier
game_model <- rpart(class ~ strength + magic + speed,
                    data = game_chars, method = "class")

# Visualize
rpart.plot(game_model,
           main = "Game Character Class Predictor",
           box.palette = "RdPu",
           extra = 104,
           fallen.leaves = TRUE)

# ============================================
# SECTION 14: COMPARING SPLIT METHODS
# ============================================

# Different splitting criteria
model_gini <- rpart(Survived ~ Sex + Pclass, data = titanic_data,
                    parms = list(split = "gini"))
model_info <- rpart(Survived ~ Sex + Pclass, data = titanic_data,
                    parms = list(split = "information"))

# Visualize Gini split
rpart.plot(model_gini, main = "Gini Index", box.palette = "Blues")

# Visualize Information Gain split
rpart.plot(model_info, main = "Information Gain", box.palette = "Greens")

# ============================================
# SECTION 15: CUSTOMIZATION GALLERY
# ============================================

# Create a simple model for demo
simple_model <- rpart(Survived ~ Sex + Pclass, data = titanic_data, method = "class")

# Classic Gray Style
rpart.plot(simple_model, box.palette = "Grays", main = "Classic Gray")

# Traffic Light Style
rpart.plot(simple_model, box.palette = "RdYlGn", main = "Traffic Light")

# Minimal Blue Style
rpart.plot(simple_model, box.palette = "Blues", type = 2, main = "Minimal Blue")

# Detailed Orange Style
rpart.plot(simple_model, box.palette = "Oranges", extra = 104, main = "Detailed Orange")

# ============================================
# SECTION 16: DEBUGGING YOUR TREES
# ============================================

# Diagnostic commands
model <- rpart(Survived ~ ., data = titanic_data)

# 1. Check tree structure
print(model)

# 2. View variable importance
model$variable.importance

# 3. Check complexity parameter table
printcp(model)

# 4. Plot cross-validation error
plotcp(model)

# ============================================
# SECTION 17: COMPLETE WORKFLOW EXAMPLE
# ============================================

# 1. Load libraries (already done above)

# 2. Load and prepare data
data(titanic_train, package = "titanic")
df <- titanic_train %>% select(Survived, Pclass, Sex, Age, Fare) %>% na.omit()

# 3. Split train/test
set.seed(42)
train_idx <- sample(1:nrow(df), 0.7 * nrow(df))
train <- df[train_idx, ]
test <- df[-train_idx, ]

# 4. Build model
model_workflow <- rpart(Survived ~ ., data = train, method = "class",
                        control = rpart.control(cp = 0.01))

# 5. Visualize
rpart.plot(model_workflow, main = "Titanic Survival Tree", box.palette = "RdYlGn")

# 6. Evaluate
pred <- predict(model_workflow, test, type = "class")
accuracy_test <- mean(pred == test$Survived)
cat("Test Accuracy:", round(accuracy_test * 100, 2), "%\n")

# 7. Prune if needed
pruned_workflow <- prune(model_workflow, cp = 0.02)
rpart.plot(pruned_workflow, main = "Pruned Tree")

# ============================================
# END OF INSTRUCTOR SOURCE CODE
# ============================================

cat("\n\n===========================================\n")
cat("All code blocks executed successfully!\n")
cat("===========================================\n")
