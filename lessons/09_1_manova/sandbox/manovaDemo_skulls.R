# Manova demo using Skulls dataset.
# Fall 2025
# Lengthy Analysis

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console


if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}


# Load required libraries
if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}

if(!require('HSAUR2')) {
  install.packages('HSAUR2')
  library('HSAUR2')
}

# Load the skulls dataset
data("skulls")
names(skulls)

# Basic summary
summary(skulls)



# Calculate means by epoch
means_by_epoch <- skulls %>%
  group_by(epoch) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

# Reshape for plotting
means_long <- means_by_epoch %>%
  pivot_longer(cols = -epoch, names_to = "measurement", values_to = "mean_value")

# Create a vibrant, colorful plot
ggplot(means_long, aes(x = epoch, y = mean_value, fill = measurement)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  scale_fill_manual(values = c("mb" = "#FF6B6B", "bh" = "#4ECDC4", 
                               "bl" = "#45B7D1", "nh" = "#96CEB4"),
                    labels = c("mb" = "Max Breadth 🔄", "bh" = "Height ⬆️", 
                               "bl" = "Length ↔️", "nh" = "Nasal Height 👃")) +
  labs(title = "💀 Mean Skull Measurements by Epoch 🏺",
       subtitle = "Colorful visualization of Egyptian skull evolution over time ⏰",
       x = "🕰️ Historical Epoch", 
       y = "📏 Mean Value (mm)",
       fill = "📊 Measurements") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    plot.title = element_text(size = 16, hjust = 0.5, color = "#2C3E50"),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#7F8C8D"),
    legend.position = "bottom",
    panel.grid.major = element_line(color = "#BDC3C7", alpha = 0.3),
    panel.background = element_rect(fill = "#FFFFFF", alpha = 0.8)
  )


# Create a vibrant, colorful plot
ggplot(means_long, aes(x = epoch, y = mean_value, fill = measurement)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  scale_fill_manual(values = c("mb" = "#FF6B6B", "bh" = "#4ECDC4", 
                               "bl" = "#45B7D1", "nh" = "#96CEB4"),
                    labels = c("mb" = "Max Breadth 🔄", "bh" = "Height ⬆️", 
                               "bl" = "Length ↔️", "nh" = "Nasal Height 👃")) +
  labs(title = "💀 Mean Skull Measurements by Epoch 🏺",
       subtitle = "Colorful visualization of Egyptian skull evolution over time ⏰",
       x = "🕰️ Historical Epoch", 
       y = "📏 Mean Value (mm)",
       fill = "📊 Measurements") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    plot.title = element_text(size = 16, hjust = 0.5, color = "#2C3E50"),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#7F8C8D"),
    legend.position = "bottom",
    panel.grid.major = element_line(color = "#BDC3C7"),
    panel.background = element_rect(fill = "#FFFFFF")
  )




# Create a vibrant, colorful plot
ggplot(means_long, aes(x = epoch, y = mean_value, fill = measurement)) +
  geom_bar(stat = "identity", position = "dodge", alpha = 0.8) +
  scale_fill_manual(values = c("mb" = "#FF6B6B", "bh" = "#4ECDC4", 
                               "bl" = "#45B7D1", "nh" = "#96CEB4"),
                    labels = c("mb" = "Max Breadth 🔄", "bh" = "Height ⬆️", 
                               "bl" = "Length ↔️", "nh" = "Nasal Height 👃")) +
  labs(title = "💀 Mean Skull Measurements by Epoch 🏺",
       subtitle = "Colorful visualization of Egyptian skull evolution over time ⏰",
       x = "🕰️ Historical Epoch", 
       y = "📏 Mean Value (mm)",
       fill = "📊 Measurements") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    plot.title = element_text(size = 16, hjust = 0.5, color = "#2C3E50"),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#7F8C8D"),
    legend.position = "bottom",
    panel.grid.major = element_line(color = "#BDC3C7"),
    panel.background = element_rect(fill = "#FFFFFF")
  )




# Create MANOVA model
skulls.manova <- manova(cbind(mb, bh, bl, nh) ~ as.factor(epoch), data = skulls)

# Test with different statistics
summary(skulls.manova, test = "Wilks")

# Pillai's trace (most robust)
summary(skulls.manova, test = "Pillai")

