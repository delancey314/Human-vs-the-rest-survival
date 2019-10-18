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
        self.new_names_dict={'risk':['city', 'state', 'geo_id','overall_risk', 'overall_readiness'],\
                            'city':['city','state','geo_id','GDP_water_all','perc_fff','d_plan','w_plan',\
                                    'base_w_stress','invest','tax_break','corruption','perc_vote','innovate',\
                                    'climate_real','hs_ed','pop_dens','w_quality','debt','flood_pop','flood_build',\
                                    'flood_car','impervious','beds_1000','alone_65','child_5','health_ins','older_1999',\
                                    'mobile_home','rent_50plus','trees','heating','disabled','poverty','older_1979',\
                                    'work_outside','no_car','pop_under_1ft','pop_under_3ft','impact_plus1ft','impact_plus3ft',
                                    'col_empty','lat','long','county','region','city_km2','pop_2010','pop_2011','pop_2012','pop_2013',\
                                    'pop_2014','pop_2015','median_income']}



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
        if  self.filename == 'city':
            self.work_file=pd.read_csv('../data/transformed_data/City Indicators.csv')
        elif self.filename == 'drought':
            self.work_file=pd.read_csv('../data/transformed_data/Drought Data.csv')
        elif self.filename == 'flood':   
            self.work_file=pd.read_csv('../data/transformed_data/Flood Data.csv')
        elif self.filename == 'heat':   
            self.work_file=pd.read_csv('../data/transformed_data/Heat Data.csv')
        elif self.filename == 'risk':
            self.work_file=pd.read_csv('../data/transformed_data/Overall Risk & Readiness Scores.csv')
        elif self.filename == 'coastal':
            self.work_file=pd.read_csv('../data/transformed_data/Sea Level Rise Data.csv')
        elif self.filename == 'cold':
             self.work_file=pd.read_csv('../data/transformed_data/Cold Data.csv')

    def new_load(self):
        if  self.filename == 'city':
            self.work_file=pd.read_csv('../data/raw_data/City Indicators.csv')
        elif self.filename == 'drought':
            self.work_file=pd.read_csv('../data/raw_data/Drought Data.csv')
        elif self.filename == 'flood':   
            self.work_file=pd.read_csv('../data/raw_data/Flood Data.csv')
        elif self.filename == 'heat':   
            self.work_file=pd.read_csv('../data/raw_data/Heat Data.csv')
        elif self.filename == 'risk':
            self.work_file=pd.read_csv('../data/raw_data/Overall Risk & Readiness Scores.csv')
        elif self.filename == 'coastal':
            self.work_file=pd.read_csv('../data/raw_data/Sea Level Rise Data.csv')
        elif self.filename == 'cold':
             self.work_file=pd.read_csv('../data/raw_data/Cold Data.csv')
        else:
            print('file not in list. Please choose from city,drought,flood,heat,risk or coastal')
            break
        

    def rename(self):
        self.old_features=self.work_file.columns
        self.new_name=self.new_names_dict[self.filename]
        self.filename.columns=self.new_names
        temp_dict_= dict(zip(self.new_name,self.old_features))
        self.features_dict[self.filename]=temp_dict_
        temp_dict_={}

            
    
    def clean(self):
        #method unfinished.  MOre will be added for the other files

        #Puerto Rico is being dropped at rows [19, 35, 193, 220] because of data inconsistency
        self.work_file.drop([19, 35, 193, 220], inplace = True)
        if self.filename == 'city':
            self.work_file.drop(columns =['col_empty'], inplace= True)
            #two cities had their order of magnitude incorrect for % of people in floodzone. Their neighboring values match the lower magnitude'
            self.work_file=self.work_file.replace(412.9208681,41.29208681)
            self.work_file=self.work_file.replace(101.6959823,10.16959823)
            self.work_file['d_plan'] = self.work_file['d_plan'].map({'Yes': 1, 'No': 0})
            self.work_file['w_plan'] = self.work_file['w_plan'].map({'Yes': 1, 'No': 0})
            self.work_file.drop(columns=['city','state','geo_id','county', 'region','pop_2010', 'pop_2011', 'pop_2012', 'pop_2013', 'pop_2014'], inplace=True)
            self.work_file.fillna(0, inplace=True)
            try:
                indices=pd.read_csv('../data/raw_data/Overall Risk & Readiness Scores.csv')
            except:
                load('risk')
            self.work_file['risk_ready_cat']=indices['risk_ready_cat']

        elif self.filename == 'drought':
           pass
        elif self.filename == 'flood':   
            pass
        elif self.filename == 'heat':   
            pass
        elif self.filename == 'cold':
            pass
        elif self.filename == 'risk':
            self.work_file['overall_readiness'] = np.where(self.work_file['overall_readiness']>=.4651, 1, 0)
            self.work_file['overall_risk'] = np.where(self.work_file['overall_risk']>=.3840, 1, 0)
            self.work_file['risk_ready_cat']=self.work_file.apply(lambda row: categorize_(row), axis=1)
            cities=self.work_file['city']
            cities.to_csv('../data/transformed_data/cities.csv')

            elif self.filename == 'coastal':

    def write_and_return():
        if self.filename == 'city':
            self.work_file.to_csv('../data/raw_data/City Indicators.csv')
            return self.work_file
        elif self.filename == 'drought':
            self.work_file.to_csv('../data/raw_data/Drought Data.csv')
            return self.work_file
        elif self.filename == 'flood':   
            self.work_file.to_csv('../data/raw_data/Flood Data.csv')
            return self.work_file
        elif self.filename == 'heat':   
            self.work_file.to_csv('../data/raw_data/Heat Data.csv')
        elif self.filename == 'risk':
            self.work_file.to_csv('../data/raw_data/Overall Risk & Readiness Scores.csv')
            return self.work_file
        elif self.filename == 'coastal':
            self.work_file.to_csv('../data/raw_data/Sea Level Rise Data.csv')
        else:
            self.work_file.to_csv('../data/raw_data/Cold Data.csv')
      
            


    def  make_file(self,filename):
        self.filename=filename
        try:
            file_exist()
            return self.work_file
        except:
            new_load()
            rename()
            clean()
            write_and_return()

        
    
 if __name__ == "__main__":
        load(filename)
        rename()
        clean()
        create_columns()
        write_and_return()