# Lung Capacity demo
# Correlation for all against all

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console


if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}

if(!require('psych')) {
  install.packages('psych')
  library('psych')
}


# Open lung capacity data
lc <-file.choose()

dataLungCap <- read.csv(lc, sep = ",", header = T)
View(dataLungCap)

# Model creation
mod <- lm(data = dataLungCap, LungCap ~ Age + Height)

# Get a report of the model
summary(mod)

# Plots
dataLungCap %>% ggplot(aes(x = Age, y = predict(mod))) + geom_point(alpha = I(1/4))

dataLungCap %>% ggplot(aes(x = Age, y = predict(mod))) + geom_point(alpha = I(1/4)) + geom_smooth()

dataLungCap %>% ggplot(aes(x = Age, y = predict(mod))) + geom_point(alpha = I(1/4)) + geom_smooth(method = lm)

# Correlation plots

## All against all correlation
pairs.panels(dataLungCap)

cor(dataLungCap$Age, dataLungCap$Height)

## Heatmaps
dev.off() # clear away plot
corPlot(dataLungCap[1:3])

dev.off()
pairs.panels(dataLungCap[1:3])


## Create a larger Model
mod2 <- lm(data = dataLungCap, LungCap ~ Age + Height + Smoke + Gender + Caesarean)

summary(mod2)

plot(mod2) # check the four plots!
