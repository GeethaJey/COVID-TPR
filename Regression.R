library(ggplot2)
library(dplyr)
library(countrycode)

# Data visualization 

## Daily TPR

print(
  ggplot(global)
  + aes(date, daily.tpr, colour = continent)
  + geom_point()
  + ylab("Daily Positivity Rate (%)")
  + xlab("Date")
)
##Global Cumulative TPR
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