# Hotelling-Lawley trace
summary(skulls.manova, test = "Hotelling-Lawley")


# Roy's greatest root
summary(skulls.manova, test = "Roy")

# Examine each variable separately
summary.aov(skulls.manova)


# Create correlation matrix for skull measurements
skull_cor <- skulls %>%
  select(mb, bh, bl, nh) %>%
  cor()

# Convert to long format for ggplot
library(reshape2)
skull_cor_long <- melt(skull_cor)

# Create a stunning, colorful heatmap
ggplot(skull_cor_long, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white", size = 1) +
  geom_text(aes(label = paste0(round(value, 2), 
                               ifelse(value > 0.6, " 🔥", 
                                      ifelse(value > 0.4, " 😊", " 😐")))), 
            color = "white", size = 5, fontface = "bold") +
  scale_fill_gradient2(low = "#3498DB", high = "#E74C3C", mid = "#9B59B6", 
                       midpoint = 0.5, limit = c(0,1),
                       name = "🔗 Correlation\nStrength") +
  labs(title = "🔥 Correlation Matrix of Skull Measurements 💀",
       subtitle = "Exploring relationships between variables 🔗✨",
       x = "📊 Variables", y = "📊 Variables") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, hjust = 0.5, color = "#2C3E50"),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#7F8C8D"),
    axis.text = element_text(size = 12, color = "#2C3E50"),
    legend.title = element_text(size = 10),
    panel.grid = element_blank(),
    axis.ticks = element_blank()
  ) +
  coord_fixed()

# Compare just two epochs for demonstration
skulls.manova2 <- manova(cbind(mb, bh, bl, nh) ~ as.factor(epoch), 
                         data = skulls, 
                         subset = as.factor(epoch) %in% c("c4000BC", "c200BC"))

summary(skulls.manova2, test = "Wilks")



# Create vibrant boxplots for each measurement by epoch
skulls_long <- skulls %>%
  pivot_longer(cols = c(mb, bh, bl, nh), 
               names_to = "measurement", 
               values_to = "value") %>%
  mutate(measurement = factor(measurement, 
                              labels = c("bh" = "Height ⬆️", "bl" = "Length ↔️",
                                         "mb" = "Max Breadth 🔄", "nh" = "Nasal Height 👃")))

ggplot(skulls_long, aes(x = epoch, y = value, fill = epoch)) +
  geom_boxplot(alpha = 0.8, outlier.color = "red", outlier.size = 2) +
  geom_jitter(width = 0.3, alpha = 0.4, size = 0.8, color = "darkblue") +
  facet_wrap(~ measurement, scales = "free_y", ncol = 2) +
  scale_fill_manual(values = c("c4000BC" = "#FF6B6B", "c3300BC" = "#4ECDC4", 
                               "c1850BC" = "#45B7D1", "c200BC" = "#96CEB4", 
                               "cAD150" = "#FECA57")) +
  labs(title = "🎨 Distribution of Skull Measurements by Epoch 💀",
       subtitle = "Colorful exploration of measurement variations across time ⏰✨",
       x = "🕰️ Historical Epoch", 
       y = "📏 Measurement Value (mm)",
       caption = "📊 Boxplots show quartiles, dots show individual measurements") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    plot.title = element_text(size = 16, hjust = 0.5, color = "#2C3E50"),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#7F8C8D"),
    plot.caption = element_text(size = 10, color = "#95A5A6"),
    legend.position = "none",
    strip.text = element_text(size = 12, face = "bold", color = "#34495E"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#FAFAFA")
  )

# Calculate eta-squared for overall effect
skulls_aov <- summary.aov(skulls.manova)

# Extract sums of squares for effect size calculation
# This is a simplified approach
cat("Effect sizes (eta-squared) for each variable:\n")

for(i in 1:4) {
  aov_summary <- skulls_aov[[i]]
  ss_effect <- aov_summary[1, "Sum Sq"]  # Sum of squares for epoch
  ss_total <- sum(aov_summary[, "Sum Sq"])  # Total sum of squares
  eta_sq <- ss_effect / ss_total
  var_name <- c("mb", "bh", "bl", "nh")[i]
  cat(paste(var_name, ": ", round(eta_sq, 3), "\n"))
}




