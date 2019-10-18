#   The Expected Risk and Readiness of Major US Cities for the Upcoming Climate Change


    An MVP that demonstrates supervised or unsupervised learning (and maybe both).
    In the case of supervised learning, picking an appropriate metric to quantify performance, and then use of that metric in cross-validation to arrive at a model that generalizes as well as possible on unseen data. Be prepared for the request: "Describe the process you used to ensure your model was properly fit."
    In the case of unsupervised learning, picking an appropriate clustering method and metric to guide the choice of the number of hard or soft clusters. This should be followed up with a thoughtful discussion as to why the chosen number of clusters is "correct."
    In all cases, discussion of the cleaning and featurization pipeline and how raw data were transformed to the data trained on. Text processing especially requires discussion.
    In the case of classification and class imbalance, discussion of how the class imbalance was addressed. Did you use a default decision threshold, or did you pick a different threshold through out-of-model knowledge (e.g. a cost-benefit matrix and a profit curve.)

Climate Change is upon Us
 
 There is extensive evidence that climate change is upon us.  Last year, the United Nations Intergovernmental Panel on Climate Change (IPCC) released their report showing we are likely to cross the threshold of 1.5 C by 2040. This is a critical threshold is theorized to be a point of no return.
 
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/IHCC%20Predicted%20Change.JPG "IPCC predicted change")
[link to IPCC report](https://www.ipcc.ch/2019/(https://www.ipcc.ch/2019/)

This rise is expected to have significant impact on human life
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/IHCC%20Predicted%20Change.JPG "IPCC predicted impact")
Furthermore, the risks are increasing.  The Arctic permafrost holds 1600 billion tons of CO2 and methane - twice what is currently in the atmosphere.  This year, multiple studies have been released showing the permafrost will be completely melted sometime between 2030 and 2040. This example from Russia shows that when melting begins, entire hills can be quickly lost.
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/Batagaika%20crater.JPG "Batagaika crater"

The earth's natural defense to rising CO2 is the carbon sinks in forests.  Due to drought and human deforestation, these sources are burning. In August 2019 alone, there was an estimated 26,000 fires in the Amazon.  Today (Oct 18,2019), there are 17 large fires in 9  states with 247,00 acres on fire
![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/Indonesian%20fire.JPG 'Indonesia Fire")

## Theme of this Project

##### This project is going to try and predict the risk to major US cities and how prepared they are to handle it.  

### How to predict Risk and Readiness

The Notre Dame Global Adaptation Initiative (ND-GAIN) is leading a global initiative to gather data needed for United Nations Members to make decisions for their couunty. As a subproject of this initiative, completed a report on the risk and readiness for climate change for 270 cities. The aim of this project is to see if I can match the results of their study or possibly improve it.

### Data
The data is available as a downloadable zip file from the NDGAIN website.It includes information on the 278 cities larger than 100,00 people. It consists of 8 csv files labeled ‘Historical 'Hazards Outcome Data.csv’,‘Cold Data.csv’‘Drought Data.csv’,‘Flood Data.csv’,‘Heat Data.csv’,‘Sea Level Rise Data.csv’,‘City Indicators.csv’, and  ‘Overall Risk & Readiness Scores.csv’.  The files are a mixture of sparse raw data, dense converted matrices, and a mixture of converted data and raw values. The city indicators are used to calculate values for each of the hazard types and saved in that hazard with additional hazard specific data


![alt text](https://github.com/delancey314/US-City-Climate-Change-Risk-and-Readiness/blob/master/images/data_screenshots.JPG "data")

The data is organized by hazards. The hazard specific features are then aggregated with historical data and used as city indicators. The city indicators were then standardized to be fed into their model to produce the Overall Risk & Readiness Scores.
	
    
    
    
    
    
    
    risk_ready_cat	
1	    48
2	    80
3	    87
4	    59


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
    

 adaboosted(X,y) :
     #ada boost mean accuracy= 0.7285714285714285
    
    #n_estimators =49, learning_rate = 1.1
    n=49
    le=1.1
    ada_l = AdaBoostClassifier(n_estimators =n, learning_rate = le, random_state=38)
    ada_l.fit(X_train, y_train)





sss_rf mean accuracy= 0.7428571428571428
[3 2 2 1 3 2 3 4 4 4 1 3 3 1 1 3 1 3 2 3 2 2 4 2 4 4 3 2]
[3 2 2 2 3 2 3 2 3 4 3 3 3 1 2 3 2 3 2 3 2 2 4 2 4 2 3 2]
TP= [0 2 1 3], fp=[0 8 0 0]
