import numpy as np 
import pandas as pd 
import UAAPipeline
import matplotlib.pyplot as plt
from sklearn.ensemble import AdaBoostClassifier
from xgboost import XGBClassifier
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.metrics import confusion_matrix
from sklearn.model_selection import train_test_split
from sklearn.multiclass import OneVsRestClassifier
from sklearn import metrics
from sklearn.metrics import roc_curve, auc
import pickle

# not used for production but helpful for EDA and debuggging
pd.options.display.max_columns = None



def make_X_y(df_to_split):
    create_X= df_to_split.drop(columns=['risk_ready_cat'])
    create_y=df_to_split['risk_ready_cat']
    tree_features=df_to_split.columns
    create_y.to_csv('../data/transformed_data/classification_labels.csv')
    create_X.to_csv('../data/transformed_data/classification_data.csv')
    tree_features.to_csv('../data/transformed_data/classification_features.csv')

def confuse_mattrix(y_test,y_predict):
    tn, fp, fn, tp = confusion_matrix(y_test, y_predict)
    print(y_test)
    print(y_predict)
    print(f'TP= {tp}, fp={fp}')
    

def sratifier(independent,dependent):
    # I like to pass X,y into models so independent, dependent are used to allow the numpy transform for the stratifier
    X=np.array(independent)
    y=np.array(dependent)
    strat = StratifiedShuffleSplit(n_splits=5, random_state=42)
    strat.get_n_splits(X,y)
    split_indices=list(strat.split(X,y))
    #print(split_indices)
    return strat

def strat_1_v_rest_rf(X,y):
    #StratifiedShuffleSplit-OneVsRestClassifier-RandomForestClassifier
    #best mean accuracy = 0.7571428571428571
    sss=sratifier(X,y)
    sss_rf_scores =[]

    trees_to_grow=155
    depth = None
    sample_split=2
    feature_selection='auto'

    for train_index, test_index in sss.split(X, y):
        X_train, X_test = X[train_index], X[test_index]
        y_train, y_test = y[train_index], y[test_index]
        sss_rf = OneVsRestClassifier(RandomForestClassifier( n_jobs=-1, max_features = feature_selection, 
                max_depth= depth, n_estimators=trees_to_grow, min_samples_split=sample_split,random_state=38))
        sss_rf.fit(X_train, y_train)
        y_hat=sss_rf.predict(X_test)
        #print(y_hat,y_test)
        score=sss_rf.score(X_test,y_test)
        sss_rf_scores.append(score)
        #print(score)

        
        sss_rf_mean_accuracy=sum(sss_rf_scores)/len(sss_rf_scores)
        print(f'sss_rf mean accuracy= {sss_rf_mean_accuracy}')
        confuse_mattrix(y_test,y_hat)
        filename = '../data/models/Strat_oneVRest_Random_Forest.sav'
        pickle.dump(sss_rf, open(filename, 'wb'))   

def tts_1_v_rest_rf(X,y):
    #TrainTestSplit-OneVsRestClassifier-RandomForestClassifier
    #Train Test Split does not require a numpy array so a separate function is not needed
    #accuracy= 0.7428571428571428

    X_train, X_test, y_train, y_test = train_test_split(X y, test_size=0.25, random_state=42)
    
    trees_to_grow=125
    depth = 8
    sample_split=10
    feature_selection='auto'

    tts_rf = OneVsRestClassifier(RandomForestClassifier( max_features = feature_selection, 
                max_depth= depth, n_estimators=trees_to_grow, min_samples_split=sample_split,random_state=38
                random_state=38,n_jobs=-1))
    tts_rf.fit(X_train, y_train)
    y_hat=tts_rf.predict(X_test)
    #print(y_hat,y_test)
    score=tts_rf.score(X_test,y_test)
   
    print(f'sss_rf accuracy= {score}')
    confuse_mattrix(y_test,y_hat)
    filename = 'data/models/TTS_oneVRest_Random_Forest.sav'
    pickle.dump(tts_rf, open(filename, 'wb'))

    
 def tts_rf(X,y):
     #TrainTestSplit Random Forest 

    X_train, X_test, y_train, y_test = train_test_split(trees_data, trees_cat, test_size=0.25, random_state=42)
    
    trees_to_grow=19
    depth = 10
    sample_split=13
    feature_selection=8

    rf = RandomForestClassifier( max_features = feature_selection, 
                max_depth= depth, n_estimators=trees_to_grow, min_samples_split=sample_split,random_state=38
                ,n_jobs=-1)
    rf.fit(X_train, y_train)
    y_hat=rf.predict(X_test)
    #print(y_hat,y_test)
    score=rf.score(X_test,y_test)
    print(score)
    confuse_mattrix(y_test,y_hat)

 def adaboosted(X,y) :
     #ada boost mean accuracy= 0.7285714285714285
    X_train, X_test, y_train, y_test = train_test_split(trees_data, trees_cat, test_size=0.25, random_state=42)
    #n_estimators =49, learning_rate = 1.1
    n=49
    le=1.1
    ada_l = AdaBoostClassifier(n_estimators =n, learning_rate = le, random_state=38)
    ada_l.fit(X_train, y_train)
    y_hat=ada_l.predict(X_test)
    score=ada_l.score(X_test,y_test)
    print(score)
    confuse_mattrix(y_test,y_hat)



if __name__ == "__main__":
    pipe=UAAPipeline()
    risk_readiness=pipe.make_file('risk')
    city_indicators=pipe.make_file('city')
    feature_name_dict=pipe.get_feature_names()
    tree_data,tree_targets=make_X_y(city_indicators)
    strat_1_v_rest_rf(tree_data,tree_targets)
    tts_1_v_rest_rf(tree_data,tree_targets)
    tts_rf(tree_data,tree_targets)
    adaboosted(tree_data,tree_targets)

    



    
   
