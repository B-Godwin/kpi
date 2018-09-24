## SLA Ingestion project
###### Author: Jeremy Botha
###### Version: 0.1

This is an automated SLA reporting tool for Jira incidents and Pingdom API uptime for the montly
SLA report.  It is intended to *mostly* automate stat generation, requiring minimal collation where
users comply with the established JIRA incident policy

#### Overview

This tool is intended to automatically download and aggregate Pingdom API statistics for status checks tagged
as *api* endpoints on Pingdom.

It retrieves each status endpoint for the specified date range, and aggregates these into a single bucket
and from there into an overall Nexmo public api uptime.

The tool also makes use of custom JQL in order to query Incidents occurring within the specified date range,
 for which it attempts to calculate average response time - note that these metrics are not fully reliable as 
 we need to double check each incident's work history as a sanity check.  
 
#### Usage

    $ bundle exec ruby ./app.rb -h
    Usage: ./kpi.sh [options]
        -p                               Aggregate pingdom uptime stats for api filtered checks
        -j                               Aggregate jira issue tickets for sv1 - sv3 issues
        -sDATE                           Start date for the reporting range [default first of the month]
        -tDATE                           End date for the reporting range [default todays date]
        -h                               Prints these usage instructions

#### Pingdom stats

    $ bundle exec ruby ./app.rb -j -s2018-09-01 -p
    Retrieving pingdom stats for 2018-09-01 to 2018-09-24
    Generating Pingdom uptime report for 2018-09-01 00:00:00 to 2018-09-20 00:00:00
    Time: 00:00:07 100.00% Processed: 49 from 49
    API                  Uptime  Downtime Unmonitored Uptime %
    API-applications     1727580 240      180         99.9756
    API-auditevent       1727880 120      0           99.993
    API-conversions      1727700 120      180         99.9826
    API-image            1727760 240      0           99.9861
    API-messages         1727880 120      0           99.993
    API-NI               1727880 120      0           99.993
    API-ott              1727640 360      0           99.9791
    API-provisioning     1727760 60       180         99.9861
    API-redact           1727880 120      0           99.993
    API-SDK              1727880 120      0           99.993
    API-TTS              1728000 0        0           100.0
    API-vapi             1727880 120      0           99.993
    API-verify           1727880 120      0           99.993
    CSE-v1               1727872 128      0           99.99249999999999
    Dashboard-Admin      1727880 120      0           99.993
    Dashboard-Customer   1727880 120      0           99.993
    DEVELOPER            1728000 0        0           100.0
    EU-API-applications  1728000 0        0           100.0
    EU-API-calls         1728000 0        0           100.0
    EU2-API-messages     1728000 0        0           100.0
    HOOKS-HQ-releases    1727880 120      0           99.993
    HTTP-OTT-MO          1727640 360      0           99.9791
    HTTPS api-sng1-1     1728000 0        0           100.0
    HTTPS api-wdc1-1     1728000 0        0           100.0
    HTTPS api.nexmo.com  1727940 60       0           99.9965
    HTTPS rest-sng1-1    1727940 60       0           99.9965
    HTTPS rest-wdc1-1    1727760 240      0           99.9861
    HTTPS rest-wdc1-2    1727760 60       180         99.9861
    HTTPS rest.nexmo.com 1728000 0        0           100.0
    HTTPS-API-EU-1       1728000 0        0           100.0
    HTTPS-API-SG-1       1728000 0        0           100.0
    HTTPS-API-US-1       1727940 60       0           99.9965
    HTTPS-API-US-2       1727820 0        180         99.98949999999999
    OTT-MO               1727580 420      0           99.9756
    REST-devapi          1727760 240      0           99.9861
    REST-NI              1727760 240      0           99.9861
    REST-SMS             1726800 1200     0           99.9305
    REST-SNS             1727880 120      0           99.993
    REST-USSC            1727760 240      0           99.9861
    SIP-AP1              1728000 0        0           100.0
    SIP-AP2              1727820 0        180         99.98949999999999
    SIP-EU1              1728000 0        0           100.0
    SIP-EU2              1728000 0        0           100.0
    SIP-IN-AP1           1728000 0        0           100.0
    SIP-IN-EU1           1728000 0        0           100.0
    SIP-IN-US1           1728000 0        0           100.0
    SIP-US1              1728000 0        0           100.0
    SIP-US2              1728000 0        0           100.0
    WWW                  1728000 0        0           100.0
    Totals               97366072 5648     1080        4899.659900000001
    Average              1987062  115      22          99.99305918367348

#### Jira stats

    $ bundle exec ruby app.rb -j
    Retrieving jira stats for 2018-09-01 to 2018-09-24
    Post mortem url: https://nexmoinc.atlassian.net/wiki/spaces/IM/pages/
    
    Ticket Severity Created                      Resolved                     Duration Post-mortem
    IM-171 Sev3     2018-09-13T07:30:00.000+0100 2018-09-14T18:30:00.000+0100 2100     http://bit.ly/2O2NOzM
    IM-168 Sev1     2018-09-11T12:32:00.000+0100 2018-09-11T17:05:00.000+0100 273      http://bit.ly/2O2NPUm
    IM-167 Sev3     2018-09-07T19:00:00.000+0100 2018-09-09T15:00:00.000+0100 2640     http://bit.ly/2ObgqHa
    
    Totals count    mean duration
    Sev1   1        273.0
    Sev2   0        0
    Sev3   2        2370.0    

###### Changelog

* initial version