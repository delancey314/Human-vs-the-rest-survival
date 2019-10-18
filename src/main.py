import numpy as np 
import pandas as pd 
import UAAPipeline



city_indicators=pd.read_csv('data/raw_data/City Indicators.csv')
drought_data=pd.read_csv('data/raw_data/Drought Data.csv')
flood_data=pd.read_csv('data/raw_data/Flood Data.csv')
heat_data=pd.read_csv('data/raw_data/Heat Data.csv')
historical=pd.read_csv('data/raw_data/Historical Hazards Outcome Data.csv')
risk_recovery=pd.read_csv('data/raw_data/Overall Risk & Readiness Scores.csv')
sea_level_data=pd.read_csv('data/raw_data/Sea Level Rise Data.csv')

pipe=UAAPipeline()


if __name__ == "__main__":
    risk_ready=pipe.make_file('risk')
    
    pass
