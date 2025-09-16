# Facet plots with Plotly

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

##########
# Load required libraries and install if missing
##########
if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}

if(!require('plotly')) {
  install.packages('plotly')
  library('plotly')
}


p <- ggplot(mpg, aes(x = displ, y = hwy, color = cty, size = cyl)) 
  
##########
# Prepare the data
##########
# Convert 'drv' (drive) and 'fl' (fuel type) to factors for faceting
mpg$drv <- as.factor(mpg$drv)
mpg$fl <- as.factor(mpg$fl)

##########
# Create the ggplot object
##########
# - x: displ (engine displacement)
# - y: hwy (highway mpg)
# - color: cty (city mpg)
# - size: cyl (number of cylinders)
# - facet_grid: rows by drv, columns by fl
p <- ggplot(mpg, aes(x = displ, y = hwy, color = cty, size = cyl)) +
  geom_point(alpha = 0.7) + # Scatter plot with transparency
  facet_grid(drv ~ fl) +    # Facet by drive and fuel type
  labs(title = "MPG Dataset: Displacement vs Highway MPG",
       color = "City MPG",
       size = "Cylinders",
       x = "Displacement",
       y = "Highway MPG") +
  #theme_minimal()           # Use a minimal theme for clarity
  theme_classic()           # Or a classic theme to specify different facets

##########
# Convert ggplot to interactive plotly plot
##########
interactive_plot <- ggplotly(p)

# Display the interactive plot
interactive_plot


