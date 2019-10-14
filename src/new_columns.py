'drought_risk', 'drought_vuln', 'drought_expose','drought_sens', 'drought_adapt', 'drought_ready', 'drought_social', 'drought_gov','drought_econ', 'drought_hist_cost'
'city_indicators'
'city'	'state'	'geo_id'	'GDP_water_all'
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
    'pop_2014'	'pop_2015'	'median_income'


calc_from_raw =pd.Dataframe()
calc_from_raw ['city_pop']=city_indicators['pop_2015']


#heat
calc_from_raw['heat_expos']=city_indicators['pop_2015']

#cold
calc_from_raw['cold_expos']=city_indicators['pop_2015']

#flood
calc_from_raw['flood_expos']=city_indicators['flood_pop']+city_indicators['flood_build']

#drought
calc_from_raw['drought_expos']=city_indicators['pop_2015']
