

'''
    Due to issues with the raw data, I am recalculating.
    They are being stored in a separate data frame, calc_from_raw to identify them as 
    check. Each variable is appended with a '_c' to distinguish it from the study's calculations.'

The original study calculates  economic, and governance the same
for all hazards. Only one variable (flood) has a different exposure. Therefore, a universal 
variable will be created to represent these categories in the new setr.s
'''


# universal formulas
calc_from_raw =pd.Dataframe()

calc_from_raw['econ_c']=cleaned['debt']+cleaned['invest']+cleaned['tax_break']
calc_from_raw['gov_c']=cleaned['innovate']+cleaned['climate_real']
calc_from_raw['social_c']=cleaned['corruption']+cleaned['perc_vote']
#make sure to use flood_expos for flood. Use this one for the rest
calc_from_raw ['expos_c']=cleaned['pop_2015']

#heat - adaption and sensitivity formulas unique
calc_from_raw['heat_adapt_c']=cleaned['beds_1000']+cleaned['trees']]
calc_from_raw['heat_sens_c']=cleaned['alone_65']+cleaned['poverty']+cleaned['disabled']

#cold - adaption and sensitivity formulas unique
calc_from_raw['cold_adapt_c']=cleaned['beds_1000']+cleaned['heating']
calc_from_raw['cold_sens_c']=cleaned['alone_65']+cleaned['work_outside']+cleaned['child_5']

#flood - exposure, sensitivity and adaption formulas unique
calc_from_raw['flood_expos']=cleaned['flood_pop']+cleaned['flood_build']
calc_from_raw['flood_sens_c']=cleaned['older_1999']+cleaned['mobile_home']
calc_from_raw['flood_adapt_c']=cleaned['beds_1000']+cleaned['w_quality']


#drought - sensitivity and adaption unique
calc_from_raw['drought_sens_c']=cleaned['GDP_water_all']+cleaned['perc_fff']
calc_from_raw['drought_adapt_c']=cleaned['d_plan']+cleaned['w_plan']


'''
individual versions in case they are needed.

calc_from_raw['heat_expos_c']=cleaned['pop_2015']
calc_from_raw['heat_econ_c']=cleaned['debt']+cleaned['invest']+cleaned['tax_break']
calc_from_raw['heat_gov_c']=cleaned['innovate']+cleaned['climate_real']
calc_from_raw['heat_social_c']=cleaned['corruption']+cleaned['perc_vote']
calc_from_raw['cold_expos']=cleaned['pop_2015']
calc_from_raw['cold_social_c']=cleaned['corruption']+cleaned['perc_vote']
calc_from_raw['cold_econ_c']=cleaned['debt']+cleaned['invest']+cleaned['tax_break']
calc_from_raw['cold_gov_c']=cleaned['innovate']+cleaned['climate_real']
calc_from_raw['flood_social_c']=cleaned['corruption']+cleaned['perc_vote']
calc_from_raw['flood_econ_c']=cleaned['debt']+cleaned['invest']+cleaned['tax_break']
calc_from_raw['flood_gov_c']=cleaned['innovate']+cleaned['climate_real']
calc_from_raw['drought_expos']=cleaned['pop_2015']
calc_from_raw['drought_social_c']=cleaned['corruption']+cleaned['perc_vote']
calc_from_raw['drought_econ_c']=cleaned['debt']+cleaned['invest']+cleaned['tax_break']
calc_from_raw['drought_gov_c']=cleaned['innovate']+cleaned['climate_real']
'''




 frame one (calc_from_raw) creates the six values for each hazard
calc_from_raw =pd.DataFrame()
calc_from_raw['cities']= cities



calc_from_raw['econ_c']=cleaned['debt']+cleaned['invest']+cleaned['tax_break']
calc_from_raw['gov_c']=cleaned['innovate']+cleaned['climate_real']
calc_from_raw['social_c']=cleaned['corruption']+cleaned['perc_vote']
#make sure to use flood_expos for flood. Use this one for the rest
calc_from_raw ['expos_c']=cleaned['pop_2015']

