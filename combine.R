
callArgs <- "combine.Rout combine.R owid.csv delve.csv Rt.csv odb.csv USstatedata.csv USmobility.csv goc.csv goc_metadata.csv"

library(ggplot2)
library(dplyr)
library(countrycode)
library(gsheet)
library(tidyr)
library(readxl)
library(stringr)

source("makestuff/makeRfuns.R")

#GLOBAL DATASETS
#####################
#Our world in data daily test positivity rate smoothed over 7 days
owid <- read.csv(matchFile("owid.csv"))

owid <- (owid %>% 
        mutate(location = as.factor(location), continent = as.factor(continent), iso_code = as.factor(iso_code), date = (as.Date(date, format= "%Y-%m-%d")),tests_units = as.factor(tests_units)) %>% 
        mutate(cumulative.tpr = (total_cases/total_tests)*100, daily.tpr = (new_cases/new_tests)*100) %>% 
        filter(!is.na(daily.tpr)) %>% 
        select (!(total_cases:stringency_index)) %>%         
        rename(country = location, ISO = iso_code))
        
summary(owid)


#DELVE (Data Evaluation and Learning for Viral Epidemics) Dataset 
delve = read.csv(matchFile("delve.csv"))
delve <- (delve %>%
            mutate(DATE = as.Date(DATE, format= "%Y-%m-%d"), country_name = as.factor(country_name), ISO = as.factor(ISO)) %>%
            mutate(across(c(starts_with("npi") & !(npi_fiscal_measures|npi_international_support|npi_healthcare_investment|npi_vaccine_investment|npi_stringency_index)), as.factor)) %>% 
            rename (date = DATE, country = country_name))
          
#summary(delve)



#Country Effective Reproductive Number Estimates from University of Oxford, Australian National University, and Harvard from http://epidemicforecasting.org/
Rt <- read.csv(matchFile("Rt.csv"))
Rtcountry <- (Rt %>%
                      mutate(Date = as.Date(Date, format= "%Y-%m-%d"), X = NULL) %>%
                      filter(!grepl ("^US-", Code), !grepl ("^AU-", Code), !grepl ("^CN-", Code)) %>% 
                      mutate(country = countrycode(Code, "iso2c","country.name"), country =as.factor(country)) %>% #converting country codes to country names. States not converted 
                      rename(date=Date))
#summary(Rtcountry)

#Open Data Barometer (Openness of data measurement)
odb <- read.csv(matchFile("odb.csv")) 
odb <- odb %>% select (ISO3:ODB.Scaled) %>% rename(country = Country, ISO = ISO3)
#summary(odb)

#global health security index (from https://www.ghsindex.org/wp-content/uploads/2019/10/Global-Health-Security-Index-2019-Final-October-2019.zip) *will update with better link once .xlsm data import figured out
ghsrange <- "N4:OP267"
ghslast <- 197
# importing the iScores sheet of the xlsm file,
GHSI <- read_excel("ghsindex.xlsm",sheet = "iScores", range = ghsrange,col_names = TRUE) 
GHSI <- t(GHSI)
#making the first row the column names
ghscoltitle <- GHSI[1,] 
colnames(GHSI, do.NULL = TRUE, prefix = "col" )
colnames(GHSI) <- ghscoltitle
#turn excel matrix into data frame
GHSI <- as.data.frame(GHSI)
names(GHSI) <- (names(GHSI) %>% str_replace_all("\\s","_"))
GHSI <- (GHSI %>%
                 rename(country = Indicators) %>% 
                 rename( '1)prevent' = `1)_PREVENTION_OF_THE_EMERGENCE_OR_RELEASE_OF_PATHOGENS`, '2)Detect' = `2)_EARLY_DETECTION_&_REPORTING_EPIDEMICS_OF_POTENTIAL_INTERNATIONAL_CONCERN`, '3)Response' = `3)_RAPID_RESPONSE_TO_AND_MITIGATION_OF_THE_SPREAD_OF_AN_EPIDEMIC`,'4)Health' = `4)_SUFFICIENT_&_ROBUST_HEALTH_SECTOR_TO_TREAT_THE_SICK_&_PROTECT_HEALTH_WORKERS`,'5)Norms' = `5)_COMMITMENTS_TO_IMPROVING_NATIONAL_CAPACITY,_FINANCING_AND_ADHERENCE_TO_NORMS`, '6)Risk' = `6)_OVERALL_RISK_ENVIRONMENT_AND_COUNTRY_VULNERABILITY_TO_BIOLOGICAL_THREATS`) %>% 
                 slice(2:ghslast) %>% 
                 mutate_at(vars(-country), as.numeric))

