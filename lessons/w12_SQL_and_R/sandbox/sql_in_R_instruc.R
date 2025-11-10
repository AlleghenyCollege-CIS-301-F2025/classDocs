# ======================================================================
# SQL and R: Demonstration

# This file contains all programming code from the SQL in R presentation
# slides, organized for instructor reference and student practice.

# ======================================================================
# SECTION 1: PACKAGE INSTALLATION & SETUP
# ======================================================================

# Manual Installation Code (for students to run in console)
# --------------------------------------------------------
# Essential packages for SQL in R
#install.packages(c(
#  "DBI",          # Database interface
#  "RSQLite",      # SQLite database driver
#  "tidyverse",    # Data manipulation (includes dplyr, ggplot2)
#  "dbplyr",       # dplyr backend for databases
#  "nycflights13"  # Sample dataset we'll use
#))

# Load the libraries

# library(DBI)
# library(RSQLite)
# library(tidyverse)
# library(dbplyr)
# library(nycflights13)

# ======================================================================
# SECTION 2: SMART LIBRARY LOADING (AUTOMATED SETUP)
# ======================================================================

# Clear the environment for a fresh start
rm(list = ls())
graphics.off()

# Smart loading: Install if missing, then load DBI (Database Interface)
if(!require('DBI')) {
  install.packages('DBI')
  library('DBI')
}

# Smart loading: Install if missing, then load RSQLite (SQLite driver)
if(!require('RSQLite')) {
  install.packages('RSQLite')
  library('RSQLite')
}

# Smart loading: Install if missing, then load our sample dataset
if(!require('nycflights13')) {
  install.packages('nycflights13')
  library('nycflights13')
}

# Load remaining libraries (should already be installed)
library(tidyverse)  # For data manipulation and visualization
library(dbplyr)     # For dplyr-style database operations

# ======================================================================
# SECTION 3: DATA EXPLORATION
# ======================================================================

# Load the flights dataset and explore its structure
library(nycflights13)

# Quick peek at our data structure
glimpse(flights)

# Count total number of flights
nrow(flights)

# The dataset contains 336,776 flights with 19 variables including 
# departure/arrival times, airlines, and destinations

# ======================================================================
# SECTION 4: DATABASE CREATION
# ======================================================================

# Create an in-memory SQLite database
con <- dbConnect(RSQLite::SQLite(), ":memory:")

# Write our flights data to the database
dbWriteTable(con, "flights", flights)

# Add related tables for richer queries
dbWriteTable(con, "airlines", airlines)
dbWriteTable(con, "airports", airports)
dbWriteTable(con, "planes", planes)
dbWriteTable(con, "weather", weather)

# Note: Using ":memory:" creates a temporary database that's super fast for learning

# ======================================================================
# SECTION 5: BASIC SQL QUERIES
# ======================================================================

# 5.1: First SQL Query - Get first 10 flights
# ----------------------------------------------




query1 <- "
  SELECT year, month, day, dep_time, arr_time, carrier, dest
  FROM flights 
  LIMIT 10"

result1 <- dbGetQuery(con, query1)
print(result1)

# 5.2: Filtering with WHERE clause - Flights to LAX
# --------------------------------------------------
lax_query <- "
  SELECT carrier, flight, dep_time, arr_time, distance, dest
  FROM flights 
  WHERE dest = 'LAX'
  LIMIT 15"

lax_flights <- dbGetQuery(con, lax_query)
print(lax_flights)

# Challenge: Find flights departing after 6 PM (1800 hours)
evening_flights_query <- "
  SELECT carrier, flight, dep_time, arr_time, dest
  FROM flights 
  WHERE dep_time > 1800
  LIMIT 10"

evening_flights <- dbGetQuery(con, evening_flights_query)
print(evening_flights)

# ======================================================================
# SECTION 6: AGGREGATION AND GROUPING
# ======================================================================

# 6.1: Count flights by airline carrier
# --------------------------------------
carrier_query <- "
  SELECT carrier, COUNT(*) as flight_count
  FROM flights 
  GROUP BY carrier
  ORDER BY flight_count DESC"

carrier_counts <- dbGetQuery(con, carrier_query)
print(carrier_counts)

