# Prepare the raw0 based on the given data.
# Normalize the raw_origin following the config file

# function to get calculate the raw data for given directory
raw0_data_prep.dir <- function(indicator.dir=NULL, supplemental.dir=NULL, logfilename=NULL, log.msg.prefix="", dat.config=NULL) {
  # init the success of cleaning status
  is.success <- TRUE
  # init the input data
  raw0.dat.numeric <- {}
  
  # extract indicator name
  folder.info <- strsplit(indicator.dir, "/")
  indicator.name <- folder.info[[1]][length(folder.info[[1]])]
  # print (indicator.name)
  cat(paste(log.msg.prefix, format(Sys.time(), "%a %b %d %X %Y"), "\n", sep=""), file = logfilename, append = TRUE)
  log.msg <- paste(log.msg.prefix, "Working on indicator: ", indicator.name, sep = "")
  print (log.msg)
  cat(log.msg, file = logfilename, append = TRUE)
  cat("\n", file = logfilename, append = TRUE)
  
  filepath.raw_origin <- file.path(indicator.dir, 'raw_origin.csv')
  # file path for input data output
  filepath.raw0 <- file.path(indicator.dir, 'raw0.csv')
  
  # check if raw exists. If not, warning and log errors
  if (file.exists(filepath.raw_origin)) {
    # read the raw.csv file
    raw_original.dat <- read.csv(filepath.raw_origin, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
    colnames.list <- colnames(raw_original.dat)
    
    # get the normalization config for this indicator
    indicator.config <- dat.config[dat.config$indicator==indicator.name,]

    # init raw0.dat
    raw0.dat <- {}
    
    # do nothing if norm is 0
    # print (indicator.config$norm)
    if (indicator.config$norm == "0") {
      raw0.dat <- read.csv(filepath.raw_origin, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
    } else {
      # perform normalization
      # load the data for denominator
      denominator.filepath <- file.path(supplemental.dir, indicator.config$norm, "raw_origin.csv")
      denominator.dat <- read.csv(denominator.filepath, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
      numerator.dat <- read.csv(filepath.raw_origin, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
      # get years
      years <- colnames(numerator.dat)[4:ncol(numerator.dat)]
      dat.normalized <- {}
      for (idx.year in 1:length(years)) {
        # per 1000 people in case the number is too small
        if (indicator.config$norm == "population") {
          dat.normalized <- cbind(dat.normalized, 1000*numerator.dat[[years[idx.year]]]/denominator.dat[[years[idx.year]]])
        } else {
          dat.normalized <- cbind(dat.normalized, numerator.dat[[years[idx.year]]]/denominator.dat[[years[idx.year]]])
        }
      }
      # new data
      denominator.dat[4:ncol(denominator.dat)] <- dat.normalized
      raw0.dat <- denominator.dat
    }
  } else {
    log.msg <- paste(log.msg.prefix, "    ERROR: could not find raw.csv", sep="")
    warning(paste(log.msg.prefix, "could not find raw.csv", sep=""))
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    is.success <- FALSE
  }
  
  if (is.success) {
    if (file.exists(filepath.raw0)) file.remove(filepath.raw0)
    # save the data
    write.csv(raw0.dat, filepath.raw0, row.names = FALSE, quote=TRUE, na = "")
    cat(paste(log.msg.prefix, "    ## Success ##", sep=""), file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
  }
  
  return (is.success)
}

raw0_data_preparation <- function(dir.now=NULL) {
  #load library
  library('xlsx')
  # make sure the directory is correct
  setwd(dir.now)
  
  # init the array to track the success clean
  raw0.preparation.status <- {}
  
  # filename for this step
  logfilename <- file.path(dir.now, "logs", "raw0 data preparation_global (step 0).txt")
  # remove the existing log file if it exists
  if (file.exists(logfilename)) file.remove(logfilename)
  
  # find all indicator folders
  index.dir <- file.path(dir.now, "index")
  indicator.list <- list.dirs(path = index.dir, full.names = TRUE, recursive = FALSE)
  # remove the supplemental data folder from the indicator list
  indicator.list <- indicator.list[indicator.list != file.path(index.dir, "supplemental_data")]
  
  # load config file
  # configration file
  config.filename <- file.path(dir.now, "config_never_change.csv")
  dat.config <- read.csv(config.filename, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
  
  # init the array to track the success clean
  raw0.preparation.status <- {}
  
  # loop through all indicators
  for(i in 1:length(indicator.list)) {
    # extract indicator name
    log.msg.prefix <- "    "
    folder.info <- strsplit(indicator.list[i], "/")
    indicator.name <- folder.info[[1]][length(folder.info[[1]])]
    
    # find the corresponding config info for the given indicator/sub-indicator
    indicator.config <- dat.config[dat.config$indicator == indicator.name,]
    
    # supplemental.dir
    supplemental.dir <- file.path(dir.now, "index", "supplemental_data")
    
    
    # check indicators one by one to see if we need the norm
    status <- raw0_data_prep.dir(indicator.dir=indicator.list[i], supplemental.dir=supplemental.dir, logfilename=logfilename, log.msg.prefix="", dat.config=dat.config)
    
    # update the overall status
    raw0.preparation.status <- rbind(raw0.preparation.status, c(indicator.name, status))
  }
  
  # update the overall workflow control panel
  filepath.overall.control <- file.path(dir.now, "logs", "overall_control_panel.xlsx")
  overall.all.log <- c("indicator", "Raw0 Data Preparation", "Raw Data Preparation", "Input Data Preparation", "Score")
  for (i in 1:dim(raw0.preparation.status)[1]) {
    status.str <- ifelse(raw0.preparation.status[i, 2], "DONE", "NOT READY")
    rownames(overall.all.log) <- NULL
    overall.all.log <- rbind(overall.all.log, c(raw0.preparation.status[i, 1], status.str, "NOT READY", "NOT READY", "NOT READY"))
  }
  # write to file
  write.xlsx(overall.all.log, filepath.overall.control, row.names = FALSE, col.names = FALSE, showNA=FALSE)
  
  return(all(as.logical(raw0.preparation.status[, 2])))
}

