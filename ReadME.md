#   The Expected Risk and Readiness of Major US Cities for the Upcoming Climate Change

Climate Change is upon Us
 
 There is extensive evidence that climate change is upon us.  Last year, the United Nations Intergovernmental Panel on Climate Change (IPCC) released their report showing we are likely to cross the threshold of 1.5 C by 2040. This is a critical threshold is theorized to be a point of no return.
 
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/IHCC%20Predicted%20Change.JPG "IPCC predicted change")
[link to IPCC report](https://www.ipcc.ch/2019/(https://www.ipcc.ch/2019/)

This rise is expected to have significant impact on human life
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/IHCC%20Predicted%20Change.JPG "IPCC predicted impact")
Furthermore, the risks are increasing.  The Arctic permafrost holds 1600 billion tons of CO2 and methane - twice what is currently in the atmosphere.  This year, multiple studies have been released showing the permafrost will be completely melted sometime between 2030 and 2040. This example from Russia shows that when melting begins, entire hills can be quickly lost.
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/Batagaika%20crater.JPG "Batagaika crater")

The earth's natural defense to rising CO2 is the carbon sinks in forests.  Due to drought and human deforestation, these sources are burning. In August 2019 alone, there was an estimated 26,000 fires in the Amazon.  Today (Oct 18,2019), there are 17 large fires in 9  states with 247,00 acres on fire
!![alt text]](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/Indonesian%20fire.JPG "Indonesia Fire")

## Theme of this Project

##### This project is going to try and predict the risk to major US cities and how prepared they are to handle it.  
	Part 1 = Test against the published model to see how accurately I can match their results.
	Part 2 = Tr

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

Published Dataset





