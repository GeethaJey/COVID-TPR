library(ggplot2)
library(dplyr)
library(countrycode)

#GLOBAL DATASETS
#####################
#Our world in data daily test positivity rate smoothed over 7 days
owid <- read.csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")

owid <- (owid %>% 
        mutate(location = as.factor(location), continent = as.factor(continent), iso_code = as.factor(iso_code), date = (as.Date(date, format= "%Y-%m-%d")),tests_units = as.factor(tests_units)) %>% 
        mutate(cumulative.tpr = (total_cases/total_tests)*100, daily.tpr = (new_cases/new_tests)*100) %>% 
        filter(!is.na(daily.tpr)) %>% 
        relocate(daily.tpr,cumulative.tpr) %>% 
        rename(country = location))
        
summary(owid)

#DELVE (Data Evaluation and Learning for Viral Epidemics) Dataset 
delve = read.csv(url("https://raw.githubusercontent.com/rs-delve/covid19_datasets/master/dataset/combined_dataset_latest.csv"))
delve <- (delve %>%
            mutate(DATE = as.Date(DATE, format= "%Y-%m-%d"), country_name = as.factor(country_name), ISO = as.factor(ISO)) %>%
            mutate(across(c(starts_with("npi") & !(npi_fiscal_measures|npi_international_support|npi_healthcare_investment|npi_vaccine_investment|npi_stringency_index)), as.factor)) %>% 
            rename (date = DATE, country = country_name))
          
summary(delve)

#Country Effective Reproductive Number Estimates from University of Oxford, Australian National University, and Harvard from http://epidemicforecasting.org/
Rt <- read.csv("https://storage.googleapis.com/static-covid/static/v4/main/r_estimates.csv")
Rt <- (Rt %>%
         mutate(Date = as.Date(Date, format= "%Y-%m-%d"), X=NULL) %>%
         filter(!grepl ("^US-", Code)) %>% 
         mutate(country = countrycode(Code, "iso2c","country.name"),country =as.factor(country)) %>% #converting country codes to country names. US states not converted 
         rename(date=Date))
summary(Rt)