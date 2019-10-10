#   Forecasting a plan to avoid human extinction or maximize biodiversity

## Goals
The focus final goal of this study to attempt a forecast of a solution of the trolley problem involving human extinction.  

MVP:  Perform unsupervised learning to discover meaningful features in a corpus of data with high dimensionality.  This is necessary for the next two phases. Emphasis will begin with PCA and K**(NN and Means). Those 3 techniques have been useful before.  Shannon Entropy has historically been the measurement of biodiversity so I have ideas for modified tree based algorithms.  Other models will also be tried. 

MVP + - Either/Or/Both depending on what MVP finds
A:  Bring in other datasources like human related factors and  ecological communtity organization to see if they can be transformed into usable lower dimensionality features
B:  Plug lower dimensional feature sets into some neural nets and see what they find.  

MVP ++:  Either/Or/Both depending on what is found
  A - Bring in time series
  B - Do some forecasting or create a predictive model.
  
MVP +++ - Develop a prescriptive model to help design our future.

###  The Trolley Problem
  
  
  A classical ethical problem involves a runaway trolley headed down the tracks with no way to stop it. There are several people on the tracks that will be killed. However, you can throw a switch sending the trolley down a spur with a single person on it that will be killed instead.  Your action will definitely kill someone but not acting kills more.  
 
 ### Our climate trolley is on the tracks
  Trained as an ecologist, I knew that climate change was a risk that we must try to reverse.  However, due to recent developments, I believe we have passed the tipping point - we are in a mass extinction event and climate change is irreversible. Freshwater lensing (freshwater on top of salt acts  like a magnifying glass due to different refractive properties) is accelerating the melting of water reserves causing loss of land.  The northern hemisphere permafrost holds ~ 1.5 trillion tons of CO2 and methane which is approximately 1.5 times the total of the current atmosphere. Reliable estimates show all of those greenhouse gases released by 2030.   THe Amazon Rainforest is our largest carbon sink (plants to pull the CO2 out of the air). Scientists estimate the Amazon shrunk ~15-20% in the last 50 years.  Due to climate change, massive fires (26,000 in August alone), they estimate we have lost 20-40% this year.  Current estimates are running between 2040 and 2100 for human extinction with most now falling between 2040 and 2050.
 
 ### Can we and should we pull the switch?
As a species, humanity needs to start making some difficult ethical decisions. 

  I now believe humanity should ensure our survival over all over costs. By combining data from disparate sources in an unsupervised learning study, I hope to find underlying factors to help make these tough decisions. 
  
Hypothetically, do we need to force everyone in Ohio (currently highest crop yields) to use their land to feed the planet or maybe it would be better to let the 21 endangered species in Bangladesh go extinct so they can use the land to feed their people locally. Once I find some structure in the data, I hope to find some features to define better questions.


## Datasets to be used

### Primary dataset

This will probably end up being the primary dataset for capstone 3 forecasting but will also be fundamental for capstone 2 unsupervised learning.  Although large, it has already been cleaned and put into sql and is live curated by a grant from the EU. The initial study will start with  PCA and clustering and go where the data leads me.  

#### BioTIME: 
'A database of biodiversity time series for the Anthropocene:'   Global Ecology and Biogeography,Volume 27, Issue 7

8,777,413 species abundance records from assemblages consistently sampled at 547,161 unique locations across all realms(terrestrrial, aquatic, etc).  44,440 species covered between 1874 and 2016 with a minimum of two years at the same site for a species. 

####  University of Notre Dame Global Adaptation Index (ND_GAIN)
This dataset represents  a country’s current vulnerability to climate disruptions and assesses each country' readiness to leverage private and public sector investment for adaptive actions. It is 74 variables to form 45 core indicator to measure vulnerability and readiness of 192 UN countries from 1995 to the present. 

This dateset is excellent due to its granularity.  I plan to only use the summarized, indexed values for 2015 for the 8 major groupings, (Water, Health, Ecosystem Services, Human habitat, Infrastructure, Economic readiness, Governance readiness and Social readiness). However, the raw values, imputed values, and preconversion values are provided in separate files from 1995 to 2015 to be used if more detail is needed. Furthermore, both a training set from 1940-1970 and a test, predictive set for 2040-2070 is provided.  

Notre Dame made a point of excluding GDP (doublecounts poverty shown in other indicators), environmental disasters, and terrestrial biodiversity/biome measures.  Aquatic was included because the impact/change is easier to measure. Move a shipping lane/stop fishing an area and the impact is obvious earlier.

#### Mamamlian Communities Database (MCDB)
Originally published as 'PSecies composition and abundance of mammalian communities.' Ecology 92:2316

This is the largest summary  of ecological communities for mammals.  This brings the individual species into functional interactive communities.  7977 records that indicate the presence and, for a subset of the records, the abundance of mammal species, including representatives across trophic groups and size classes but excluding bats, documented at 1000 sites throughout the world, encompassing a variety of habitats. Great granularity as well. Key features are it lists mammalian communities  with all mammalian species, their long/latitude and year (cross reference to  NDGAIN), and habitat. 

  
  
  
  

 
  
  
  
