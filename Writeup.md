Test Positivity Rate Writeup
================
Geetha Jeyapragasan
July 14 2020

The test positivity rate (TPR) is the percentage of tests that are
positive.For COVID-19, this metric is being used to evaluate testing
capacity and regime, as well as and severity of an outbreak, (i.e. if
two regions had the same number of cases but one region was conducting
twice the number of tests, it would suggest the region with the higher
positivity rate may be experiencing a more severe outbreak). If the TPR
is too high, it might indicate the region is only testing those who are
extremely sick and seeking medical attention, without sampling the wider
community. A low TPR can indicate sufficient testing capacity. However
due to several factors influencing the test positivity rate, it is not a
direct indicator of testing capacity. The test positivity rate has been
used as a measure of prevalence for outbreaks that occur in regions with
limited or non-existent health surveillance.

## Factors that Affect the TPR

1.  Type of tests included in metric. Some regions are not transparent
    in the technologies used for COVID-19 tests, or aggregate PCR and
    antibody tests making the data less meaningful.
2.  Whether the numbers are \# of performed tests or \# of individuals
    tested.
3.  Whether negative results are included, and how pending results or
    inconclusive results are reported.
4.  Are tests from private labs included? Not all labs report to the
    central authority, or are specifically not included in the testing
    data (i.e. US CDC)
5.  Testing eligibility criteria
6.  Whether the time period of cumulative counts if daily counts are not
    being reported.

