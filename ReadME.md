#   The Expected Risk and Readiness of Major US Cities for the Upcoming Climate Change

Climate Change is upon Us
 
 There is extensive evidence that climate change is upon us.  Last year, the United Nations Intergovernmental Panel on Climate Change (IPCC) released their report showing we are likely to cross the threshold of 1.5 C by 2040. This is a critical threshold is theorized to be a point of no return.
 
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/IHCC%20Predicted%20Change.JPG "IPCC predicted change")
[link to IPCC report](https://www.ipcc.ch/2019/(https://www.ipcc.ch/2019/)

This rise is expected to have significant impact on human life
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/IHCC%20Risk%20to%20Rising%20CO2%20levels.jpg "Risks")
Furthermore, the risks are increasing.  The Arctic permafrost holds 1600 billion tons of CO2 and methane - twice what is currently in the atmosphere.  This year, multiple studies have been released showing the permafrost will be completely melted sometime between 2030 and 2040. This example from Russia shows that when melting begins, entire hills can be quickly lost.
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/Batagaika%20crater.JPG "Batagaika crater")

The earth's natural defense to rising CO2 is the carbon sinks in forests.  Due to drought and human deforestation, these sources are burning. In August 2019 alone, there was an estimated 26,000 fires in the Amazon.  Today (Oct 18,2019), there are 17 large fires in 9  states with 247,00 acres on fire
!![alt text]](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/Indonesian%20fire.JPG "Indonesia Fire")

## Theme of this Project

##### This project is going to try and predict the risk to major US cities and how prepared they are to handle it.  
	Part 1 = Test against the published model to see how accurately I can match their results by doing a Decision Tree analysis of their 4 classes. 
	Part 2 =  Redo their calculations

### How to predict Risk and Readiness

The Notre Dame Global Adaptation Initiative (ND-GAIN) is leading a global initiative to gather data needed for United Nations Members to make decisions for their couunty. As a subproject of this initiative, completed a report on the risk and readiness for climate change for 270 cities called the Urban Adaption Assessment. The aim of this project is to see if I can match the results of their study or possibly improve it.


### Data
The data is available as a downloadable zip file from the NDGAIN website.It includes information on the 278 cities larger than 100,00 people. It consists of 8 csv files labeled ‘Historical 'Hazards Outcome Data.csv’,‘Cold Data.csv’‘Drought Data.csv’,‘Flood Data.csv’,‘Heat Data.csv’,‘Sea Level Rise Data.csv’,‘City Indicators.csv’, and  ‘Overall Risk & Readiness Scores.csv’.  The files are a mixture of sparse raw data, dense converted matrices, and a mixture of converted data and raw values. The city indicators are used to calculate values for each of the hazard types and saved in that hazard with additional hazard specific data


![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/data_screenshots.JPG "data")

The data is organized by hazards. The hazard specific features are then aggregated with historical data and used as city indicators. The city indicators were then standardized to be fed into their model to produce the Overall Risk & Readiness Scores.
	

 File		Columns	Row
Drought		18	278
Cold		13	272
Flood		18	278
Heat		14	278
Sea Level	13	278
Historical	34	278
City Indicators	52	278

## Published Dataset
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/RIsk_Readiness%20Explained.JPG "Summary")

![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/UAA%20Grid.JPG "Grid")


![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/Formulas.JPG "Formulas")																
## EDA		

![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/Risk-Readiness%20High-Low.JPG "high_low'")
Drought	18	278	5 standard deviations, data inaccurate.  Denver 47% of drought while Aurora is 74%																																										
Cold	13	272	6 cities NA cold probability, only 12 cities have a historical cost of cold events with most in TX																																										
Flood	18	278	152 cities with no future flood event including known cities with flooding issue like Des Moines.  55 (most of California no history). Thornton has higher values than St Louis																																										
Heat	14	278	45 cities have never had a heat  event. 8 cities have more than 6																																										
Sea Level	13	278																																											
Historical	34	278																																											
City Indicators	52	278																																																																							
																																													
waterstress Nul		'Percent of GDP based on water intensive industries_2015'															
uppercase'Percentage of workforce in Farming Fishing and Forestry 2015'Name Spellling, 'Total number of federal public corruption convictions by district_2015'									
Invest(Adaption)	bond rating			Impervious														
Tax Incentives 	count programs; 1-15 w/1 @ 75			Over 65 - counts off												
Civic Readiness	% vote, 3 cities 100+			disabled										
Innovation	patents per capita			Rent												
pop density/area	includes water			Tree Canopy													
Beds - 19 cities including Tempe, VA beach				Water and drought plans						
Secondary heatsource	198 .99+ including Ft. Lauderdale			# of kids						
Poverty = SNAP	foodstamps			buildings < 1979, 1999											
Sea Level = 89	values still calculated			No car												
population	2010-2015, used for growth rate		
Canopy		Denver = 2.766717944, 222nd.  Bottom 50 are mainly CO, CA and
									
Historical																											
deaths, injuries, cost for each hazard																											
very sparse and many ??																												
Only Tx and NV appeared to be reporting	only one over 10 flood injuries,  																									
## Models and Results

#### Stratification
    risk_ready_cat	
1	    48

2	    80

3	    87

4	    59
For all models, one parameter was optimized to maximum accuracy and then the next adjusted to attempt to increase. This was attempted most hyperparamters.  Weight was not chnaged but Gini was switched to entropy.  
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/Models.JPG "Models")
#### Model 1
Due to the stratification and the fact there are 4 categories,  I did research to discover the correct model for classification:
A series of Nested Models was recommended.  First, Stratified Shuffle Split was recommended to shuffle the alphabetized data then divide it into a series of folds.  Second, OneVsRestClassifier works by running the selected model repeatedly by comparing 1 class vs the other 3 and then repeating to generate an averaged accuracy. A Random Forest Classifier was then chosen as the simplist model to be used.   This model did have the best accuracy score but it is hard to interpret. Features Importance was not avialable due to looping nature (5 folds, 4 categories). 

### Model 2
TrainTestSplit replaced Stratified Shuffle Split as the separation agent for a single 75% train/25% test split. OneVsRestClassifier and Random Forest were used again for a lower accuracy score.

### Model 3
OneVsRestClassifier was removed for a simple TrainTestSplit Random Forest. The accuracy decreased but feature importance was produced.

### Model 4
I have had success with Adaboost so I tried it with TrainTestSplit and OneVsRestClassifier.  This model is much simpler and easier to tune due to less hyperparamaters with similar accuracy scores..  Once again, feature importance was not available
    
### Model 5
Adaboost was done again with a simple TrainTestSplit.  This model was able to obtain the same level of accuracy as the One vs All. In addition, feature importance was again available.

The most interesting thing for this model is the sensitivity of the learning rate.  Changing the rate by .01 dramatically affected the accuracy score.  
 
 ###  Feature Importance
 Feature importance was avialable for the most simple Adaboost and Random Forest.  The features that showed up in both 10 ten are marked green.  The features related to population density are highlighted in yellow.  For both models, the population and city area both show as zeros or the lowest values (32nd on the right) while Population Density is one of the highest
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/feature%20Extraction.JPG "features")


Inability to produce ROC curves.  

![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/ROC%20curves.JPG "ROC Curves")

	