# 6.2: Join flights with airline names for better readability
# -----------------------------------------------------------
joined_query <- "
  SELECT a.name as airline_name, COUNT(*) as flights
  FROM flights f
  JOIN airlines a ON f.carrier = a.carrier
  GROUP BY f.carrier, a.name
  ORDER BY flights DESC"

airline_summary <- dbGetQuery(con, joined_query)
print(airline_summary)

# ======================================================================
# SECTION 7: DATA VISUALIZATION
# ======================================================================

# 7.1: Create airline frequency chart
# ------------------------------------
airline_plot <- ggplot(airline_summary, aes(x = reorder(airline_name, flights), y = flights)) +
  geom_col(fill = "steelblue", alpha = 0.8) +
  coord_flip() +
  labs(
    title = "✈️ Flight Frequency by Airline (2013)",
    subtitle = "Data queried using SQL in R",
    x = "Airline",
    y = "Number of Flights",
    caption = "Source: nycflights13 dataset"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", color = "darkblue"),
    plot.subtitle = element_text(size = 12, color = "gray50"),
    axis.text = element_text(size = 11)
  )

# Display the plot
print(airline_plot)

# 7.2: Full-size visualization version
# ------------------------------------
ggplot(airline_summary, aes(x = reorder(airline_name, flights), y = flights)) +
  geom_col(fill = "steelblue", alpha = 0.8) +
  coord_flip() +
  labs(
    title = "✈️ Flight Frequency by Airline (2013)",
    subtitle = "Data queried using SQL in R",
    x = "Airline",
    y = "Number of Flights",
    caption = "Source: nycflights13 dataset"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 18, face = "bold", color = "darkblue"),
    plot.subtitle = element_text(size = 14, color = "gray50"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 13)
  )

# ======================================================================
# SECTION 8: ADVANCED ANALYSIS - MONTHLY PATTERNS
# ======================================================================

# 8.1: Analyze monthly flight patterns with delays
# -------------------------------------------------
monthly_query <- "
  SELECT month, COUNT(*) as flights,
         AVG(dep_delay) as avg_delay
  FROM flights 
  WHERE dep_delay IS NOT NULL
  GROUP BY month
  ORDER BY month"

monthly_data <- dbGetQuery(con, monthly_query)
print(monthly_data)

# 8.2: Data reshaping for visualization using pivot_longer
# --------------------------------------------------------
library(tidyr)

monthly_data_long <- monthly_data %>%
  pivot_longer(cols = c(flights, avg_delay), 
               names_to = "metric", 
               values_to = "value") %>%
  mutate(metric = case_when(
    metric == "flights" ~ "Monthly Flight Volume",
    metric == "avg_delay" ~ "Average Departure Delay (min)"
  ))

# Preview reshaped data
head(monthly_data_long)

# 8.3: Monthly trends visualization with faceting
# -----------------------------------------------
monthly_plot <- ggplot(monthly_data_long, aes(x = month, y = value)) +
  geom_line(aes(color = metric), size = 1.2) +
  geom_point(aes(color = metric), size = 2.5) +
  facet_wrap(~ metric, scales = "free_y", ncol = 2) +
  scale_color_manual(values = c("Monthly Flight Volume" = "steelblue", 
                                "Average Departure Delay (min)" = "coral")) +
  labs(title = "🛫 Monthly Flight Trends: Volume vs. Delays", 
       x = "Month", y = "") +
  theme_minimal() +
  theme(text = element_text(size = 12),
        legend.position = "none",
        strip.text = element_text(face = "bold", size = 13),
        plot.title = element_text(size = 15, face = "bold"))

# Display the plot
print(monthly_plot)

# 8.4: Full-size monthly trends visualization
# -------------------------------------------
ggplot(monthly_data_long, aes(x = month, y = value)) +
  geom_line(aes(color = metric), size = 1.5) +
  geom_point(aes(color = metric), size = 3) +
  facet_wrap(~ metric, scales = "free_y", ncol = 2) +
  scale_color_manual(values = c("Monthly Flight Volume" = "steelblue", 
                                "Average Departure Delay (min)" = "coral")) +
  labs(title = "🛫 Monthly Flight Trends: Volume vs. Delays", 
       x = "Month", y = "") +
  theme_minimal() +
  theme(text = element_text(size = 14),
        legend.position = "none",
        strip.text = element_text(face = "bold", size = 15, color = "darkblue"),
        plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
        axis.text = element_text(size = 12),
        axis.title = element_text(size = 13))

