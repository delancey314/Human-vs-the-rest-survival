server_data_preparation <- function(dir.now=dir.now, ND_GAIN.calculation.status=ND_GAIN.calculation.status, this.year=NULL) {
  setwd(dir.now)
  #init five hazards
  hazards <- c("flood", "heat", "cold", "sea", "drought")
  
  # create the folder to save the final scores
  server.folder.name <- paste("Final UAA Scores(", this.year, ")", sep="")
  folder.scores.final <- file.path(dir.now, server.folder.name)
  if (!file.exists(folder.scores.final)) {
    dir.create(folder.scores.final)
  }
  
  # create folder in the UAA score
  for (idx.hazard in 1:length(hazards)) {
    UAA.hazard.foldername.final <- file.path(dir.now, server.folder.name, hazards[idx.hazard])
    # create folder if it does not exist
    if (!file.exists(UAA.hazard.foldername.final)) {
      dir.create(UAA.hazard.foldername.final)
    }
  }
  
  # read the config file
  # configration file
  config.filename <- file.path(dir.now, "config_never_change.csv")
  dat.config <- read.csv(config.filename, header = T, stringsAsFactors = FALSE, check.names = FALSE)
  # save this file to the folder for developers
  write.csv(dat.config, file.path(dir.now, server.folder.name, "config.csv"), row.names = F, na = "")
  
  # now we are going to prepare the fianl scores for developer team
  
  # init raw for all hazards
  indicator.raw <- {}
  # init score for all hazards
  indicator.score <- {}
  # city info
  city.info <- NA
  
  # indicator scores
  # find all indicator folders
  index.dir <- file.path(dir.now, "index")
  indicator.list <- list.dirs(path = index.dir, full.names = TRUE, recursive = FALSE)
  # remove the supplemental data folder from the indicator list
  indicator.list <- indicator.list[indicator.list != file.path(index.dir, "supplemental_data")]
  
  # read the data one by one
  indicator.names <- {}
  for (idx.indicator in 1:length(indicator.list)) {
    # extract indicator name
    indicator.dir <- indicator.list[idx.indicator]
    folder.info <- strsplit(indicator.dir, "/")
    indicator.name <- folder.info[[1]][length(folder.info[[1]])]
    indicator.names <- c(indicator.names, indicator.name)
    # score filepath
    indicator.filepath <- file.path(indicator.dir, 'score.csv')
    indicator.dat <- read.csv(indicator.filepath, header = T, stringsAsFactors = FALSE, check.names = FALSE)
    indicator.score <- cbind(indicator.score, indicator.dat[, ncol(indicator.dat)])
    # raw filepath
    indicator.raw.filepath<- file.path(indicator.dir, 'input.csv')
    indicator.raw.dat <- read.csv(indicator.raw.filepath, header = T, stringsAsFactors = FALSE, check.names = FALSE)
    indicator.raw <- cbind(indicator.raw, indicator.raw.dat[, ncol(indicator.raw.dat)])
    
    # init the city info
    if (!is.matrix(city.info)) city.info <- indicator.dat[, 1:3]
  }
  # combine the city info and scores and raw
  indicator.score <- data.frame(city.info, indicator.score)
  indicator.raw <- data.frame(city.info, indicator.raw)
  # assign col names
  colnames(indicator.score)[4:ncol(indicator.score)] <- indicator.names
  colnames(indicator.raw)[4:ncol(indicator.raw)] <- indicator.names
  # save all indicators' scores
  write.csv(indicator.score, file.path(dir.now, server.folder.name, "all_indicators_score.csv"), row.names = F, na = "")
  write.csv(indicator.raw, file.path(dir.now, server.folder.name, "all_indicators_raw.csv"), row.names = F, na = "")
  
  
  for (idx.hazard in 1:length(hazards)) {
    # get hazard
    hazard <- hazards[idx.hazard]
    
    # prepare group score in category 
    categories <- unique(dat.config$category)
    category.score <- {}
    
    for (idx.category in 1:length(categories)) {
      # find groups in category
      category <- categories[idx.category]
      category.groups <- unique(dat.config[dat.config$category == category, ]$group)
      # read group data for each hazard
      hazard.folder <- file.path(dir.now, "UAA", hazard)
      # get group scores
      group.scores <- {}
      for (idx.group in 1:length(category.groups)) {
        category.group <- category.groups[idx.group]
        group.score.filepath <- file.path(hazard.folder, paste(tolower(category.group), ".csv", sep=""))
        group.dat <- read.csv(group.score.filepath, header = T, stringsAsFactors = FALSE, check.names = FALSE)
        group.scores <- cbind(group.scores, group.dat[, ncol(indicator.dat)])
      }
      # combine the city info and scores
      group.scores <- data.frame(city.info, group.scores)
      # assign col names
      colnames(group.scores)[4:ncol(group.scores)] <- category.groups
      # save all indicators' scores
      category.score.folder <- file.path(dir.now, server.folder.name, hazard, category)
      if (!file.exists(category.score.folder)) {
        dir.create(category.score.folder)
      }
      write.csv(group.scores, file.path(category.score.folder, paste(tolower(category), ".csv", sep="")), row.names = F, na = "")
      
      ####
      # prepare category score
      category.score.filepath <- file.path(hazard.folder, paste(category, ".csv", sep=""))
      category.dat <- read.csv(category.score.filepath, header = T, stringsAsFactors = FALSE, check.names = FALSE)
      category.score <- cbind(category.score, category.dat[, ncol(indicator.dat)])
    }
    # combine the city info and scores
    category.score <- data.frame(city.info, category.score)
    # assign col names
    colnames(category.score)[4:ncol(category.score)] <- categories
    # save all indicators' scores
    write.csv(category.score, file.path(dir.now, server.folder.name, hazard, "UAA_category.csv"), row.names = F, na = "")
    
    # copy the final UAA score to this folder
    UAA.filepath <- file.path(hazard.folder, "UAA.csv")
    UAA.dat <- read.csv(UAA.filepath, header = T, stringsAsFactors = FALSE, check.names = FALSE)
    write.csv(UAA.dat, file.path(dir.now, server.folder.name, hazard, "UAA.csv"), row.names = F, na = "")
    
    # now copy sector scores to the final folder
    filepath.hazard.risk.exposure.from <- file.path(dir.now, "risk", "exposure", "exposure", paste(hazard, ".csv", sep=""))
    filepath.hazard.risk.exposure.to <- file.path(dir.now, server.folder.name, hazard, "Risk", "exposure.csv")
    file.copy(filepath.hazard.risk.exposure.from, filepath.hazard.risk.exposure.to, overwrite = TRUE)
    filepath.hazard.risk.vulnerability.capacity.from <- file.path(dir.now, "risk", "vulnerability", "adaptive capacity", paste(hazard, ".csv", sep=""))
    filepath.hazard.risk.vulnerability.capacity.to <- file.path(dir.now, server.folder.name, hazard, "Risk", "adaptive capacity.csv")
    file.copy(filepath.hazard.risk.vulnerability.capacity.from, filepath.hazard.risk.vulnerability.capacity.to, overwrite = TRUE)
    filepath.hazard.risk.vulnerability.sensitivity.from <- file.path(dir.now, "risk", "vulnerability", "sensitivity", paste(hazard, ".csv", sep=""))
    filepath.hazard.risk.vulnerability.sensitivity.to <- file.path(dir.now, server.folder.name, hazard, "Risk", "sensitivity.csv")
    file.copy(filepath.hazard.risk.vulnerability.sensitivity.from, filepath.hazard.risk.vulnerability.sensitivity.to, overwrite = TRUE)
    # copy vulnerability to target folder
    filepath.hazard.risk.vulnerability.from <- file.path(dir.now, "UAA", hazard, "vulnerability.csv")
    filepath.hazard.risk.vulnerability.to <- file.path(dir.now, server.folder.name, hazard, "Risk", "vulnerability.csv")
    file.copy(filepath.hazard.risk.vulnerability.from, filepath.hazard.risk.vulnerability.to, overwrite = TRUE)
    
    # readiness
    sectors.readiness <- tolower(unique(dat.config[dat.config$category=="Readiness",]$sector))
    for (idx.sectors.readiness in 1:length(sectors.readiness)) {
      sector.name <- sectors.readiness[idx.sectors.readiness]
      filepath.hazard.readiness.sector.from <- file.path(dir.now, "readiness", "readiness", sector.name, paste(hazard, ".csv", sep=""))
      filepath.hazard.readiness.sector.to <- file.path(dir.now, server.folder.name, hazard, "Readiness", paste(sector.name, ".csv", sep=""))
      file.copy(filepath.hazard.readiness.sector.from, filepath.hazard.readiness.sector.to, overwrite = TRUE)
    }
  }
  
  # copy averaged scores to the folder
  categories <- unique(dat.config$category)
  for (idx.category in 1:length(categories)) {
    filepath.from <- file.path(dir.now, "UAA", paste(categories[idx.category], "_average.csv", sep=""))
    filepath.to <- file.path(dir.now, server.folder.name, paste(categories[idx.category], "_average.csv", sep=""))
    file.copy(filepath.from, filepath.to, overwrite = TRUE)
  }
  file.copy(file.path(dir.now, "UAA", "UAA_average.csv"), file.path(dir.now, server.folder.name, "UAA_average.csv"), overwrite = TRUE)
  
  # read the data parameters_log.csv
  filepath.par.log <- file.path(dir.now, "logs", "parameters_log.xlsx")
  parameters.log <- read.xlsx(filepath.par.log, header = TRUE, sheetIndex = 1)
  # calculate min/max from indicator.raw
  # loop all indicators
  input.min <- {}
  input.max <- {}
  for (idx.indicator in 1:length(parameters.log$indicator)) {
    indicator.name <- as.character(parameters.log$indicator[idx.indicator])
    # print (indicator.name)
    input.indicator <- indicator.raw[[indicator.name]]
    input.min <- c(input.min, min(input.indicator, na.rm = TRUE))
    input.max <- c(input.max, max(input.indicator, na.rm = TRUE))
  }
  # save them to the parameters_log
  parameters.log <- data.frame(parameters.log, raw_min=input.min, raw_max=input.max)
  # save the file to server data folder
  filepath.par.log.server <- file.path(dir.now, server.folder.name, "parameters_log.csv")
  write.csv(parameters.log, filepath.par.log.server, row.names = F, na = "")
  
  # remove the supplemental data folder from the server folder
  supplemental.folder.server <- file.path(dir.now, server.folder.name, "supplemental_data")
  if (dir.exists(supplemental.folder.server)) {
    unlink(supplemental.folder.server, recursive=TRUE)
  }
  dir.create(supplemental.folder.server)
  # copy supplemental data to the server folder
  file.copy(file.path(index.dir, "supplemental_data"), file.path(dir.now, server.folder.name), recursive=TRUE)
}