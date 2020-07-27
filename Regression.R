library(ggplot2)
library(dplyr)
library(countrycode)

#Government of Canada (GoC) COVID-19 Dataset 
goc = read.csv("https://health-infobase.canada.ca/src/data/covidLive/covid19.csv")
goc_metadata = read.csv("https://health-infobase.canada.ca/src/data/covidLive/covid19-data-dictionary.csv")

goc <- (goc %>%
  mutate (pruid = NULL,prnameFR = NULL) %>% 
  mutate(date = as.Date(date, format= "%d-%m-%Y")) %>%
  mutate (country = as.factor(prname)) %>%
  relocate(country) %>%
  mutate (tpr = (numconf/numtested)*100) %>%
  mutate (prname = NULL) %>% 
  filter(country == "Canada"))

summary(goc)

#DELVE Global Interventions Dataset *transmute function always seems to give me an error 
delve = read.csv(url("https://raw.githubusercontent.com/rs-delve/covid19_datasets/master/dataset/combined_dataset_latest.csv"))
 delve <- (delve %>%
   mutate(date = as.Date(DATE, format= "%Y-%m-%d")) %>%
   mutate(country = as.factor(country_name)) %>%
   mutate(ISO=NULL) %>%
   relocate (date, country) %>%
   mutate (DATE = NULL, country_name = NULL, iso_3166_2_code = NULL, census_fips_code = NULL) ) 
summary(delve)


#Country Effective Reproductive Number Estimates from University of Oxford, Australian National University, and Harvard 
Rt <- read.csv("https://storage.googleapis.com/static-covid/static/v4/main/r_estimates.csv")
Rt <- (Rt %>%
         mutate(date = as.Date(Date, format= "%Y-%m-%d")) %>%
         mutate(country = countrycode(Rt$Code, "iso2c","country.name")) %>% #converting country codes to country names. US states not converted 
         mutate(country =as.factor(country)))
summary(Rt)



# Create Subset to for only National Canada Data
national <- inner_join(goc, delve)
national <- inner_join(national, Rt)
national <- (national %>% 
            filter(country == "Canada" & !is.na(tpr)) %>%
            mutate(npi_masks = as.factor(npi_masks)) %>% 
            mutate(npi_testing_policy = as.factor(npi_testing_policy)) %>% 
            mutate(Code = NULL, X = NULL, Date = NULL))

summary(national)

# Data visualization 
## Time plots for TPR
print(
	ggplot(national)
	+ aes(date, tpr)
	+ geom_point()
	+ ylab("Cumulative Positivity Rate (%)")
	+ xlab("Date")
)

## Time plots for Testing Rate
print(
	ggplot(national) +
  aes(date, ratetested) +
	geom_point() +
	ylab("Cumulative Test rate (per 1 million people)")
)


#Regressions 
# Model 1: Cumulative TPR ~ Cumulative Testing Rate + testing policy 

model1 <- lm(tpr ~  ratetested + npi_testing_policy, data = national)
summary(model1)
plot(model1) 
 

# Model 2: Cumulative TPR ~ testing rate + testing policy + effective reproduction number + government stringency index + mask policy
model2 <- lm(tpr ~  ratetested + npi_testing_policy+ MeanR + npi_stringency_index, data = national)
summary(model2)
plot(model2) 
 