### How the TPR is being used and interpreted

  - As of May 12, The WHO is currently advising reopening measures based
    on the TPR. The test positivity rate should be below 5% for at least
    14 days before reopening, suggesting a TPR between
    [3-12%](https://www.who.int/news-room/commentaries/detail/advice-on-the-use-of-point-of-care-immunodiagnostic-tests-for-covid-19)
    indicates a region is conducting adequate testing.
  - The [CDC opening up
    plan](https://www.cdc.gov/coronavirus/2019-ncov/downloads/php/CDC-Activities-Initiatives-for-COVID-19-Response.pdf)
    uses the TPR to assess testing program robustness. The criteria
    proposes a \<20% TPR to enter Phase 1, \<15% to enter Phase 2 and
    \<10% to enter Phase 3 (maintaining these values for at least 14
    days). \*\* Multi-day increases in TPR with stable or increasing
    testing suggest potential a potential rebound that should be
    investigated.
  - The TPR was used to compare the temporal trends and mitigation
    strategies of COVID-19 between [Seattle and
    Washington](https://jamanetwork.com/journals/jama/fullarticle/2766035)
    . The paper concluded due to the constant testing volume over the
    study period, the TPR trend suggests early and aggressive physical
    distancing measures influenced the course of the outbreak.
  - TPR as an good indicator of robust testing and outbreak control was
    [criticized in
    India](https://thewire.in/health/india-covid-19-testing-contradiction-rate)
    due to the extremely low testing volume (India is conducting 9.99
    tests per 1000 people while Australia conducts 136 tests per 1000).
    Though low testing rates did not fully account for the low TPR, a
    low TPR in regions with low testing rates should be interpreted
    differently than regions with a high testing rate.
  - The [CDC’s initial
    mixup](https://www.theatlantic.com/health/archive/2020/05/cdc-and-states-are-misreporting-covid-19-test-data-pennsylvania-georgia-texas/611935/)
    of viral and antibody tests reported together caused positivity
    rates to appear low. Several states such as Pennsylvania, Texas,
    Georgia, Vermont, and Virginia have used the aggregated TPR to guide
    reopening. In the state of Virginia, the antibody test results were
    combined with the viral PCR tests affecting the TPR. With the state
    using the low TPR to justify the loosening of lockdown
    restrictions,types of tests included in the metric should be
    considered when interpreting the value and used for decision making.
    Virginia has since separated the tests following this article.

The WHO recommendation for malaria program managers suggest the use of
TPR instead of incidence rates as a measurement if the following 3
factors are inconsistent over time: general outpatient attendance,
testing practices, and reporting completeness. Outpatient attendance may
be affected by transportation accessibility, user fees, political
instability, or general behaviour of treating illnesses at home through
over the counter medication or informal drug distributors. If
private-for-profit or informal health care providers are taken into
account, reporting completeness may be a significant barrier. The TPR is
less sensitive to these factors, through it can still be distorted and
misinterpreted.

``` r
summary(national)
```

    ##                        prname         date               numconf      
    ##  Canada                   :135   Min.   :2020-03-11   Min.   :   103  
    ##  Alberta                  :  0   1st Qu.:2020-04-13   1st Qu.: 26354  
    ##  British Columbia         :  0   Median :2020-05-17   Median : 76991  
    ##  Manitoba                 :  0   Mean   :2020-05-17   Mean   : 64765  
    ##  New Brunswick            :  0   3rd Qu.:2020-06-19   3rd Qu.:100813  
    ##  Newfoundland and Labrador:  0   Max.   :2020-07-23   Max.   :112659  
    ##  (Other)                  :  0                                        
    ##     numprob        numdeaths         numtotal        numtested      
    ##  Min.   :  0.0   Min.   :   2.0   Min.   :   103   Min.   :  11023  
    ##  1st Qu.: 11.0   1st Qu.: 841.5   1st Qu.: 26372   1st Qu.: 446229  
    ##  Median : 11.0   Median :5782.0   Median : 77002   Median :1300729  
    ##  Mean   : 22.2   Mean   :4859.2   Mean   : 64788   Mean   :1456374  
    ##  3rd Qu.: 12.5   3rd Qu.:8378.0   3rd Qu.:100824   3rd Qu.:2361172  
    ##  Max.   :833.0   Max.   :8874.0   Max.   :112672   Max.   :3697322  
    ##                                                                     
    ##    numrecover    percentrecover       ratetested       numtoday     
    ##  Min.   :  230   Length:135         Min.   :  293   Min.   :   0.0  
    ##  1st Qu.:26505   Class :character   1st Qu.:11871   1st Qu.: 363.5  
    ##  Median :48892   Mode  :character   Median :34604   Median : 722.0  
    ##  Mean   :46448                      Mean   :38744   Mean   : 834.0  
    ##  3rd Qu.:65850                      3rd Qu.:62815   3rd Qu.:1252.5  
    ##  Max.   :98519                      Max.   :98361   Max.   :2760.0  
    ##  NA's   :28                                                         
    ##   percentoday       ratetotal        ratedeaths     deathstoday    
    ##  Min.   : 0.000   Min.   :  0.27   Min.   : 0.01   Min.   :  0.00  
    ##  1st Qu.: 0.415   1st Qu.: 70.16   1st Qu.: 2.24   1st Qu.: 10.00  
    ##  Median : 1.500   Median :204.85   Median :15.38   Median : 49.00  
    ##  Mean   : 5.951   Mean   :172.36   Mean   :12.93   Mean   : 65.72  
    ##  3rd Qu.: 5.635   3rd Qu.:268.23   3rd Qu.:22.29   3rd Qu.:114.50  
    ##  Max.   :46.230   Max.   :299.75   Max.   :23.61   Max.   :222.00  
    ##                                                                    
    ##   percentdeath    testedtoday    recoveredtoday    percentactive  
    ##  Min.   :0.790   Min.   :    0   Min.   :    0.0   Min.   : 3.78  
    ##  1st Qu.:3.190   1st Qu.:16768   1st Qu.:  367.5   1st Qu.:28.96  
    ##  Median :7.480   Median :27304   Median :  680.0   Median :42.43  
    ##  Mean   :5.882   Mean   :27388   Mean   :  973.1   Mean   :52.71  
    ##  3rd Qu.:8.170   3rd Qu.:37648   3rd Qu.:  908.0   3rd Qu.:83.67  
    ##  Max.   :8.330   Max.   :78091   Max.   :23853.0   Max.   :99.21  
    ##                                  NA's   :28                       
    ##    numactive       rateactive    numtotal_last14 numdeaths_last14
    ##  Min.   :  101   Min.   : 0.27   Min.   : 2715   Min.   :  25.0  
    ##  1st Qu.:15595   1st Qu.:41.48   1st Qu.: 5199   1st Qu.: 260.2  
    ##  Median :27784   Median :73.91   Median :12468   Median : 850.0  
    ##  Mean   :23114   Mean   :61.49   Mean   :12503   Mean   :1011.7  
    ##  3rd Qu.:31700   3rd Qu.:84.33   3rd Qu.:18799   3rd Qu.:1616.0  
    ##  Max.   :35001   Max.   :93.11   Max.   :24688   Max.   :2311.0  
    ##                                  NA's   :13      NA's   :13      
    ##       tpr       
    ##  Min.   :0.888  
    ##  1st Qu.:3.428  
    ##  Median :4.776  
    ##  Mean   :4.557  
    ##  3rd Qu.:5.912  
    ##  Max.   :6.742  
    ## 

### Canada Test Positivity Rate

![](Writeup_files/figure-gfm/tpr-1.png)<!-- -->

### Canada Testing Rates

![](Writeup_files/figure-gfm/pressure-1.png)<!-- --> \#\#\# Test Rate
against TPR

``` r
print(
  ggplot(national, aes(ratetested, tpr)) + 
  geom_point() + xlab("Test Rate") + 
  ylab("Test Positivity Rate") +
  ggtitle("Test rate against test positivity rate")
)
```

![](Writeup_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->
