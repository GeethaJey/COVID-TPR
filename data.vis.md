Data Visualization
================
Geetha
23/08/2020

## Overview of Global Performance

South Korea, Vietnam, Germany and New Zealand have been highlighted by
[Exemplars in Global
Health](https://www.exemplars.health/emerging-topics/epidemic-preparedness-and-response/covid-19)
as countries that are doing comparatively well in managing their
outbreak. Mexico, India, Indonesia, and Argentina are examples of
countries that have not yet “bent the curve”, many with quite high test
positivity rates.

#### Metrics

  - Test positivity rate: daily TPR, cumulative TPR
  - Number of Deaths (daily, cumulative, per million, per thousand,
    smoothed over 7 days)
  - Number of cases (daily, cumulative per million, per thousand,
    smoothed over 7 days)
  - Number of tests (raw,per million, per thousand, smoothed over 7
    days)

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
  - only use OECD countries (this is what is currently used for the
    graphs below)
  - only WHO member states
  - completeness of dataset (must have test data for X% of sample
    period)

Below, independent variables that were not time dependent (health
indices)

# Metrics Over Time

### Testing

#### Number of Tests

![](data.vis_files/figure-gfm/testing-1.png)<!-- -->

#### Test Positivity Rates Over Time

![](data.vis_files/figure-gfm/ctpr-1.png)<!-- -->

![](data.vis_files/figure-gfm/dtpr-1.png)<!-- -->

#### Number of Cases

![](data.vis_files/figure-gfm/cases-1.png)<!-- -->

#### Number of Deaths

![](data.vis_files/figure-gfm/deaths-1.png)<!-- -->

## Non Pharmaceutical Interventions

##### Overal Government Stringency Score

![](data.vis_files/figure-gfm/NPI-1.png)<!-- -->

### Interventions within Stringency Index

![](data.vis_files/figure-gfm/NPI%20interventions-1.png)<!-- -->

### Mask Policy

Intensity of mask policy within region.

1 - General recommendation

2 - Mandatory in specific regions of country or specific places (public
transport, inside shops)

3 - Mandatory everywhere or universal usage

![](data.vis_files/figure-gfm/masks-1.png)<!-- -->

## Disease Burden

Evaluating the effects of prevalence of diabetes (% of population),
smoking (% of group), and cardiovascular deaths (per 1000 people) on the
cumulative test positivity rate.
![](data.vis_files/figure-gfm/disease-1.png)<!-- -->

## Mobility Measures

Mobility Trends in % change relative to baseline, from Google Mobility
Reports. ![](data.vis_files/figure-gfm/mobility-1.png)<!-- -->

## Global Health Security Index

![](data.vis_files/figure-gfm/ghs%20index-1.png)<!-- -->

### GHSI Categories

![](data.vis_files/figure-gfm/ghs%20categories-1.png)<!-- -->

### Healthcare Access

Assessing relationship between healthcare access (measured by ghs
indices) and deaths
![](data.vis_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## Weather Variables

#### Humidity

![](data.vis_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

#### Temperature Speed

![](data.vis_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

#### Wind Speed

![](data.vis_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->
