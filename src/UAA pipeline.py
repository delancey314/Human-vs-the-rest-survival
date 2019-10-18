import pandas as pd 
import numpy as np 
from collections import defaultdict
from collections import Counter

class UAAPipeline(self,filename):
    def __init__(self):        
        self.work_file=work_file
        self.old_features=old_features
        self.new_name=new_name
        self.features_dict=defaultdict({lambda:'None'})  
        self.new_names_dict=dict('city':['city', 'state', 'geo_id','overall_risk', 'overall_readiness'],\

    #lambda function to add categories to a file
     def categorize_(row):
        if row['overall_risk']== 1 and row['overall_readiness']==1:
        return 4
        elif row['overall_risk']== 1 and row['overall_readiness']==0:
        return 3
        elif row['overall_readiness'] == 1:
        return 2
        else:
        return 1


    def file_exist(self):
        if self.filename == 'city':
            self.work_file=pd.read_csv('data/transformed_data/City Indicators.csv')
        elif self.filename == 'drought':
            self.work_file=pd.read_csv('data/transformed_data/Drought Data.csv')
        elif self.filename == 'flood':   
            self.work_file=pd.read_csv('data/transformed_data/Flood Data.csv')
        elif self.filename == 'heat':   
            self.work_file=pd.read_csv('data/transformed_data/Heat Data.csv')
        elif self.filename == 'risk':
            self.work_file=pd.read_csv('data/transformed_data/Overall Risk & Readiness Scores.csv')
        elif self.filename == 'coastal':
            self.work_file=pd.read_csv('data/transformed_data/Sea Level Rise Data.csv')
        
    def new_load(self):
        if self.filename == 'city':
            self.work_file=pd.read_csv('data/raw_data/City Indicators.csv')
        elif self.filename == 'drought':
            self.work_file=pd.read_csv('data/raw_data/Drought Data.csv')
        elif self.filename == 'flood':   
            self.work_file=pd.read_csv('data/raw_data/Flood Data.csv')
        elif self.filename == 'heat':   
            self.work_file=pd.read_csv('data/raw_data/Heat Data.csv')
        elif self.filename == 'risk':
            self.work_file=pd.read_csv('data/raw_data/Overall Risk & Readiness Scores.csv')
        elif self.filename == 'coastal':
            self.work_file=pd.read_csv('data/raw_data/Sea Level Rise Data.csv')
        else:
            print('file not in list. Please choose from city,drought,flood,heat,risk or coastal')
            break
        

    def rename(self):
        self.old_features=self.work_file.columns
        self.new_name=self.new_names_dict[self.filename]
        self.filename.columns=self.new_names

            
    
    def drop_fields(self):
        #Puerto Rico is being dropped at rows [19, 35, 193, 220] because of data inconsistency
        self.workfile.drop([19, 35, 193, 220], inplace = True)
        if self.filename == 'city':
           
        elif self.filename == 'drought':
           
        elif self.filename == 'flood':   
            
        elif self.filename == 'heat':   
            
        elif self.filename == 'risk':
           self.workfile['overall_readiness'] = np.where(self.workfile['overall_readiness']>=.4651, 1, 0)
           self.workfile['overall_risk'] = np.where(self.workfile['overall_risk']>=.3840, 1, 0)
           self.workfile['overall_readiness'] = np.where(self.workfile['overall_readiness']>=.4651, 1, 0)
           self.workfile['risk_ready_cat']=self.workfile.apply(lambda row: categorize(row), axis=1)
        elif self.filename == 'coastal':

    def 

    def make_file(self,filename):
        self.filename=filename
        try:
            file_exist()
            return self.work_file
        except:
            new_load()
            rename()
            clean_columns()

        
    
 if __name__ == "__main__":
        load(filename)
        rename()
        clean()
        create_columns()
        return output_file
        pass