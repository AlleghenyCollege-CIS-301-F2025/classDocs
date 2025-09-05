
rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

#Load library
library(tidyverse)

# find your sandbox file
sunData <- read.table(file.choose(), header = TRUE, sep = ",")

# See what the data looks like
View(sunData)
# Plot the data:
ggplot(data = sunData) +  geom_point(
    mapping =aes(
      x = fracOfYear,
      y = sunspotNum,
      color = numObs,
      size = year
      )
    )

data()
