import pandas as pd
from collections import defaultdict
from collections import Counter
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA



city_indicators=pd.read_csv('data/City Indicators.csv')
drought_data=pd.read_csv('data/Drought Data.csv')
flood_data=pd.read_csv('data/Flood Data.csv')
heat_data=pd.read_csv('data/Heat Data.csv')
historical=pd.read_csv('data/Historical Hazards Outcome Data.csv')
risk_recovery=pd.read_csv('data/Overall Risk & Readiness Scores.csv')
sea_level_data=pd.read_csv('data/Sea Level Rise Data.csv')


#Exploratory functions. each file was made df and then explored
df=historical.copy()
df.shape

df.corr()
pd.plotting.scatter_matrix(df, alpha=0.2, figsize=(40,40))

plt.show()

df.columns

#all the *a functions are looking at each column for interesting
a=3
df.iloc[:,a].describe()
#charles=(df.iloc[:,a])
#print(df.iloc[20:150,a])
#print(df.iloc[24])

df.iloc[:,a].unique()

df1 = df[df.isna().any(axis=1)] print(df1)

#print(df['flood_hist_cost'].isna())
#df.fillna(0, inplace = True)

# if something showed up in unique above, this was usd to pull the full rows
row=0
count=0
for value in df.iloc[:,a]:
    if value >0:
        print(df.iloc[row,0:2],df.iloc[row,a])
        
        count+=1
    row+=1
print(count)

fig = plt.figure()

count=1
drop_list=list(city_indicators.columns)
for header in city_indicators.columns:
    x=city_indicators[header]
    for header2 in drop_list:
        plt.show(count)
        y=city_indicators[header2]
        ax = fig.add_subplot()
        plt.scatter(x, y, alpha=0.5)
        
        drop_list.remove(header2)
        count+=1
import numpy as np
from sklearn.decomposition import PCA

pca = PCA(n_components=4)
pca.fit_transform(X) 
print()

pca_cov=pca.get_covariance
#pca_v=pd.DataFrame(pca_cov)
print(pca.explained_variance_ratio_)  

print(pca.singular_values_)
pca.get_params

'''
__________________________________________________
df was switched to the file name and info copied down.
'''
city_indicators=pd.read_csv('data/City Indicators.csv')
city_indicators_old=df.columns
new_names=['city','state','geo_id','GDP_water_all','perc_fff','d_plan','w_plan','base_w_stress','invest','tax_break','corruption','perc_vote','innovate','climate_real','hs_ed','pop_dens','w_quality','debt','flood_pop','flood_build','flood_car','impervious','beds_1000','alone_65','child_5','health_ins','older_1999','mobile_home','rent_50plus','trees','heating','disabled','poverty','older_1979','work_outside','no_car','pop_under_1ft','pop_under_3ft','impact_plus1ft','impact_plus3ft', 'col_empty','lat','long','county','region','city_km2','pop_2010','pop_2011','pop_2012','pop_2013','pop_2014','pop_2015','median_income']
indicators_dict = dict(zip(new_names, city_indicators_old))
city_indicators.columns = new_names
city_indicators.drop(columns =['col_empty'], inplace= True)

feature_names['city_indicators']=indicators_dict

city_indicators.head()


cold_data=pd.read_csv('data/Cold Data.csv')
cold_data_old=df.columns
new_names=['city', 'state', 'geo_id', 'cold_risk', 'cold_vuln', 'cold_expose','cold_sens', 'cold_adapt', 'cold_ready', 'cold_social', 'cold_govG','cold_econ', 'cold_hist_cost', 'cold_p_heat2040']
cold_data.columns = new_names
cold_dict = dict(zip(new_names, cold_data_old))
feature_names['cold_data']=cold_dict
#cold_data.head()

risk_recovery=pd.read_csv('data/Overall Risk & Readiness Scores.csv')
risk_recovery_old=risk_recovery.columns
new_names=['city', 'state', 'geo_id','overall_risk', 'overall_readiness']
risk_recovery.columns = new_names
risk_recovery_dict = dict(zip(new_names, risk_recovery_old))
feature_names['risk_recovery']=risk_recovery_dict
risk_recovery.columns

drought_data=pd.read_csv('data/Drought Data.csv')
drought_data.drop(columns=['Unnamed: 14'], inplace=True)
old_columns=drought_data.columns
new_names=['city', 'state', 'geo_id','drought_risk', 'drought_vuln', 'drought_expose','drought_sens', 'drought_adapt', 'drought_ready', 'drought_social', 'drought_gov','drought_econ', 'drought_hist_cost','drought_future_cost','drt_dev_forecast','drt_dev_for_vs_norm','drt_.5sdev_G','drt_.5sdev_G','drt_dist_sdev']
drought_data.columns = new_names
drought_dict = dict(zip(new_names, old_columns))
feature_names['drought_data']=drought_dict

heat_data=pd.read_csv('data/Heat Data.csv')
new_names=['city','state','geo_id','heat_risk','heat_vuln','heat_expose','heat_sens','heat_adapt','heat_ready','heat_social','heat_gov','heat_econ','heat_hist_cost','heat_prob_2040']
old_columns=heat_data.columns
heat_data.columns = new_names
heat_data_dict = dict(zip(new_names, old_columns))
feature_names['heat_data']=heat_data_dict
heat_data.columns

historical=pd.read_csv('data/Historical Hazards Outcome Data.csv')
new_names=['city', 'state', 'geo_id','fl_instances', 'fl_inj_direct' 
           ,'fl_inj_indirect','fl_inj_total'\
           , 'fl_death_direct' ,'fl_death_indirect','fl_death_total',
           'flood_damage'\
           ,'ht_instances', 'ht_inj_direct' ,'ht_inj_indirect','ht_inj_total'\
           , 'ht_death_direct' ,'ht_death_indirect','ht_death_total','heat_damage'\
          ,'cld_instances', 'cld_inj_direct' ,'cld_inj_indirect','cld_inj_total'\
           ,'cld_death_direct' ,'cld_death_indirect','cld_death_total','cold_damage'\
           ,'coast_fl_instances', 'coast_fl_inj_direct' ,'coast_fl_inj_indirect','coast_fl_inj_total'\
           , 'coast_fl_death_direct' ,'coast_fl_death_indirect','coast_fl_death_total','coast_fl_damage']
 
old_columns=historical.columns
historical.columns = new_names
historical_dict = dict(zip(new_names, old_columns))
feature_names['historical']=historical_dict
#historical.columns

ea_level_data=pd.read_csv('data/Sea Level Rise Data.csv')
new_names=['city', 'state', 'geo_id', 'sea_rise_risk', 'sea_rise_vuln', 'sea_rise_expos',
       'sea_rise_sens', 'sea_rise_adapt', 'sea_rise_ready', 'sea_rise_social', 'sea_rise_gov',
       'sea_rise_econ', 'sea_rise2040', 'sea_rise_cost+1ft']

old_columns=sea_level_data.columns
sea_level_data.columns = new_names
sea_level_data_dict = dict(zip(new_names, old_columns))
feature_names['sea_level_data']=sea_level_data_dict
sea_level_data.columns
