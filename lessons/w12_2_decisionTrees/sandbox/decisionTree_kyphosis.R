# Decision Trees ::  kyphorsis data
# Data on Children who have had Corrective Spinal Surgery
# Kyphosis : a factor with levels absent present indicating if a kyphosis (a type of deformation) was present after the operation.

# Variables
# Age : in months
# Number :  the number of vertebrae involved
# Start : the number of the first (topmost) vertebra operated on.

rm(list = ls()) # clear out the variables from memory to make a clean execution of the code.

# If you want to remove all previous plots and clear the console, run the following two lines.
graphics.off() # clear out all plots from previous work.

cat("\014") # clear the console

if(!require('tidyverse')) {
  install.packages('tidyverse')
  library('tidyverse')
}
if(!require('rpart')) {
  install.packages('rpart')
  library('rpart')
}
if(!require('rpart.plot')) {
  install.packages('rpart.plot')
  library('rpart.plot')
}


# A brief look at the data
head(kyphosis)


#Create three models using the variable Start to test
fit_start1  <- rpart(Kyphosis ~ Start, data = kyphosis)
fit_start2  <- rpart(Kyphosis ~ Start, data = kyphosis,
                     parms = list(prior = c(.65,.35), split = "information"))
fit_start3  <- rpart(Kyphosis ~ Start, data = kyphosis,
                     control = rpart.control(cp = 0.05))

# par() is for formatting text to prevent cut-offs, two columns
par(mfrow = c(1,3), xpd = NA) 

plot(fit_start1)
text(fit_start1, use.n = TRUE)

plot(fit_start2)
text(fit_start2, use.n = TRUE)

plot(fit_start3)
text(fit_start3, use.n = TRUE)


##########

#Create three models using all variables to test
fit  <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis)
fit2 <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis,
              parms = list(prior = c(.65,.35), split = "information"))
fit3 <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis,
              control = rpart.control(cp = 0.05))

# par() is for formatting text to prevent cut-offs, two columns
par(mfrow = c(1,2), xpd = NA) 

plot(fit)
text(fit, use.n = TRUE)

plot(fit2)
text(fit2, use.n = TRUE)

plot(fit3)
text(fit3, use.n = TRUE)



# par() is for formatting text to prevent cut-offs, three columns
par(mfrow = c(1,3), xpd = NA) 

plot(fit)
text(fit, use.n = TRUE)

plot(fit2)
text(fit2, use.n = TRUE)

plot(fit3)
text(fit3, use.n = TRUE)
