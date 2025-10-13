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


if(!require('psych')) {
  install.packages('psych')
  library('psych')
}

# Load the iris dataset
data(iris)

# Conduct ANOVA
# We'll analyze how Petal.Length differs among the species of iris
anova_model <- aov(Petal.Length ~ Species, data = iris)
summary(anova_model)

# Visualize the results
# We can use a boxplot to visualize the petal lengths for each species:
ggplot(iris, aes(x = Species, y = Petal.Length)) +
  geom_boxplot(fill = "lightblue", outlier.colour = "red") +
  theme_minimal() +
  labs(title = "Boxplot of Petal Length by Species",
       x = "Species",
       y = "Petal Length") +
  stat_summary(fun = mean, geom = "point", shape = 3, size = 4, color = "black")


# Notes:
# ANOVA Summary: The summary will give you the F-statistic and p-value. A p-value less than 0.05 indicates significant differences among species.
# Boxplot: This visualization helps show the distribution of petal lengths across species, making it easier to see where the differences lie.
