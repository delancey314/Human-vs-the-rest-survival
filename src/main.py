import numpy as np 
import pandas as pd 
import UAAPipeline
import matplotlib.pyplot as plt
from xgboost import XGBClassifier
from sklearn.model_selection import StratifiedShuffleSplit

from sklearn.multiclass import OneVsRestClassifier
from sklearn import metrics
from scipy import interp
from sklearn import svm
from sklearn.metrics import roc_curve, auc
import pickle

pd.options.display.max_columns = None

city_indicators=pd.read_csv('data/raw_data/City Indicators.csv')
drought_data=pd.read_csv('data/raw_data/Drought Data.csv')
flood_data=pd.read_csv('data/raw_data/Flood Data.csv')
heat_data=pd.read_csv('data/raw_data/Heat Data.csv')
######
historical=pd.read_csv('data/raw_data/Historical Hazards Outcome Data.csv')

risk_recovery=pd.read_csv('data/raw_data/Overall Risk & Readiness Scores.csv')
sea_level_data=pd.read_csv('data/raw_data/Sea Level Rise Data.csv')

pipe=UAAPipeline()

def make_X_y(df_to_split):
    create_X= df_to_split.drop(columns=['risk_ready_cat'])
    create_y=df_to_split['risk_ready_cat']
    tree_features=df_to_split.columns
    create_y.to_csv('data/transformed_data/classification_labels.csv')
    create_X.to_csv('data/transformed_data/classification_data.csv')
    tree_features.to_csv('data/transformed_data/classification_features.csv')




if __name__ == "__main__":
    pipe=UAAPipeline()
    risk_readiness=pipe.make_file('risk')
    city_indicators=pipe.make_file('city')

    feature_name_dict=pipe.get_feature_names()

    tree_data,tree_targets=make_X_y(city_indicators)
    



    
    pass
