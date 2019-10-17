'drought_risk', 'drought_vuln', 'drought_expose','drought_sens', 'drought_adapt', 'drought_ready', 'drought_social', 'drought_gov','drought_econ', 'drought_hist_cost'
'cleaned'=
['city'	'state'	'geo_id'	'GDP_water_all'
'perc_fff'	'd_plan'	'w_plan' 'base_w_stress'
'invest'	'tax_break'	'corruption'
	'perc_vote'	'innovate' 'climate_real'	'not_grad'	
    'pop_dens'	'w_quality	''debt'	'flood_pop'
    'flood_build'	'flood_car'	'impervious'
    'beds_1000'	'alone_65'	'child_5'	'health_ins'
    'older_1999'	'mobile_home'	'rent_50plus'
    'trees'	'heating'	'disabled'	'poverty'
    'older_1979'	'work_outside'	'no_car'	'pop_under_1ft'
    'pop_under_3ft'	'impact_plus1ft'	'impact_plus3ft'
    'lat'	'long' 'county'	'region'	'city_km2'	
    'pop_2010'	'pop_2011'	'pop_20102' 'pop_2013' 
    'pop_2014'	'pop_2015'	'median_income']

civ_engage = perc_vote

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
Risk	 (Exposure + Sensitivity + 1 - Adaptive Capacity)/3
Readiness	 (Social + Economy + Governance)/3



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