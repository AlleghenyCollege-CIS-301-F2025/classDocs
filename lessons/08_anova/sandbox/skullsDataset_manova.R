# Manova demo using Skulls dataset.

# Add Your Name Here

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

if(!require('HSAUR2')) {
  install.packages('HSAUR2')
  library('HSAUR2')
}

# The skulls data concerns measurements made on Egyptian skulls from five epochs.
# ?skulls

data("skulls") # use this data set for proceeding code
names(skulls) # get the variables
summary(skulls) # summary of the data

##################################
# Plotting to visualize the means.
##################################

# Steps take in the below code
# + Load the skulls dataset.
# + Calculate the means of each column grouped by epoch.
# + Create a plot to visualize the means.

# Calculate the means of each column by epoch
means_by_epoch <- skulls %>%
  group_by(epoch) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))
# across(): we apply the function to multiple cols

# Reshape the data for plotting
means_long <- means_by_epoch %>%
  pivot_longer(cols = -epoch, names_to = "measurement", values_to = "mean_value")

# Create the plot
ggplot(means_long, aes(x = epoch, y = mean_value, fill = measurement)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Mean Values of Skull Measurements by Epoch",
       x = "Epoch",
       y = "Mean Value") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

##################################
# Add manova code below
##################################

skulls.manova1 <- manova(cbind(mb, bh, bl, nh) ~ as.factor(epoch), data = skulls)

summary(skulls.manova1, test = "Hotelling-Lawley")
summary(skulls.manova1, test = "Roy")

summary(skulls.manova1, test = "Pillai")

summary(skulls.manova1, test = "Wilks")

summary.aov(skulls.manova1)
cat("summary of aov")



skulls.manova2 <- manova(cbind(mb, bh, bl, nh) ~ as.factor(epoch), data = skulls, subset = as.factor(epoch) %in% c("c4000BC", "c200BC"))
summary(skulls.manova2)

summary(skulls.manova2, test = "Hotelling-Lawley")
summary(skulls.manova2, test = "Roy")

summary(skulls.manova2, test = "Pillai")

summary(skulls.manova2, test = "Wilks")

summary.aov(skulls.manova2)