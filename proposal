# US Cities Status Related to Climate Change Risk and Resilience

## Problem

Notre Dame Global Adaptation Initiative (ND-GAIN) aims to help private and public sectors prioritize climate adaptation, ultimately lowering risk and enhancing readiness.   As part of the project, they released a study in October 2018 entitled 'Urban Adaptation Assessment' that reviews the status of 270 cities in the US. For each ctiy, they provide a summary of its risk and readiness to adapt to the expected change.

The data for their conclusions has been provided as well as a technical guide expanding on their study. I will re-evaluate their data to test their conclusions and develop some of my own.

After initial review of their data, I have found issues with both the data and their practices.  After an initial review of the data, I have found issues in the following categories:

1.  Inaccurate recording of the data. For instance, 412 % of Gresham, NC cars are in a flood zone.  
2.  Inaccurate calculations of metrics. For instance  New Yorks's population density includes their 458 sq km of ocean that is technically part of the city.  Variables that were supposedly standardized have different means and std dev. 
3.   Issues with information collection/accuracy - Arvada, CO has 0 hospital beds and every house in Ft. Lauderdale has a secondary fuel source. The study of people 65%+ living alone shows 29% nationally.  There is no city recorded with more than 16%.
4.    Feature selection -  A city's last bond rating is used to represent the readiness to accept adaption investment. Percent of homes that accepted food stamps in a different year is used represent the poverty rate instead of the census poverty rate for that year. Number of patents per 1000 people used for Government support. Feature explanations in the technical guide are sometimes inaccurate (header for one feature, text for another).  

Goals -
MVP -  Graphing shows several variables have high correlation.  Start with some PCA.  Then, re-do their study with the data as is to see if it matches. Lastly, devbelop some simple models like K-means clustering (should be 4 clusters) to see if I they match the original's study's conclusion.  
MVP  + 
  A.  Use a neural network on the raw data for discovery. 
  B.  Do some feature tuning and re-run on the models.  Re-standardize the data. Recalculate population density excluding open ocean.   Maybe replace the current measurement of poverty with the actual poverty rate for the correct year.   
 
 MVP ++ - 
  A.  If a valid model can be found, see how to apply it to another dataset like European cities.
  B.  Try to find new features to test.  Ideas are current investment in environmental services both public and private like public parks, land management. Availability of government services for environmenal extremes. LEAP utility assistance in winter)  Fire related factors drought like # of firehouses per capita.  Local disaster plans in addition to FEMA.  