Results:

 #StratifiedShuffleSplit-OneVsRestClassifier-RandomForestClassifier
    #best mean accuracy = 0.7571428571428571
    trees_to_grow=155
    depth = None
    sample_split=2
    feature_selection='auto'

   
        sss_rf = OneVsRestClassifier(RandomForestClassifier( n_jobs=-1, max_features = feature_selection, 
                max_depth= depth, n_estimators=trees_to_grow, min_samples_split=sample_split,random_state=38))
               
               
               
 #TrainTestSplit-OneVsRestClassifier-RandomForestClassifier
    
    Best accuracy= 0.7428571428571428

    
    trees_to_grow=125
    depth = 8
    sample_split=10
    feature_selection='auto'

    Traditional TrainTestSplit-RandomForestClassifier
    
    
    
    OneVsRestClassifier(AdaBoostClassifier(

 adaboosted(X,y) :
     #ada boost mean accuracy= 0.7285714285714285
    
    #n_estimators =49, learning_rate = 1.1
    n=49
    le=1.1
    ada_l = AdaBoostClassifier(n_estimators =n, learning_rate = le, random_state=38)
    ada_l.fit(X_train, y_train)



1.1,  ada boost mean accuracy= 0.7285714285714285
1.09  ada boost mean accuracy= 0.6928571428571428
1.11  ada boost mean accuracy= 0.6714285714285715

sss_rf mean accuracy= 0.7428571428571428
[3 2 2 1 3 2 3 4 4 4 1 3 3 1 1 3 1 3 2 3 2 2 4 2 4 4 3 2]
[3 2 2 2 3 2 3 2 3 4 3 3 3 1 2 3 2 3 2 3 2 2 4 2 4 2 3 2]
TP= [0 2 1 3], fp=[0 8 0 0]


File	Columns	Row																																											
Drought	18	278	5 standard deviations, data inaccurate.  Denver 47% of drought while Aurora is 74%																																										
Cold	13	272	6 cities NA cold probability, only 12 cities have a historical cost of cold events with most in TX																																										
Flood	18	278	152 cities with no future flood event including known cities with flooding issue like Des Moines.  55 (most of California no history). Thornton has higher values than St Louis																																										
Heat	14	278	45 cities have never had a heat  event. 8 cities have more than 6																																										
Sea Level	13	278																																											
Historical	34	278																																											
City Indicators	52	278																																											
																																													
																																													
																																													
																																													
																																													
				Count	perc_fff	d_plan	w_plan	base_w_stress	invest	tax_break	corruption	perc_vote	innovate	climate_real	hs_ed	pop_dens	w_quality	debt	flood_pop	flood_build	flood_car	impervious	beds_1000	alone_65	child_5	health_ins	older_1999	mobile_home	rent_50plus	trees	heating	disabled	poverty	older_1979	work_outside	no_car	pop_under_1ft	pop_under_3ft	impact_plus1ft	impact_plus3ft	lat	long	city_km2	pop_2015	median_income
			risk_ready_cat																																										
			1	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48	48
			2	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80	80
			3	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87	87
			4	59																																									
																																													
waterstress Nul																																													
				 'Percent of GDP based on water intensive industries_2015'																																									
uppercase				 'Percentage of workforce in Farming Fishing and Forestry 2015'																																									
Name Spellling				'Total number of federal public corruption convictions by district_2015'																																									
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


Model 1
Due to the stratification and the fact there are 4 categories,  I did research to discover the correct model for classification:
A series of Nested Models was recommended.  First, Stratified Shuffle Split was recommended to shuffle the alphabetized data then divide it into a series of folds.  Second, OneVsRestClassifier works by running the selected model repeatedly by comparing 1 class vs the other 3 and then repeating to generate an averaged accuracy. A Random Forest Classifier was then chosen as the simplist model.   

	StratifiedShuffleSplit-OneVsRestClassifier-RandomForestClassifier
    	best mean accuracy = 0.7571428571428571
    trees_to_grow=155
    depth = None
    sample_split=2
    feature_selection='auto'sss_rf = OneVsRestClassifier(RandomForestClassifier( n_jobs=-1, max_features = feature_selection, 
                max_depth= depth, n_estimators=trees_to_grow, min_samples_split=sample_split,random_state=38))
               
               
               
 #TrainTestSplit-OneVsRestClassifier-RandomForestClassifier
    
    Best accuracy= 0.7428571428571428

    
    trees_to_grow=125
    depth = 8
    sample_split=10
    feature_selection='auto'

    Traditional TrainTestSplit-RandomForestClassifier
    
    
    
    OneVsRestClassifier(AdaBoostClassifier(

 adaboosted(X,y) :
     #ada boost mean accuracy= 0.7285714285714285
    
    #n_estimators =49, learning_rate = 1.1
    n=49
    le=1.1
    ada_l = AdaBoostClassifier(n_estimators =n, learning_rate = le, random_state=38)
    ada_l.fit(X_train, y_train)



1.1,  ada boost mean accuracy= 0.7285714285714285
1.09  ada boost mean accuracy= 0.6928571428571428
1.11  ada boost mean accuracy= 0.6714285714285715

	Adaboost					Random Forest	
features 	Importance			features 	Importance
corruption 	0.102041			pop_dens 	0.126668
pop_dens 	0.081633			impervious 	0.088946
perc_fff 	0.061224			perc_vote 	0.071046
perc_vote 	0.061224			corruption 	0.062883
hs_ed 		0.061224				invest 	0.058682
flood_build 	0.061224			heating 	0.046633
beds_1000 	0.061224			rent_50plus 	0.0346
lat 		0.061224			flood_build 	0.032596
invest 		0.040816			poverty 	0.028374
innovate 	0.040816			hs_ed 		0.028108
older_1999 	0.040816			long 		0.027278
no_car 		0.040816			work_outside 	0.026712
long 		0.040816			older_1979 	0.025989
GDP_water_all 	0.020408			climate_real 	0.025737
debt 		0.020408			health_ins 	0.022751
flood_car 	0.020408			lat 		0.019772
impervious 	0.020408			trees 		0.017405
alone_65 	0.020408			GDP_water_all 	0.016843
health_ins 	0.020408			no_car 		0.016581
rent_50plus 	0.020408			pop_2015 	0.015861
heating 	0.020408			debt 		0.015735
poverty 	0.020408			older_1999 	0.014598
older_1979 	0.020408			beds_1000 	0.014327
impact_plus1ft 	0.020408			child_5 	0.013869
median_income 	0.020408			perc_fff 	0.013672
d_plan 	0					mobile_home 	0.013565
w_plan 	0					flood_car 	0.013251
base_w_stress 	0				alone_65 	0.011922
tax_break 	0				median_income 	0.011868
climate_real 	0				innovate 	0.011824
w_quality 	0				city_km2 	0.010997
flood_pop 	0				pop_under_3ft 	0.010672
child_5 	0				impact_plus1ft 	0.010096
mobile_home 	0				flood_pop 	0.009026
trees 	0					pop_under_1ft 	0.007866
disabled 	0				tax_break 	0.007688
work_outside 	0				base_w_stress 	0.005797
pop_under_1ft 	0				w_quality 	0.005305
pop_under_3ft 	0				disabled 	0.004457
impact_plus3ft 	0				d_plan 	0
city_km2 	0				w_plan 	0
pop_2015 	0				impact_plus3ft 	0
																																												
	