# Putting together global Dataset
global <- full_join(owid, delve, by = c("country", "date"))
global <- full_join(global,Rtcountry, by = c("country", "date")) 
global <- full_join (global, odb, by = "country", "ISO")
global <- full_join(global, GHSI, by = "country")


global <- (global %>% 
                   mutate(ISO = as.factor(ISO), country = as.factor(country)))


summary(global)


# # US DATA 
# ############
# 
# #Covid-Tracking project
# USstatedata <- read.csv(matchFile("USstatedata.csv"))
# USstatedata <- (USstatedata %>% 
#                          select(-c(hash, lastUpdateEt, dateModified , checkTimeEt, dateChecked, dateModified, hospitalized, negativeIncrease, posNeg, fips, commercialScore, negativeRegularScore, negativeScore, positiveScore, score, grade)) %>% 
#                          mutate(state = as.factor(state), daily.tpr = (positive/totalTestResults)*100, cumulative.tpr = cumsum(as.numeric(positive))/cumsum(as.numeric(totalTestResults))) %>% 
#                          mutate(date = as.character(date)) %>% 
#                          mutate(date = as.Date(date, format("%Y%m%d"))))
# 
# #Effective Reproductive Number Estimates from from http://epidemicforecasting.org/
# Rtstate <-  (Rt %>%
#                      mutate(Date = as.Date(Date, format= "%Y-%m-%d"), X = NULL) %>%
#                      filter(grepl ("^US-", Code)) %>%
#                      separate(Code, c("country","state")) %>% 
#                      mutate (state = as.factor(state), country = as.factor(country)) %>% 
#                      rename (date = Date))
# summary(Rtstate)
# 
# #US mobility 
# US_mobility <- read.csv(matchFile("USmobility.csv"))
# US_mobility <- (US_mobility %>% 
#         filter(grepl("^US-",iso_3166_2_code)) %>% 
#                        separate(iso_3166_2_code, c("country", "state")))
# str(US_mobility)
# # Putting Together US Dataset
# 
# USstatedata <- full_join(USstatedata, Rtstate, by = c("date", "state"))
# 
# #Canada Data
# ###############
# #Government of Canada (GOC) COVID-19 Dataset 
# goc = read.csv("https://health-infobase.canada.ca/src/data/covidLive/covid19.csv")
# goc_metadata = read.csv("https://health-infobase.canada.ca/src/data/covidLive/covid19-data-dictionary.csv")
# 
#  goc <- (goc %>%
#                  mutate (pruid = NULL,prnameFR = NULL) %>% 
#                  mutate(date = as.Date(date, format= "%d-%m-%Y")) %>%
#                  mutate (prname = as.factor(prname)) %>%
#                  mutate (cumulative.tpr = (numconf/numtested)*100))
#  
# summary(goc)
# #  Create Subset to for only National Canada Data
# canada <- full_join(goc, delve, by = c("prname" = "country","date"))
# canada <- full_join(canada, Rtcountry,by = c("prname" = "country"))
# canada <- (canada %>% 
#                       filter(grepl ("Canada", prname)) %>%
#                       mutate(npi_masks = as.factor(npi_masks)) %>% 
#                       mutate(npi_testing_policy = as.factor(npi_testing_policy)) %>% 
#                       mutate(Code = NULL, X = NULL, Date = NULL))
# summary(canada)