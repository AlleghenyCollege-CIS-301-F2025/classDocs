# A demonstraion of commands in the Psych Library

# Note: you should be in the habit of looking up more about the commands from 
# the library's online help. To learn more, use the following type of command
# to learn more.
# ? <R keyword>

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console


#install.packages("psych")


# Load the psych library
library(psych)

###############
#1. Descriptive Statistics
# Explanation: Descriptive statistics provide a summary of the central tendency, dispersion, and shape of a dataset’s distribution. This is essential in psychological research to understand basic features of data before diving into more complex analyses.


# Sample data
data <- data.frame(
  age = c(21, 22, 19, 24, 30, 25, 22),
  score = c(78, 85, 82, 90, 75, 88, 95)
)

# Compute descriptive statistics
desc_stats <- describe(data)
print(desc_stats)

# find out more about the outputs from the following command
? describe

# HOW TO INTERPRET DESCRIPTIVE STATISTICS:
# - n: Sample size (number of observations)
# - mean: Average value - indicates central tendency
# - sd: Standard deviation - measures variability/spread of data
# - median: Middle value when data is ordered - less affected by outliers than mean
# - trimmed: Mean after removing top and bottom 10% - robust measure of center
# - mad: Median absolute deviation - robust measure of variability
# - min/max: Smallest and largest values - shows data range
# - range: Difference between max and min
# - skew: Measure of asymmetry (positive = right tail, negative = left tail)
# - kurtosis: Measure of tail heaviness (higher = more extreme outliers)
# - se: Standard error of the mean - precision of the sample mean

# DRAWING CONCLUSIONS:
# Compare means to understand group differences
# Check if mean and median are similar (indicates symmetrical distribution)
# Large standard deviation relative to mean suggests high variability
# Skewness near 0 indicates normal distribution; >1 or <-1 suggests strong skewness
# Use these statistics to identify outliers and assess data quality before further analysis

# Summary Ideas: Descriptive statistics help researchers summarize data 
# concisely, identify trends, and spot potential outliers, making it 
# easier to report findings and guide further analysis.

###############

# 2. Reliability Analysis
# Explanation: Reliability analysis assesses the consistency of a measure, often using Cronbach's alpha. This is crucial in psychological testing to ensure that scales produce stable and consistent results.

# Load the psych library
library(psych)

# Sample data for reliability analysis
items <- data.frame(
  item1 = c(5, 4, 3, 4, 5, 3, 4),
  item2 = c(4, 4, 3, 5, 5, 3, 4),
  item3 = c(5, 5, 4, 4, 5, 4, 4)
)

# Compute reliability (Cronbach's alpha)
reliability <- alpha(items)
print(reliability)

# HOW TO INTERPRET CRONBACH'S ALPHA:
# Cronbach's alpha measures internal consistency reliability (0 to 1 scale)
# - α ≥ 0.9: Excellent reliability (suitable for high-stakes decisions)
# - α ≥ 0.8: Good reliability (acceptable for research)
# - α ≥ 0.7: Acceptable reliability (adequate for exploratory research)
# - α ≥ 0.6: Questionable reliability (may need improvement)
# - α < 0.6: Poor reliability (scale needs revision)

# KEY OUTPUT INTERPRETATIONS:
# - raw_alpha: Overall Cronbach's alpha for the scale
# - alpha.drop: Alpha if each item is removed (helps identify problematic items)
# - item stats: Shows mean, sd, and item-total correlations for each item
# - If "alpha if item deleted" > overall alpha, consider removing that item
# - Item-total correlations should typically be > 0.3 for good items

# DRAWING CONCLUSIONS:
# Use alpha to determine if your scale is reliable enough for your purpose
# Identify items that lower reliability (low item-total correlations)
# Consider removing or revising items that improve alpha when deleted
# Report alpha coefficient when publishing research using the scale

# Summary Ideas: Reliability analysis is vital for ensuring that psychological measures are dependable, thereby enhancing the validity of research findings and facilitating comparisons across studies.


###############

# 3. Factor Analysis
# Explanation: Factor analysis is used to identify underlying relationships between variables. It helps in data reduction and in exploring the structure of data, which is useful when developing theoretical models.


# Load the psych library
library(psych)

# Sample data for factor analysis
data <- data.frame(
  var1 = c(1, 2, 3, 4, 5),
  var2 = c(2, 3, 4, 5, 6),
  var3 = c(5, 4, 3, 2, 1),
  var4 = c(1, 1, 1, 2, 2)
)

# Conduct factor analysis
fa_result <- fa(data, nfactors = 2, rotate = "varimax")
print(fa_result)

# HOW TO INTERPRET FACTOR ANALYSIS:
# Factor analysis identifies underlying dimensions (factors) in your data

# KEY OUTPUT INTERPRETATIONS:
# - Factor Loadings: Correlations between variables and factors
#   * Loadings > |0.6|: Strong relationship with factor
#   * Loadings 0.3-0.6: Moderate relationship
#   * Loadings < |0.3|: Weak relationship (may not belong on factor)
# - Eigenvalues: Amount of variance explained by each factor
#   * Eigenvalues > 1.0: Generally retained (Kaiser criterion)
# - Proportion of Variance: Percentage of total variance each factor explains
# - Cumulative Variance: Total variance explained by all retained factors

# ROTATION METHODS:
# - "varimax": Orthogonal rotation (factors are uncorrelated)
# - "promax": Oblique rotation (allows factors to correlate)
# - Choose rotation based on whether you expect factors to be related

