library("dplyr")
library("lavaan")
library("pscl")

## Note: The working directory must be changed to be consistant with directory on the running machine ##
setwd("C:/Users/Documents/uaa_index/CompiledRCode")

data = read.csv("storm outcome.csv", na.strings = c("NA",""))
flood.raw = data %>% select(matches("flood.*Instances|flood.*Damage|city|State|Geo"))

data907 = read.csv("DroughtCollection.csv")
## Data Preprocess, remove columns ##
data_1 = data907 %>%
         select(-Name, -SQMI, -State, -County, -edu_12.1)

data_1[,c("Existence_of_drought_management_plans_2015","Existence_of_water_management_plan_2015")] =
  apply(data_1[,c("Existence_of_drought_management_plans_2015","Existence_of_water_management_plan_2015")],
                                   2,  function(x) ifelse(x=="Yes", 1,0))

## Transform factors into numerics and remove NA observations ##
## data_1[,"debt"] %<>% lapply(function(x) as.numeric(as.character(x)))
data_1[,"debt"] = as.numeric( levels(data_1[,"debt"])[data_1[,"debt"]])
dim(data_1)
which(rowSums(is.na(data_1)) != 0)

city.geo = data907[,c(2,11:14)]
##colnames(city.geo)[2] = "City"
flood.state.name = state.abb[match(flood.raw[,3],state.name)]
flood.state.name[98] = 'DC'
flood.state.name[213:216] = 'PR'
which(is.na(flood.state.name))
flood.raw[,3] = as.factor(flood.state.name)
colnames(flood.raw)[1] = "Name"
data.merge = merge(flood.raw, city.geo) ##, by = c("Geo_ID"))
flood.combine = cbind(data.merge[,1:3], data.merge[,4:5]+data.merge[,6:7])
str(flood.combine)
head(flood.combine)
trial = merge(data_1[,-7:-8],flood.combine)
head(trial)
str(trial)
## trial %>% filter(Flood.Instances == 0)

## data_final = na.omit(data_1)

flood_model = "
              expo =~  floodzone_pop+floodzone_build
              social =~ a * corruption + b * civ_engage
              a + b == 2
              sens =~  build_1999+mobile_home
              adapt =~  hosp_beds+water_quality
              econ =~  debt+incentives_energy
              governance =~  patents+global_warming"

drought_model = "
              expo =~ a * city_pop
              a == 1
              social =~ corruption + civ_engage
              sens =~  Percentage_of_workforce_in_Farming__Fishing_and_Forestry_2015+Percent_of_GDP_based_on_water_intensive_industries
              adapt =~  Existence_of_drought_management_plans_2015+Existence_of_water_management_plan_2015
              econ =~  debt+bond_worth+incentives_energy
              governance =~  patents+global_warming"

flood_fit = sem(flood_model, data = trial, std.lv= T, std.ov= T, orthogonal = T, missing = "ml")
drought_fit = sem(drought_model, data = data_1, std.lv= T, std.ov= T, orthogonal = T, missing = "ml")

flood_category_score = predict(flood_fit, data_1)
drought_category_score = predict(drought_fit, data_1)

rescale_flood_category_score = apply(scale(flood_category_score), 2, pnorm)
rescale_drought_category_score = apply(scale(drought_category_score), 2, pnorm)

flood_NB = cbind(trial$Flood.Damage, trial$Flood.Instances, rescale_flood_category_score)
damage.per.ins = ifelse(flood_NB[,2] != 0, flood_NB[,1]/(flood_NB[,2]*flood_NB[,3]*data_1$city_pop*0.001), 0)
flood_NB[,1] = round(damage.per.ins)
colnames(flood_NB)[1:2] = c("Damage", "Instances")
flood_NB = as.data.frame(flood_NB) %>% dplyr::select(-Instances)
summary(flood_NB)

