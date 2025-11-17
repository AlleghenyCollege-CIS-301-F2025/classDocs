rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

library(rpart)
library(rpart.plot)

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
           main = "🎓 Student Performance Predictor",
           box.palette = "GnBu",
           extra = 104)

