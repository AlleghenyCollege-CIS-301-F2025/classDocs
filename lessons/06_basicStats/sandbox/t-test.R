
rm(list = ls()) # clear memory of variables
library(tidyverse)

data_drinks <- tibble::tribble( ~Observation, ~Colour, ~percentFull, 1,"Green", 70,
                                2,"Purple",30,
                                3,"Green",50,
                                4,"Purple",20,
                                5,"Purple",15,
                                6,"Green",90,
                                7,"Purple",40,
                                8,"Green",60,
                                9,"Purple",15)


data_drinks <- data_drinks %>% select(Colour, percentFull) #lose obs. num
#Run the t-test: a comparison of means.
t.test(data = data_drinks, percentFull ~ Colour)


myOut <- t.test(data = data_drinks, percentFull ~ Colour)
myOut$p.value
rejectOrWhat <- function(pValue){
  if(pValue >= 0.05){
    print("Accept Null Hypothesis: nothing happening")
  } else{
    print("Reject Null Hypotheis: something is going
on...")
  }}
rejectOrWhat(myOut$p.value)


#####


library(tibble)
library(dplyr) # and load tidyverse too!
data_people <- tibble::tribble(
  ~EyeColour, ~Height, ~Weight, ~Age,
  "Blue",        1.8, 110L, 18L,
  "Brown",       1.9, 150L, 34L,
  "Blue",        1.7, 207L, 28L,
  "Brown",       1.9, 170L, 21L,
  "Blue",        1.9, 164L, 29L,
  "Brown",       1.9, 183L, 31L,
  "Brown",       1.9, 175L, 20L,
  "Blue",        1.9, 202L, 27L
)
# Find the average BMI of people with blue eyes using piping
# Note: BMI = (height / (weight * weight))
data_people %>% select(EyeColour, Height, Weight) %>%
  filter(EyeColour=="Blue") %>% mutate(BMI = Weight / Height^2) %>% summary(averageBMI == mean(BMI))


ggplot(data = data_people) +
  geom_point(mapping = aes(y = Height, x = Weight,
                           color = Age )) +
  geom_smooth(mapping = aes(y = Height, x = Weight))
# Try playing with the settings!!



ggplot(data = data_people) +
  geom_point(mapping = aes(y = Height, x = Weight, color =
                             Age )) +
  geom_smooth(mapping = aes(y = Height, x = Weight )) +
  facet_wrap(~EyeColour)

#####


### iris data ###
# ref: https://rpubs.com/MTrungDang/720311



head(iris,10)
View(iris)
t.test(Sepal.Width ~ Species, 
       iris, 
       Species %in% c("versicolor", "virginica"), 
       var.equal = T)


unique(iris$Species)


t.test(Sepal.Width ~ Species, 
       iris, 
       Species %in% c("setosa", "virginica"), 
       var.equal = T)

t.test(Sepal.Width ~ Species, 
       iris, 
       Species %in% c("setosa", "versicolor"), 
       var.equal = T)


t.test(Sepal.Width ~ Species, 
       iris, 
       Species %in% c("versicolor", "setosa"), 
       var.equal = T)



t.test(Sepal.Length ~ Species, 
       iris, 
       Species %in% c("versicolor", "setosa"), 
       var.equal = T)