# ======================================================================
# SECTION 9: FACETING EXAMPLES AND TECHNIQUES
# ======================================================================

# 9.1: Basic faceting example with top carriers
# ---------------------------------------------
top_carriers <- airline_summary %>% slice_head(n = 6)

ggplot(top_carriers, aes(x = flights, y = airline_name)) +
  geom_col(fill = "lightblue", alpha = 0.7) +
  facet_wrap(~ ifelse(flights > 30000, "High Volume", "Medium Volume"), 
             scales = "free") +
  labs(title = "🔍 Basic Faceting: Airlines by Volume Category",
       x = "Number of Flights", y = "Airline") +
  theme_minimal() +
  theme(strip.text = element_text(face = "bold", size = 12))

# 9.2: Advanced faceting with multiple options
# --------------------------------------------
ggplot(monthly_data_long, aes(x = month, y = value, color = metric)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  facet_wrap(~ metric, 
             scales = "free_y",      # Independent y-axes
             ncol = 2,               # 2 columns
             labeller = label_wrap_gen(width = 20)) + # Wrap long labels
  scale_color_manual(values = c("steelblue", "coral")) +
  labs(title = "📊 Advanced Faceting: Control Layout & Scales",
       x = "Month", y = "Value") +
  theme_minimal() +
  theme(legend.position = "none",
        strip.text = element_text(face = "bold", size = 11))

# 9.3: Real-world business example - Delays by carrier
# ----------------------------------------------------
delay_by_carrier <- dbGetQuery(con, "
  SELECT month, carrier, AVG(dep_delay) as avg_delay
  FROM flights 
  WHERE dep_delay IS NOT NULL AND carrier IN ('UA', 'AA', 'DL', 'B6')
  GROUP BY month, carrier
  ORDER BY month, carrier")

ggplot(delay_by_carrier, aes(x = month, y = avg_delay)) +
  geom_line(color = "red", size = 1) +
  geom_point(color = "darkred", size = 2) +
  facet_wrap(~ carrier, 
             labeller = labeller(carrier = c("AA" = "American", 
                                             "B6" = "JetBlue", 
                                             "DL" = "Delta", 
                                             "UA" = "United"))) +
  labs(title = "✈️ Real Example: Average Delays by Airline",
       subtitle = "Compare seasonal patterns across major carriers",
       x = "Month", y = "Average Delay (minutes)") +
  theme_minimal() +
  theme(strip.text = element_text(face = "bold", color = "darkblue"))

# ======================================================================
# SECTION 10: COMPARING SQL VS DPLYR APPROACHES
# ======================================================================

# 10.1: SQL approach for complex query
# ------------------------------------
sql_result <- dbGetQuery(con, "
  SELECT dest, COUNT(*) as n_flights, AVG(distance) as avg_distance
  FROM flights 
  WHERE distance > 1000
  GROUP BY dest
  HAVING n_flights > 100
  ORDER BY avg_distance DESC
  LIMIT 5")

print("SQL Results:")
print(sql_result)

# 10.2: dplyr approach for same query
# -----------------------------------
dplyr_result <- flights %>%
  filter(distance > 1000) %>%
  group_by(dest) %>%
  summarise(
    n_flights = n(),
    avg_distance = mean(distance, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  filter(n_flights > 100) %>%
  arrange(desc(avg_distance)) %>%
  slice_head(n = 5)

print("dplyr Results:")
print(dplyr_result)

# Verify results are identical: 
# Generally identical? Yes, but there are slight differences from formatting
# identical(sql_result, dplyr_result)

# ======================================================================
# SECTION 11: PERFORMANCE TESTING
# ======================================================================

# Performance benchmark: Complex SQL query timing
print("🕐 Timing SQL query execution...")

timing_result <- system.time({
  large_query <- dbGetQuery(con, "
    SELECT carrier, dest, COUNT(*) as flights
    FROM flights 
    GROUP BY carrier, dest
    HAVING flights > 50")
})

print("✅ Query completed! Timing results:")
print(timing_result)

# Display query results
print("Query Results Preview:")
print(head(large_query))

# ======================================================================
# SECTION 12: PRACTICE EXERCISES (SOLUTIONS)
# ======================================================================

# Exercise 1: Beginner - Find flights on Christmas Day (December 25th)
christmas_flights <- dbGetQuery(con, "
  SELECT carrier, flight, dep_time, arr_time, origin, dest
  FROM flights 
  WHERE month = 12 AND day = 25
  LIMIT 20")

print("Christmas Day Flights:")
print(christmas_flights)

# Exercise 2: Intermediate - Calculate average delay by hour of day
hourly_delays <- dbGetQuery(con, "
  SELECT CAST(dep_time/100 AS INTEGER) as dep_hour, 
         COUNT(*) as flights,
         AVG(dep_delay) as avg_delay
  FROM flights 
  WHERE dep_time IS NOT NULL AND dep_delay IS NOT NULL
  GROUP BY dep_hour
  ORDER BY dep_hour")

print("Average Delays by Hour:")
print(hourly_delays)

# Visualize hourly delay patterns
ggplot(hourly_delays, aes(x = dep_hour, y = avg_delay)) +
  geom_line(color = "red", size = 1.2) +
  geom_point(color = "darkred", size = 2) +
  labs(title = "Average Flight Delays by Hour of Day",
       x = "Departure Hour", y = "Average Delay (minutes)") +
  theme_minimal()

# Exercise 3: Advanced - Find most popular routes
popular_routes <- dbGetQuery(con, "
  SELECT origin, dest, COUNT(*) as flights
  FROM flights 
  GROUP BY origin, dest
  ORDER BY flights DESC
  LIMIT 10")

print("Most Popular Routes:")
print(popular_routes)

# Exercise 4: Expert - Airlines with best on-time performance
ontime_performance <- dbGetQuery(con, "
  SELECT a.name as airline_name,
         COUNT(*) as total_flights,
         SUM(CASE WHEN dep_delay <= 0 THEN 1 ELSE 0 END) as ontime_flights,
         ROUND(100.0 * SUM(CASE WHEN dep_delay <= 0 THEN 1 ELSE 0 END) / COUNT(*), 2) as ontime_percentage
  FROM flights f
  JOIN airlines a ON f.carrier = a.carrier
  WHERE dep_delay IS NOT NULL
  GROUP BY f.carrier, a.name
  HAVING total_flights >= 1000
  ORDER BY ontime_percentage DESC")

print("On-Time Performance by Airline:")
print(ontime_performance)

# ======================================================================
# SECTION 13: CLEANUP AND BEST PRACTICES
# ======================================================================

# Always clean up database connections
dbDisconnect(con)
print("Database connection closed! ✅")

# ======================================================================
# ADDITIONAL RESOURCES AND NOTES
# ======================================================================

# Best Practices Summary:
# 1. Always close connections with dbDisconnect()
# 2. Use parameterized queries for user input
# 3. Test queries incrementally - start simple!
# 4. Comment your SQL for future reference
# 5. Use LIMIT when exploring large datasets
# 6. Check data types before joining tables
# 7. Consider indexing for production databases

# Key Functions Reference:
# - dbConnect() - Connect to database
# - dbGetQuery() - Execute SQL queries  
# - dbWriteTable() - Create tables
# - dbDisconnect() - Close connections
# - facet_wrap() - Create faceted plots
# - pivot_longer() - Reshape data for visualization

# When to use SQL vs R:
# SQL Wins: Large datasets (>1GB), complex joins, heavy aggregations, 
#           memory constraints, production databases
# R Wins: Statistical modeling, custom visualizations, iterative analysis,
#         small to medium data, exploratory work
# Best Approach: Use SQL to extract and filter, R to analyze and visualize

# Resources for Further Learning:
# - R Database Documentation: https://db.rstudio.com/
# - SQL Tutorial: https://www.w3schools.com/sql/
# - dbplyr Package: https://dbplyr.tidyverse.org/

# End of Instructor Source Code File
# ======================================================================

