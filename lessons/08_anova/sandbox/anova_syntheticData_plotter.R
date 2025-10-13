rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

#library(tidyverse)
# A better way to code...
# Find out if the library is not already installed and\
# if not, install the library and then load it.

if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}

# Set seed for reproducibility
set.seed(123)

# Generate synthetic data
group1 <- rnorm(30, mean = 5, sd = 1)
group2 <- rnorm(30, mean = 7, sd = 1)
group3 <- rnorm(30, mean = 6, sd = 1)

# Combine into a data frame
data <- data.frame(
  value = c(group1, group2, group3),
  group = factor(rep(c("Group 1", "Group 2", "Group 3"), each = 30))
)

# Perform ANOVA
anova_result <- aov(value ~ group, data = data)

# Display the summary of the ANOVA
summary(anova_result)

# Create boxplot
ggplot(data, aes(x = group, y = value)) +
  geom_boxplot(fill = c("lightblue", "lightgreen", "lightcoral")) +
  theme_minimal() +
  labs(title = "Boxplot of Values by Group",
       x = "Group",
       y = "Value")