direction.flood = expand.grid(c(1,-1),c(1,-1), c(1,-1),c(1,-1),c(1,-1), c(1,-1),0,0,0)
for ( i in 1:64)
{
print(i)
flood_NB2 = cbind(flood_NB[,1], mapply('*',flood_NB[,2:7], direction.flood[i,1:6]))
colnames(flood_NB2)[1] = "Damage"
flood_NB2 = as.data.frame(flood_NB2) %>%
              mutate(risk = expo + sens + adapt + length(which(direction.flood[i,c(1,3,4)] == -1))) %>%
              mutate(readiness = social + econ + governance + length(which(direction.flood[i, c(2,5,6)] == -1)))
flood_NB_fit = tryCatch( {zeroinfl(Damage~risk + readiness|risk, data = flood_NB2, dist = "negbin", EM = T)},
                         error = function(c) NA)
if( is.na(flood_NB_fit))
{
  direction.flood[i,7:9] = c(NA, NA, NA)
} else
{
    direction.flood[i,7:9] = c(flood_NB_fit$coefficients[[1]][2:3], flood_NB_fit$coefficients[[2]][2])
}
}
summary(flood_NB_fit)
colnames(direction.flood) = c("expo", "social", "sens", "adapt", "econ", "governance", "risk1", "readiness", "risk2")


drought_NB = cbind(data_1$Drought.Damage, data_1$Drought.Instances, rescale_drought_category_score)
damage.per.ins = ifelse(drought_NB[,2] != 0, drought_NB[,1]/(data_1$city_pop*0.001), 0)
drought_NB[,1] = round(damage.per.ins)
colnames(drought_NB)[1:2] = c("Damage", "Instances")
drought_NB = as.data.frame(drought_NB) %>% dplyr::select(-Instances)
summary(drought_NB)

direction.drought = expand.grid(c(1,-1),c(1,-1), c(1,-1),c(1,-1),c(1,-1), c(1,-1),0,0,0)
for ( i in 1:64)
{
print(i)
drought_NB2 = cbind(drought_NB[,1], mapply('*',drought_NB[,2:7], direction.drought[i,1:6]))
colnames(drought_NB2)[1] = "Damage"
drought_NB2 = as.data.frame(drought_NB2) %>%
              mutate(risk = expo + sens + adapt + length(which(direction.drought[i,c(1,3,4)] == -1))) %>%
              mutate(readiness = social + econ + governance + length(which(direction.drought[i, c(2,5,6)] == -1)))
drought_NB_fit = zeroinfl(Damage~risk + readiness|risk, data = drought_NB2, dist = "negbin", EM = T)
summary(drought_NB_fit)
direction.drought[i,7:9] = c(drought_NB_fit$coefficients[[1]][2:3], drought_NB_fit$coefficients[[2]][2])
drought_model = c(drought_model, drought_NB_fit)
}
colnames(direction.drought) = c("expo", "social", "sens", "adapt", "econ", "governance", "risk1", "readiness", "risk2")


flood.select = cbind(na.omit(direction.flood), 0, 0)
for ( i in 1:nrow(flood.select))
{
flood_NB2 = cbind(flood_NB[,1], mapply('*',flood_NB[,2:7], flood.select[i,1:6]))
colnames(flood_NB2)[1] = "Damage"
flood_NB2 = as.data.frame(flood_NB2) %>%
              mutate(risk = (expo + sens + adapt + length(which(flood.select[i,c(1,3,4)] == -1)))/3) %>%
              mutate(readiness = (social + econ + governance + length(which(flood.select[i, c(2,5,6)] == -1)))/3)
flood_NB_fit = zeroinfl(Damage~risk + readiness|risk, data = flood_NB2, dist = "negbin", EM = T)
flood_NB_predict = predict(flood_NB_fit, flood_NB2[,8:9])
flood_deviance = sum((flood_NB[,1] - flood_NB_predict)^2)
flood_correlation = cor(flood_NB2$risk, flood_NB2$readiness)
flood.select[i, 10:11] = c(flood_deviance, flood_correlation)
}
## flood.select
colnames(flood.select)[10:11] = c("residual_square", "correlation")
flood1 = (flood.select %>% arrange(correlation, residual_square))[1,]

