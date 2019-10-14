# init currect directory
## Note: The working directory must be changed to be consistant with directory on the running machine ##
dir.now <- "C:/Users/Documents/uaa_index/CompiledRCode"
setwd(dir.now)

# Run this for El Capitan to use the xlsx package
# dyn.load('/Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home/lib/server/libjvm.dylib')

# Add folders if they do not exist
## dir.create("scores", showWarnings = FALSE)
## setwd("C:/Users/yxu6/uaa_index/CompiledRCode")

dir.list <- c("UAA", 'logs', 'readiness', 'risk')
lapply(dir.list, dir.create)

source("./R/raw0_data_preparation.R")
source("./R/raw_data_cleaning.R")
source("./R/input_data_preparation.R")
source("./R/score_calculation.R")
source("./R/server_data_preparation.R")
source("./R/UAA_scores.R")

# init some paramters
cutoff.p <- 0.0001
this.year <- "2018"

# prepare the raw0
raw0.preparation.status <- raw0_data_preparation(dir.now = dir.now)

# call the raw data preparation function
raw.cleaning.status <- raw_data_clean(dir.now = dir.now, cutoff.p = cutoff.p, raw0.preparation.status=raw0.preparation.status)

# # check if raw clean status is success. If so, start the input data preparation
input.prep.status <- input_data_prep(dir.now=dir.now, raw.cleaning.status=raw.cleaning.status)
# 
# # check if input data preparation is success. If so, start to calculate the scores one by one
score.calculation.status <- score_calculation(dir.now=dir.now, input.prep.status=input.prep.status)
# 
# check if the score calculations for each indicator are finished. If so, combine the indicator level score and build ND_GAIN scores
UAA.calculation.status <- UAA.score.calculation(dir.now=dir.now, score.calculation.status=score.calculation.status)
# 
# Create resource folder with server data
server_data_preparation(dir.now=dir.now, ND_GAIN.calculation.status=UAA.calculation.status, this.year=this.year)

