Data Visualization
================
Geetha

## Overview of Global Performance

South Korea, Vietnam, Germany and New Zealand have been highlighted by
[Exemplars in Global
Health](https://www.exemplars.health/emerging-topics/epidemic-preparedness-and-response/covid-19)
as countries that are doing comparatively well in managing their
outbreak. Mexico, India, Indonesia, and Argentina are examples of
countries that have not yet “bent the curve”, many with quite high test
positivity rates. The graphs below only include the 36 [Organisation for
Economic Co-operation and Development (OECD) Member
States](https://www.oecd.org/about/members-and-partners/).

#### Metrics

  - Test positivity rate: daily TPR, cumulative TPR
  - Number of Deaths (daily, cumulative, per million, per thousand,
    smoothed over 7 days)
  - Number of cases (daily, cumulative, per million, per thousand,
    smoothed over 7 days)
  - Number of tests (daily, cumulative, per million, per thousand,
    smoothed over 7 days)

Potential Independent variables:

  - Non-pharmaceutical interventions: closings, masks, lockdown, debt
    relief, etc.
  - GHS index: overall score, category scores, sub-indicator scores
  - Country characteristics: population, pop density, median age, % pop
    \> 65 y/0, % pop \> 70 y/o, GDP
  - Disease burden: cardiovascular disease, diabetes, smoking, life
    expectancy
  - Weather: temp, wind, humidity, precipitation

Potential Options for Inclusion/Exclusion Criteria:

  - remove countries with \> 100 number of confirmed cases (some papers
    have used 1000)
  - remove countries with population \>1,000,000
  - only use OECD countries
  - only WHO member states
  - completeness of dataset (must have test data for X% of sample
    period)

Below, independent variables that were not time dependent
(i.e. healthcare access indices) were evaluated with cumulative
tests/cases/deaths, while time dependent variables (i.e. changes in non
pharmaceutical interventions) were evaluated with daily rates and
cumulative rates. Line plots and parallel coordinate plots were
primarily used to evaluate any correlations.

# Metrics Over Time

## Testing

![](data.vis_files/figure-gfm/testing-1.png)<!-- -->

``` r
# Plot 1: Line graph to visualize/compare daily TPR over time
ctpr <- ggplot(reduced, aes(x = date, y = cumulative.tpr, group=country)) + 
  geom_line(aes(color=country)) + xlab("Date") + 
  ylab("Cumulative Test Positivity Rate (%)") +
  ggtitle("Cumulative TPR Over Time") + 
  labs(color="Country") +
  theme(plot.title = element_text(hjust = 0.5))
print(ctpr)
```

![](data.vis_files/figure-gfm/ctpr-1.png)<!-- -->

``` r
dtpr <- ggplot(reduced, aes(x = date, y = daily.tpr, group=country)) + 
  geom_line(aes(color=country)) + xlab("Date") + 
  ylab("Daily Test Positivity Rate (%)") +
  ggtitle("Daily TPR Over Time") + 
  labs(color="Country") +
  theme(plot.title = element_text(hjust = 0.5))
print(dtpr)
```

![](data.vis_files/figure-gfm/dtpr,%20-1.png)<!-- -->

## Number of Cases

``` r
newcases <- ggplot(reduced, aes(x = date, y = cases_new_per_million, group=country)) + 
  geom_line(aes(color=country)) + xlab("Date") + 
  ylab("New Cases Per Million") +
  ggtitle("Number of New Cases per Million People") + 
  labs(color="Country") +
  theme(plot.title = element_text(hjust = 0.5))
print(newcases)
```

![](data.vis_files/figure-gfm/cases-1.png)<!-- -->

## Number of Deaths

``` r
newdeaths <- ggplot(reduced, aes(x = date, y = deaths_new_per_million, group=country)) + 
  geom_line(aes(color=country)) + xlab("Date") + 
  ylab("New Deaths Per Million") +
  ggtitle("Number of New Deaths per Million People") + 
  labs(color="Country") +
  theme(plot.title = element_text(hjust = 0.5))
print(newdeaths)
```

![](data.vis_files/figure-gfm/deaths-1.png)<!-- -->

## Country Characteristics

``` r
pop.den <- ggplot(reduced, aes(x=population_density,y=cases_total_per_million))+ 
  geom_point(alpha=0.5) +
  geom_smooth(method = "lm") +
  xlab("Population Density (people/ square km)") + ylab("Total cases/million people") + 
  ggtitle("Population density and total cases/million people") +
  theme(plot.title = element_text(hjust = 0.5))
print(pop.den)
```

![](data.vis_files/figure-gfm/population%20density-1.png)<!-- -->

## Non Pharmaceutical Interventions

##### Overal Government Stringency Score

Overall score is composed of: school closings, workplace closings,
cancellation of public events, restrictions on gatherings (by size),
public transit closures, stay at home restrictions,internal movement
restrictions, international travel controls, public information.

``` r
npi <- ggplot(reduced, aes(x= npi_stringency_index, y=cases_new_per_million, 
                      color=country))+ 
  geom_boxplot()+
  labs(col="Country")+
  xlab("NPI Stringency Index") + ylab("New Cases/Million People") + 
  ggtitle("New Cases and NPI Stringency Index") +
  theme(plot.title = element_text(hjust = 0.5))
print(npi)
```

![](data.vis_files/figure-gfm/overall%20stringency%20score-1.png)<!-- -->

### Interventions within Stringency Index

No clear relationship between any specific measures and number of new
cases per million.

``` r
#Tried to see the effect of new deaths/million, new cases/million, and daily tpr but didn't see any trend
npi_int <- ggparcoord(reduced, columns = c(22:29, 35, 36, 40),
                  groupColumn = "cases_new_per_million", scale="uniminmax", alphaLines=0.1) +
  xlab("NPI Category") + ylab("Value (scaled between 0 and 1") + 
  ggtitle("Effect of NPIs on New Cases/Million") +
  theme_minimal()+ theme(plot.title = element_text(hjust = 0.5)) + theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(npi_int)
```

![](data.vis_files/figure-gfm/NP%20interventions-1.png)<!-- -->

### Mask Policy

Intensity of mask policy within region.

1 - General recommendation

2 - Mandatory in specific regions of country or specific places (public
transport, inside shops)

3 - Mandatory everywhere or universal usage

``` r
mask <- ggplot(reduced, aes(x=npi_masks, y=cumulative.tpr))+ 
  geom_boxplot()+
  xlab("Mask Policy") + ylab("Cumulative Test Positivity Rate") + 
  ggtitle("Mask Policy and Cumulative Test Positivity Rate") +
  theme(plot.title = element_text(hjust = 0.5))
print(mask)
```

![](data.vis_files/figure-gfm/masks-1.png)<!-- -->

## Disease Burden

Evaluating the effects of prevalence of diabetes (% of population),
smoking (% of group), and cardiovascular deaths (per 1000 people) on the
cumulative test positivity rate.

``` r
# Disease burden factors and cTPR
db <- ggparcoord(reduced, columns = 12:15,
                  groupColumn = "cumulative.tpr", scale="uniminmax", alphaLines=0.1) +
  xlab("Disease burden") + ylab("Value") + ggtitle("Disease burden and cumulative TPR") +
  theme_minimal()+ theme(plot.title = element_text(hjust = 0.5)) + theme(axis.text.x = element_text(angle = 0, hjust = 0.5))
print(db)
```

![](data.vis_files/figure-gfm/disease-1.png)<!-- -->

## Mobility Measures

Mobility Trends in % change relative to baseline, from Google Mobility
Reports.

  - Retail: restaurants, cafes, shopping centers, theme parks, museums,
    libraries, and movie theaters.
  - Grocery/Pharmacy: grocery markets, food warehouses, farmers markets,
    specialty food shops, drug stores, and pharmacies
  - Parks: national parks, public beaches, marinas, dog parks, plazas,
    and public gardens
  - Transit: public transport hubs such as subway, bus, and train
    stations.

<!-- end list -->

``` r
pcp <- ggparcoord(reduced, columns = 64:72,
                  groupColumn = "cases_total_per_million", scale="uniminmax", alphaLines=0.1) +
  xlab("mobility factors") + ylab("Value") + 
  ggtitle("Mobility factors and total cases per million people") +
  theme(plot.title = element_text(hjust = 0.5)) + theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(pcp)
```

![](data.vis_files/figure-gfm/mobility-1.png)<!-- -->

## Global Health Security Index

Lower overall GHSindex scores appear to be corellated with lower daily
and cumulative tpr.

``` r
# Plot 1: Line graph to visualize/compare daily TPR over time
ghs <- ggparcoord(reduced, columns = c(19, 20, 45, 47, 51),
                  groupColumn = "OVERALL_SCORE", scale="uniminmax", alphaLines=0.1) +
  xlab("COVID-19 Data") + ylab("Scaled Values") + ggtitle("GHS Index vs outbreak/testing indicators") +
  labs(col = c("1","2")) +
  theme_minimal()+ theme(plot.title = element_text(hjust = 0.5)) + theme(axis.text.x = element_text(angle = 10, hjust = 0.5)) 
print(ghs)
```

![](data.vis_files/figure-gfm/ghs%20index-1.png)<!-- -->

### GHSI Categories

``` r
# Plot 1: Line graph to visualize/compare daily TPR over time
ghs <- ggparcoord(reduced, columns = c(97, 154, 191, 234, 273, 312),
                  groupColumn = "cumulative.tpr", scale="uniminmax", alphaLines=0.1) +
  xlab("GHS Indicator") + ylab("Scaled Indicator Value") + ggtitle("Cumulative TPR versus GHS") +
  labs(col = c("1","2")) +
  theme_minimal()+ theme(plot.title = element_text(hjust = 0.5)) 
print(ghs)
```

![](data.vis_files/figure-gfm/ghs%20categories-1.png)<!-- -->

## Healthcare Access

Assessing relationship between healthcare access indices (using the
global health security index) and deaths per million.

``` r
ghs <- ggparcoord(reduced, columns = c(237, 241, 242, 250, 252),
                  groupColumn = "deaths_total_per_million", scale="uniminmax", alphaLines=0.1) +
  xlab("Healthcare Access Indicators") + ylab("Scaled Values") + ggtitle("Deaths per million vs healthcare access measures") +
  labs(col = c("1","2")) +
  theme_minimal()+ theme(plot.title = element_text(hjust = 0.5)) + theme(axis.text.x = element_text(angle = 15, hjust = 0.5)) + scale_x_discrete(labels = function(x) str_wrap(x, width = 5 ))
print(ghs)
```

![](data.vis_files/figure-gfm/healthcare%20access-1.png)<!-- -->

# Weather Variables

## Humidity

``` r
# Humidity and total cases (upward trend)
hum <- ggplot(reduced, aes(x=weather_humidity_mean,y=cases_total_per_million))+ 
  geom_point(alpha=0.5) +
  geom_smooth(method = "lm") +
  xlab("Mean humidity (kg water vapour/kg air)") + ylab("Total cases/million people") + 
  ggtitle("Mean humidity and total cases/million people") +
  theme(plot.title = element_text(hjust = 0.5))
print(hum)
```

![](data.vis_files/figure-gfm/humidity%20-1.png)<!-- -->

## Temperature

``` r
temp <- ggplot(reduced, aes(x=weather_temperature_mean,y= cases_new_per_million))+ 
  geom_point(alpha=0.5) +
  geom_smooth(method = "lm") +
  xlab("Mean temperature (°C) ") + ylab("New cases/million people") + 
  ggtitle("Mean temperature and new cases/million people") +
  theme(plot.title = element_text(hjust = 0.5))
print(temp)
```

![](data.vis_files/figure-gfm/temperature-1.png)<!-- -->

## Wind

``` r
wind <- ggplot(reduced, aes(x=weather_wind_speed_mean, y= cases_new_per_million))+ 
  geom_point(alpha=0.5) +
  geom_smooth(method = "lm") +
  xlab("Mean wind speed (m/s)") + ylab("New cases/million people") + 
  ggtitle("Mean wind speed and new cases/million people") +
  theme(plot.title = element_text(hjust = 0.5))
print(wind)
```

![](data.vis_files/figure-gfm/wind-1.png)<!-- -->