# DRAWING CONCLUSIONS:
# Examine which variables load highly on each factor to interpret factor meaning
# Name factors based on the variables that load most strongly
# Consider the practical significance of variance explained (typically >60% desired)
# Use factor scores for further analysis or scale development
# Factors with few strong loadings or low eigenvalues may not be meaningful

# Summary Ideas: Factor analysis aids researchers in identifying the dimensions of psychological constructs, informing scale development, and clarifying theoretical frameworks in psychology.

###############

# 4. Correlation Matrix
# Explanation: A correlation matrix shows the relationships between multiple variables, indicating how they are associated. This is particularly useful for identifying potential multicollinearity and guiding hypothesis generation.

# Load the psych library
library(psych)

# Sample data for correlation analysis
data <- data.frame(
  variable1 = c(1, 2, 3, 4, 5),
  variable2 = c(5, 4, 3, 2, 1),
  variable3 = c(2, 3, 4, 3, 2)
)

# Compute correlation matrix
correlation_matrix <- corr.test(data)
print(correlation_matrix$r)  # Display correlation coefficients

# Display significance levels (p-values)
print("P-values for correlations:")
print(correlation_matrix$p)

# HOW TO INTERPRET CORRELATION COEFFICIENTS:
# Correlation coefficients (r) range from -1 to +1
# - r = +1: Perfect positive correlation
# - r = 0.7 to 0.9: Strong positive correlation
# - r = 0.3 to 0.7: Moderate positive correlation
# - r = 0.1 to 0.3: Weak positive correlation
# - r = 0: No linear relationship
# - r = -0.1 to -0.3: Weak negative correlation
# - r = -0.3 to -0.7: Moderate negative correlation
# - r = -0.7 to -0.9: Strong negative correlation
# - r = -1: Perfect negative correlation

# SIGNIFICANCE TESTING:
# P-values indicate statistical significance of correlations
# - p < 0.001: Highly significant (***)
# - p < 0.01: Very significant (**)
# - p < 0.05: Significant (*)
# - p ≥ 0.05: Not statistically significant

# DRAWING CONCLUSIONS:
# Strong correlations (|r| > 0.7) may indicate multicollinearity in regression
# Look for patterns: Which variables are most/least related?
# Consider both magnitude and significance when interpreting relationships
# Be cautious of spurious correlations with small sample sizes
# Remember: correlation does not imply causation!

# Summary Ideas: Correlation matrices help researchers explore relationships between variables, allowing for better hypothesis formulation and identifying confounding variables that may impact results.

###############


# 5. Item Analysis
# Explanation: Item analysis evaluates individual items within a test to determine their effectiveness and contribution to overall scale reliability. This is essential for optimizing measurement tools in psychological assessments.

# Load the psych library
library(psych)

# Sample data for item analysis
items <- data.frame(
  item1 = c(4, 5, 3, 4, 5),
  item2 = c(5, 4, 4, 5, 5),
  item3 = c(3, 2, 4, 3, 3)
)

# Display the items data frame
print("Items Data Frame:")
print(items)

# Conduct item analysis using alpha() function for comprehensive analysis
items_analysis <- alpha(items)
print("Item Analysis Results:")
print(items_analysis)

# Additional item statistics using describe() for each item
print("Descriptive Statistics for Each Item:")
item_descriptives <- describe(items)
print(item_descriptives)

# Item-total correlations (how each item correlates with the total scale)
print("Item-Total Correlations:")
item_total_corr <- cor(items, rowSums(items))
print(item_total_corr)

# HOW TO INTERPRET ITEM ANALYSIS:
# Item analysis evaluates how well each item contributes to the overall scale

# KEY METRICS TO EXAMINE:
# 1. CRONBACH'S ALPHA:
#    - Overall reliability of the scale (see reliability section for interpretation)
#    - "alpha if item deleted" shows impact of removing each item

# 2. ITEM-TOTAL CORRELATIONS:
#    - Correlation between each item and total scale score
#    - Good items typically have correlations > 0.30
#    - Correlations < 0.20 suggest problematic items
#    - Very high correlations (> 0.90) may indicate redundancy

# 3. ITEM DIFFICULTY (for tests/questionnaires):
#    - Item means show average response level
#    - Very easy (high mean) or very hard (low mean) items may be less useful
#    - Aim for moderate difficulty items for best discrimination

# 4. ITEM DISCRIMINATION:
#    - How well items distinguish between high and low scorers
#    - Items with low discrimination contribute less to scale reliability

# DRAWING CONCLUSIONS AND ACTIONS:
# - Remove items with very low item-total correlations (< 0.20)
# - Consider removing items if "alpha if item deleted" > overall alpha
# - Look for items with similar content (high inter-item correlations)
# - Revise items with poor psychometric properties rather than just deleting
# - Ensure sufficient items remain to maintain content validity
# - Re-analyze after making changes to confirm improvements

# PRACTICAL CONSIDERATIONS:
# - Balance statistical optimization with theoretical/content considerations
# - Consider the purpose of the scale (research vs. clinical use)
# - Small samples may produce unstable item statistics
# - Cross-validate findings with independent samples when possible

# Summary Ideas: Item analysis is crucial for refining measurement instruments, ensuring that each item contributes positively to the construct being measured, thereby enhancing the overall quality of research tools.

