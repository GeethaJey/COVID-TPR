library(ggplot2)
library(dplyr)
library(countrycode)

# Data visualization 
## Time plots for Global Cumulative TPR
print(
	ggplot(global)
	+ aes(date, cumulative.tpr, colour = continent)
	+ geom_point()
	+ ylab("Cumulative Positivity Rate (%)")
	+ xlab("Date")
)

## Time plots for Testing Rate
print(
	ggplot(global) +
  aes(date, tests_total_per_thousand, colour = continent) +
	geom_point() +
	ylab("Cumulative Test rate (per 1 thousand people)")
)

#Regressions 
# Model 1: Cumulative TPR ~ testing rate + effective reproduction number + government stringency index + mask policy
model1 <- lm(cumulative.tpr ~  tests_total_per_thousand + MeanR + npi_stringency_index, data = global)
summary(model1)
plot(model1) 
 

# Model 2: 
model2 <- lm(cumulative.tpr ~ npi_testing_policy + tests_total_per_thousand, data = global)
summary(model2)
plot(model2)