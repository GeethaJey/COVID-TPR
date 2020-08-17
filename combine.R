
callArgs <- "combine.Rout combine.R owid.csv delve.csv Rt.csv odb.csv USstatedata.csv USmobility.csv"

library(ggplot2)
library(dplyr)
library(countrycode)
library(gsheet)
library(tidyr)
library(readxl)


source("makestuff/makeRfuns.R")

#GLOBAL DATASETS
#####################
#Our world in data daily test positivity rate smoothed over 7 days
owid <- read.csv(matchFile("owid.csv"))

owid <- (owid %>% 
        mutate(location = as.factor(location), continent = as.factor(continent), iso_code = as.factor(iso_code), date = (as.Date(date, format= "%Y-%m-%d")),tests_units = as.factor(tests_units)) %>% 
        mutate(cumulative.tpr = (total_cases/total_tests)*100, daily.tpr = (new_cases/new_tests)*100) %>% 
        select (!(total_cases:stringency_index)) %>%         
        filter(!is.na(daily.tpr), daily.tpr <= 200) %>%
        filter(!is.na(cumulative.tpr)) %>% 
        rename(country = location))
        
summary(owid)


#DELVE (Data Evaluation and Learning for Viral Epidemics) Dataset 
delve = read.csv(matchFile("delve.csv"))
delve <- (delve %>%
            mutate(DATE = as.Date(DATE, format= "%Y-%m-%d"), country_name = as.factor(country_name), ISO = as.factor(ISO)) %>%
            mutate(across(c(starts_with("npi") & !(npi_fiscal_measures|npi_international_support|npi_healthcare_investment|npi_vaccine_investment|npi_stringency_index)), as.factor)) %>% 
            rename (date = DATE, country = country_name))
          
summary(delve)



#Country Effective Reproductive Number Estimates from University of Oxford, Australian National University, and Harvard from http://epidemicforecasting.org/
Rt <- read.csv(matchFile("Rt.csv"))
Rtcountry <- (Rt %>%
                      mutate(Date = as.Date(Date, format= "%Y-%m-%d"), X = NULL) %>%
                      filter(!grepl ("^US-", Code), !grepl ("^AU-", Code), !grepl ("^CN-", Code)) %>% 
                      mutate(country = countrycode(Code, "iso2c","country.name"), country =as.factor(country)) %>% #converting country codes to country names. States not converted 
                      rename(date=Date))
summary(Rtcountry)

#Open Data Barometer (Openness of data measurement)
odb <- read.csv(matchFile("odb.csv"))
odb <- odb %>% select ((ISO3:ODB.Scaled)) 
summary(odb)

#global health security index (from ghsindex.org) *will update with better link once .xlsm data import figured out
GHSI <- read_excel("ghsindex.xlsm",sheet = "iScores", range = "N4:OP267",col_names = TRUE)
GHSI <- t(GHSI)
ghscoltitle <- GHSI[1,]
colnames(GHSI, do.NULL = TRUE, prefix = "col" )
colnames(GHSI) <- ghscoltitle
GHSI <- as.data.frame(GHSI)
GHSI <- (GHSI %>%
                 rename(country = Indicators) %>% 
                 slice(2:197) %>% 
                 mutate_at(vars(-country), as.numeric))

# Putting together global Dataset
global <- full_join(owid, delve)
global <- full_join(global,Rtcountry) 
global <- full_join (global, odb)
global <- full_join(global, GHSI)

global <- (global %>% 
                   mutate(ISO = as.factor(ISO), country = as.factor(country)))

summary(global)



# US DATA 
############

#Covid-Tracking project
USstatedata <- read.csv(matchFile("USstatedata.csv"))
USstate_data <- (USstate_data %>% 
                         select(-c(hash, lastUpdateEt, dateModified , checkTimeEt, dateChecked, dateModified, hospitalized, negativeIncrease, posNeg, fips, commercialScore, negativeRegularScore, negativeScore, positiveScore, score, grade)) %>% 
                         mutate(state = as.factor(state), daily.tpr = (positive/totalTestResults)*100, cumulative.tpr = cumsum(as.numeric(positive))/cumsum(as.numeric(totalTestResults))) %>% 
                         mutate(date = as.character(date)) %>% 
                         mutate(date = as.Date(date, format("%Y%m%d"))))

#Effective Reproductive Number Estimates from from http://epidemicforecasting.org/
Rtstate <-  (Rt %>%
                     mutate(Date = as.Date(Date, format= "%Y-%m-%d"), X = NULL) %>%
                     filter(grepl ("^US-", Code)) %>%
                     separate(Code, c("country","state")) %>% 
                     mutate (state = as.factor(state), country = as.factor(country)) %>% 
                     rename (date = Date))
summary(Rtstate)

#US mobility 
US_mobility <- read.csv(matchFile("USmobility.csv"))
US_mobility <- US_mobility %>% 
        filter(grepl("^US-",iso_3166_2_code) %>% 
                       separate(iso_3166_2_code, c("country", "state"))                              )
# Putting Together US Dataset

USstate_data <- inner_join(USstate_data, Rtstate)

#Canada Data
###############
#Government of Canada (GoC) COVID-19 Dataset 
# goc = read.csv("https://health-infobase.canada.ca/src/data/covidLive/covid19.csv")
# goc_metadata = read.csv("https://health-infobase.canada.ca/src/data/covidLive/covid19-data-dictionary.csv")
# 
# goc <- (goc %>%
#                 mutate (pruid = NULL,prnameFR = NULL) %>% 
#                 mutate(date = as.Date(date, format= "%d-%m-%Y")) %>%
#                 mutate (prname = as.factor(prname)) %>%
#                 mutate (cumulative.tpr = (numconf/numtested)*100))
# 
# summary(goc)
# # Create Subset to for only National Canada Data
# national <- inner_join(goc, delve, by = c("prname" = "country"))
# national <- inner_join(national, Rt)
# national <- (national %>% 
#                      filter(prname == "Canada" & !is.na(tpr)) %>%
#                      mutate(npi_masks = as.factor(npi_masks)) %>% 
#                      mutate(npi_testing_policy = as.factor(npi_testing_policy))) 
#                      mutate(Code = NULL, X = NULL, Date = NULL))
