library(ggplot2)
library(dplyr)
library(olsrr)

df <- read.csv("~/Desktop/df.csv")

# Change all necessary variables to categorical 
 df <- df %>% mutate_if (is.integer, as.factor)

# Summary statistics
str(df)

# Data visualization 
# Scatter plot of test rate and test positivity rate
ggplot(df, aes(x = Test.rate, y= tpr, group=prname)) + 
  geom_point(aes(color=prname)) + xlab("Test Rate") + 
  ylab("Test Positivity Rate") +
  ggtitle("Effect of test rate on test positivity rate")

# Scatter plot of government stringency index and test positivity rate
ggplot(df, aes(x = government.stringency.index, y= tpr, group=prname)) + 
  geom_point(aes(color=prname)) + xlab("Government Stringency Index") + 
  ylab("Test Positivity Rate") +
  ggtitle("Effect of government stringency index on test positivity rate")

# Run a polynomial regression 
# Run the polynomial regression of degree 2 with all the variables
# (variable selection will be applied after)
model <- lm(tpr ~ poly(government.stringency.index, degree=2, raw=T) +
              poly(Test.rate, degree=2, raw=T) +
              testing.policy + international.travel.controls +
              restrictions.on.public.gatherings + school.closures +
              income.relief +
              debt.or.contract.relief, data=df)

# Choose the best model subset based on AIC (Akaike’s Information Criteria)
#ols_step_best_subset(model)
# Lowest AIC is the model with two covariates: test rate and restrictions
# on public gatherings