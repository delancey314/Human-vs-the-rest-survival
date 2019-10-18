import numpy as np 
import pandas as pd 
import UAAPipeline
from collections import defaultdict
import matplotlib.pyplot as plt

from xgboost import XGBClassifier
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.multiclass import OneVsRestClassifier
from sklearn import metrics

import numpy as np
from scipy import interp
import matplotlib.pyplot as plt

from sklearn import svm, datasets
from sklearn.metrics import roc_curve, auc

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

def



if __name__ == "__main__":
    risk_readiness=pipe.make_file('risk')
    city_indicators=pipe.make_file('city')
    
    
    
    trees_cat=city_ind['risk_ready_cat']
trees_data = city_ind.drop(columns=['risk_ready_cat'])
tree_features=trees_data.columns
trees_cat.to_csv('data/transformed_data/classification_labels.csv')
trees_data.to_csv('data/transformed_data/classification_data.csv')
tree_feature.to_csv('data/transformed_data/classification_features.csv')
    pass
