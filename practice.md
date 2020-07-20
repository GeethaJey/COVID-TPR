Test Positivity Rate writeup
================
Geetha Jeyapragasan
July 14 2020

## Test Positivity Rates

The test positivity rate (TPR) is the percentage of tests that are
positive.For COVID-19, this metric is being used to evaluate testing
capacity and regime, as well as and severity of an outbreak, (i.e. if
two regions had the same number of cases but one region was conducting
twice the number of tests, it would suggest the region with the higher
positivity rate may be experiencing a more severe outbreak). If the
positivity rate is too high, it might indicate the region is only
testing those who are extremely sick and seeking medical attention,
without sampling the wider community. A low test positivity rate can
indicate sufficient testing capacity. The WHO has suggested it is safe
for regions to reopen if the positivity rate remains ≥ 5% for at least
14 days <https://coronavirus.jhu.edu/testing/testing-positivity>.
However due to several factors influencing the test positivity rate, it
is not a direct indicator of testing capacity. Aside from COVID-19, the
positivity rate has been used to assess the incidence Malaria and Ebola
incidence in areas with limited health infrastructure.

``` r
summary(national)
```

    ##                        prname         date               numconf      
    ##  Canada                   :131   Min.   :2020-03-11   Min.   :   103  
    ##  Alberta                  :  0   1st Qu.:2020-04-12   1st Qu.: 25014  
    ##  British Columbia         :  0   Median :2020-05-15   Median : 74602  
    ##  Manitoba                 :  0   Mean   :2020-05-15   Mean   : 63326  
    ##  New Brunswick            :  0   3rd Qu.:2020-06-16   3rd Qu.: 99649  
    ##  Newfoundland and Labrador:  0   Max.   :2020-07-19   Max.   :110327  
    ##  (Other)                  :  0                                        
    ##     numprob        numdeaths         numtotal        numtested      
    ##  Min.   :  0.0   Min.   :   2.0   Min.   :   103   Min.   :  11023  
    ##  1st Qu.: 11.0   1st Qu.: 748.5   1st Qu.: 25032   1st Qu.: 429838  
    ##  Median : 11.0   Median :5562.0   Median : 74613   Median :1236746  
    ##  Mean   : 22.5   Mean   :4736.9   Mean   : 63348   Mean   :1389794  
    ##  3rd Qu.: 11.5   3rd Qu.:8233.5   3rd Qu.: 99660   3rd Qu.:2235606  
    ##  Max.   :833.0   Max.   :8852.0   Max.   :110338   Max.   :3520542  
    ##                                                                     
    ##    numrecover    percentrecover       ratetested       numtoday     
    ##  Min.   :  230   Length:131         Min.   :  293   Min.   :   0.0  
    ##  1st Qu.:25462   Class :character   1st Qu.:11435   1st Qu.: 350.5  
    ##  Median :47533   Mode  :character   Median :32902   Median : 736.0  
    ##  Mean   :44447                      Mean   :36973   Mean   : 841.7  
    ##  3rd Qu.:64898                      3rd Qu.:59474   3rd Qu.:1261.0  
    ##  Max.   :97051                      Max.   :93658   Max.   :2760.0  
    ##  NA's   :28                                                         
    ##   percentoday       ratetotal        ratedeaths      deathstoday    
    ##  Min.   : 0.000   Min.   :  0.27   Min.   : 0.005   Min.   :  0.00  
    ##  1st Qu.: 0.415   1st Qu.: 66.59   1st Qu.: 1.991   1st Qu.: 11.50  
    ##  Median : 1.580   Median :198.50   Median :14.797   Median : 51.00  
    ##  Mean   : 6.116   Mean   :168.53   Mean   :12.602   Mean   : 67.56  
    ##  3rd Qu.: 5.920   3rd Qu.:265.13   3rd Qu.:21.904   3rd Qu.:116.00  
    ##  Max.   :46.230   Max.   :293.54   Max.   :23.549   Max.   :222.00  
    ##                                                                     
    ##   percentdeath   testedtoday    recoveredtoday    percentactive  
    ##  Min.   :0.79   Min.   :    0   Min.   :    0.0   Min.   : 3.78  
    ##  1st Qu.:2.99   1st Qu.:16628   1st Qu.:  367.5   1st Qu.:29.80  
    ##  Median :7.45   Median :26836   Median :  691.0   Median :43.10  
    ##  Mean   :5.82   Mean   :26874   Mean   :  996.6   Mean   :54.18  
    ##  3rd Qu.:8.17   3rd Qu.:36470   3rd Qu.:  921.0   3rd Qu.:84.33  
    ##  Max.   :8.33   Max.   :78091   Max.   :23853.0   Max.   :99.21  
    ##                                 NA's   :28                       
    ##       tpr       
    ##  Min.   :0.888  
    ##  1st Qu.:3.530  
    ##  Median :4.882  
    ##  Mean   :4.602  
    ##  3rd Qu.:5.934  
    ##  Max.   :6.742  
    ## 

### Canada Test Positivity Rate

![](practice_files/figure-gfm/tpr-1.png)<!-- -->

### Canada Testing Rates

![](practice_files/figure-gfm/pressure-1.png)<!-- -->