#heat - adaption and sensitivity formulas unique
calc_from_raw['heat_adapt_c']=cleaned['beds_1000']+cleaned['trees']
calc_from_raw['heat_sens_c']=cleaned['alone_65']+cleaned['poverty']+cleaned['disabled']



#cold - adaption and sensitivity formulas unique
calc_from_raw['cold_adapt_c']=cleaned['beds_1000']+cleaned['heating']
calc_from_raw['cold_sens_c']=cleaned['alone_65']+cleaned['work_outside']+cleaned['child_5']

#flood - exposure, sensitivity and adaption formulas unique
calc_from_raw['flood_expos']=cleaned['flood_pop']+cleaned['flood_build']
calc_from_raw['flood_sens_c']=cleaned['older_1999']+cleaned['mobile_home']
calc_from_raw['flood_adapt_c']=cleaned['beds_1000']+cleaned['w_quality']


#drought - sensitivity and adaption unique
calc_from_raw['drought_sens_c']=cleaned['GDP_water_all']+cleaned['perc_fff']
calc_from_raw['drought_adapt_c']=cleaned['d_plan']+cleaned['w_plan']

'''
Risk	 (Exposure + Sensitivity + 1 - Adaptive Capacity)/3
Readiness	 (Social + Economy + Governance)/3
Risk High/low set at 38.40 Readiness high/low set at 46.51

'''
''' Study standardized then used standardized versions
next stage
'''
from sklearn.preprocessing import StandardScaler

prescale_table=calc_from_raw.drop(columns=['cities'])
prescale_features=prescale_table.columns
scaler=StandardScaler()
calc_hazard_stand=scaler.fit_transform(prescale_table)
calc_from_raw_scaled =pd.DataFrame(calc_hazard_stand, columns=prescale_features)
#calc_from_raw_scaled['cities']= cities


risk_recovery_calc=pd.DataFrame()
risk_recovery_calc['cities']= cities
#Readiness is the same value for all hazards so it will only be done once
risk_recovery_calc['readiness_c']=(calc_from_raw_scaled['gov_c']+calc_from_raw_scaled['social_c']+calc_from_raw_scaled['econ_c'])/3

                                                                                                         
risk_recovery_calc['heat_risk']=(calc_from_raw_scaled['expos_c']+calc_from_raw_scaled['heat_adapt_c']+(1-calc_from_raw_scaled['heat_sens_c']))/3
risk_recovery_calc['cold_risk']=(calc_from_raw_scaled['expos_c']+calc_from_raw_scaled['cold_adapt_c']+(1-calc_from_raw_scaled['cold_sens_c']))/3
risk_recovery_calc['flood_risk']=(calc_from_raw_scaled['flood_expos_c']+calc_from_raw_scaled['flood_adapt_c']+(1-calc_from_raw_scaled['flood_sens_c']))/3
risk_recovery_calc['drought_risk']=(calc_from_raw_scaled['expos_c']+calc_from_raw_scaled['drought_adapt_c']+(1-calc_from_raw_scaled['drought_sens_c']))/3
risk_recovery_calc['risk_c']=risk_recovery_calc['heat_risk']+risk_recovery_calc['cold_risk']+risk_recovery_calc['flood_risk']     
risk_recovery_calc.dropna(inplace=True)


city_indicators=pd.read_csv('data/raw_data/City Indicators.csv')
drought_data=pd.read_csv('data/raw_data/Drought Data.csv')
flood_data=pd.read_csv('data/raw_data/Flood Data.csv')
heat_data=pd.read_csv('data/raw_data/Heat Data.csv')
historical=pd.read_csv('data/raw_data/Historical Hazards Outcome Data.csv')
risk_recovery=pd.read_csv('data/raw_data/Overall Risk & Readiness Scores.csv')
sea_level_data=pd.read_csv('data/raw_data/Sea Level Rise Data.csv')


