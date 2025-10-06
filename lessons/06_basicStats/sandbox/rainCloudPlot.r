# rain cloud plot

# Install ggrain if you haven't already
# install.packages("ggrain")
# install.packages("ggplot2") # Also install ggplot2 if not present

library(ggplot2)
library(ggrain)
library(tidyverse)

# Sample data
set.seed(123)
data_df <- data.frame(
  group = rep(c("Group A", "Group B"), each = 50),
  value = c(rnorm(50, mean = 10, sd = 2), rnorm(50, mean = 12, sd = 3))
)

# Create a raincloud plot
ggplot(data_df, aes(x = group, y = value, fill = group)) +
  geom_rain(alpha = 0.7,  # Adjust transparency
            position = position_nudge(x = 0.1), # Position adjustment for the entire raincloud
            # Customize the individual components of the raincloud
            point.args = list(size = 1.5, alpha = 0.5),
            boxplot.args = list(width = 0.1, outlier.shape = NA), # Remove outliers from boxplot
            violin.args = list(alpha = 0.8, adjust = 1.5) # Adjust violin smoothness
  ) +
  scale_fill_brewer(palette = "Set1") + # Choose a color palette
  theme_minimal() +
  labs(title = "Raincloud Plot Example",
       x = "Group",
       y = "Value") +
  theme(legend.position = "none") # Hide the legend if desired
