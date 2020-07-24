library(ggplot2)
library(dplyr)
library(countrycode)

#Government of Canada COVID-19 Dataset 
canada = read.csv("https://health-infobase.canada.ca/src/data/covidLive/covid19.csv")
can_metadata = read.csv("https://health-infobase.canada.ca/src/data/covidLive/covid19-data-dictionary.csv")

#DELVE Global Interventions Dataset
delve = read.csv(url("https://raw.githubusercontent.com/rs-delve/covid19_datasets/master/dataset/combined_dataset_latest.csv"))
 delve <- (delve %>%
   mutate(DATE = as.Date(DATE, format= "%Y-%m-%d")) %>%
   mutate(country_name = as.factor(country_name)) %>%
   mutate(ISO=NULL)) 
 
summary(delve)

#Country Effective Reproductive Number Estimates from University of Oxford, Australian National University, and Harvard 
Rt <- read.csv("https://storage.googleapis.com/static-covid/static/v4/main/r_estimates.csv")
Rt <- (Rt %>%
         mutate(Date = as.Date(Date, format= "%Y-%m-%d")) %>%
         mutate(Country = countrycode(Rt$Code, "iso2c","country.name")) %>% 
         mutate(Country =as.factor(Country)))
summary(Rt)

# Categorizing Variables and Calculating TPR from data
canada <- (canada %>%
    mutate (pruid = NULL,prnameFR = NULL) %>% 
    mutate(date = as.Date(date, format= "%d-%m-%Y")) %>%
    mutate (prname = as.factor(prname)) %>%
    mutate (tpr = (numtotal/numtested)*100))
  
# Summary statistics
summary(canada)

# Create Subset to for only National Data
national <- canada %>% filter(prname == "Canada" & !is.na(tpr))
delve_canada <- delve %>% filter (country_name == "Canada")

# Data visualization 
## Time plots for TPR
print(
	ggplot(national)
	+ aes(date, tpr)
	+ geom_point()
	+ ylab("Positivity Rate (%)")
)

## Time plots for Testing Rate
print(
	ggplot(national)
	+ aes(date, ratetested)
	+ geom_point()
	+ ylab("Test rate (per 1 million people)")
)

# Scatter plot of test rate and test positivity rate
ggplot(national, aes(ratetested, tpr)) + 
  geom_point() + xlab("Test Rate") + 
  ylab("Test Positivity Rate") +
  ggtitle("Effect of test rate on test positivity rate")

# Scatter plot of government stringency index and test positivity rate
#ggplot(national, aes(government.stringency.index, tpr, group=prname)) + 
#  geom_point(aes(color=prname)) + xlab("Government Stringency Index") + 
 # ylab("Test Positivity Rate") +
 # ggtitle("Effect of government stringency index on test positivity rate")

# Run a polynomial regression 
# Run the polynomial regression of degree 2 with all the variables
# (variable selection will be applied after)
# model <- lm(tpr ~ poly(government.stringency.index, degree=2, raw=T) +
#              poly(Test.rate, degree=2, raw=T) +
#               testing.policy + international.travel.controls +
#              restrictions.on.public.gatherings + school.closures +
#               debt.or.contract.relief, data=canada)

# Choose the best model subset based on AIC (Akaike’s Information Criteria)
#ols_step_best_subset(model)
# Lowest AIC is the model with two covariates: test rate and restrictions
# on public gatherings