drought.select = cbind(na.omit(direction.drought), 0, 0)
for ( i in 1:nrow(drought.select))
{
drought_NB2 = cbind(drought_NB[,1], mapply('*',drought_NB[,2:7], drought.select[i,1:6]))
colnames(drought_NB2)[1] = "Damage"
drought_NB2 = as.data.frame(drought_NB2) %>%
              mutate(risk = (expo + sens + adapt + length(which(drought.select[i,c(1,3,4)] == -1)))/3) %>%
              mutate(readiness = (social + econ + governance + length(which(drought.select[i, c(2,5,6)] == -1)))/3)
drought_NB_fit = zeroinfl(Damage~risk + readiness|risk, data = drought_NB2, dist = "negbin", EM = T)
drought_NB_predict = predict(drought_NB_fit, drought_NB2[,8:9])
drought_deviance = sum((drought_NB[,1] - drought_NB_predict)^2)
drought_correlation = cor(drought_NB2$risk, drought_NB2$readiness)
drought.select[i, 10:11] = c(drought_deviance, drought_correlation)
}
## drought.select
colnames(drought.select)[10:11] = c("residual_square", "correlation")
drought1 = (drought.select %>% arrange(correlation, residual_square))[1,]



flood_NB2 = cbind(flood_NB[,1], mapply('*',flood_NB[,2:7], flood1[1,1:6]))
colnames(flood_NB2)[1] = "Damage"
flood_NB2 = as.data.frame(flood_NB2) %>%
              mutate(risk = (expo + sens + adapt + length(which(flood1[1,c(1,3,4)] == -1)))/3) %>%
              mutate(readiness = (social + econ + governance + length(which(flood1[1, c(2,5,6)] == -1)))/3)
flood_NB_fit = zeroinfl(Damage~risk + readiness|risk, data = flood_NB2, dist = "negbin", EM = T)
flood_NB_predict = predict(flood_NB_fit, flood_NB2[,8:9])
flood_predict_total = flood_NB_predict * flood_NB[,2] * data_1$city_pop * 0.001
flood_NB2 = ifelse(as.matrix(flood_NB2)<0, 1 + as.matrix(flood_NB2), as.matrix(flood_NB2))
flood_NB2[,5] = 1-flood_NB2[,5]
head(flood_NB2)
summary(flood_NB2)
plot(flood_NB2[,8],flood_NB2[,9], main="Flood Correlation", xlab = "risk", ylab = "readiness")


flood_result_export = cbind(trial[,c(44,45,1)],"flood_real"=trial$Flood.Damage/trial$Flood.Instances, "flood_predict"=flood_predict_total)
head(flood_result_export)
length(which(is.na(flood_result_export[,4])))
flood_result_export[which(is.na(flood_result_export[,4])),]
flood.raw[which(is.na(flood_result_export[,4])),]
flood.result.na = flood_result_export[which(is.na(flood_result_export[,4])),]
write.csv(flood_result_export,"flood_cost.csv",row.names = F)

drought_NB2 = cbind(drought_NB[,1], mapply('*',drought_NB[,2:7], drought1[1,1:6]))
colnames(drought_NB2)[1] = "Damage"
drought_NB2 = as.data.frame(drought_NB2) %>%
              mutate(risk = (expo + sens + adapt + length(which(drought1[1,c(1,3,4)] == -1)))/3) %>%
              mutate(readiness = (social + econ + governance + length(which(drought1[1, c(2,5,6)] == -1)))/3)
drought_NB_fit = zeroinfl(Damage~risk + readiness|risk, data = drought_NB2, dist = "negbin", EM = T)
drought_NB_predict = predict(drought_NB_fit, drought_NB2[,8:9])
drought_predict_total = drought_NB_predict * data_1$city_pop * 0.001
drought_NB2 = ifelse(as.matrix(drought_NB2)<0, 1 + as.matrix(drought_NB2), as.matrix(drought_NB2))
drought_NB2[,5] = 1-drought_NB2[,5]
head(drought_NB2)
summary(drought_NB2)
plot(drought_NB2[,8],drought_NB2[,9], main="Drought Correlation", xlab = "risk", ylab = "readiness")
drought_geo = left_join(data907[,1:2],trial[,c(44,45,1)],by="Geo_ID") %>% select(-X)

drought_result_export = cbind(drought_geo,drought_NB2, "drought_real"=data_1$Drought.Damage, "drought_predict"=drought_predict_total)
head(drought_result_export)
write.csv(drought_result_export %>% select(Name, State, Geo_ID, drought_real, drought_predict),"drought_cost.csv",row.names = F)
