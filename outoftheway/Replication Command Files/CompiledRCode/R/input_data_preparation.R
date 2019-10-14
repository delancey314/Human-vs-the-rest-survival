# init currect directory
# dir.now <- "/Users/Cheng/Documents/CRC projects/Projects/CSR/cheng/ND_GAIN/Automatic workflow"
# setwd(dir.now)

## Code that Linearly Interpolate & Flat Extrapolate
## http://eurekastatistics.com/exploring-the-world-banks-gini-index-data-with-r/
## Written by Peter Rosenmai on 17 Dec 2013. Last revised 18 Dec 2013.

LinearlyInterpolateFlatExtrapolate <- function(v, max.extrapolate=NA) {
  # Linearly interpolates and straight-line extrapolates
  #
  # Examples:
  # LinearlyInterpolateFlatExtrapolate(c(NA, NA,  1, NA, NA), NA) returns c( 1,  1,  1,  1,  1)
  # LinearlyInterpolateFlatExtrapolate(c(NA,  2, NA,  4, NA), NA) returns c( 2,  2,  3,  4,  4)
  # LinearlyInterpolateFlatExtrapolate(c(NA, NA, NA, NA, NA), NA) returns c(NA, NA, NA, NA, NA)
  # LinearlyInterpolateFlatExtrapolate(c(NA, NA,  1, NA, NA),  1) returns c(NA,  1,  1,  1, NA)
  
  n              <- length(v)
  indexes.non.na <- which(!is.na(v))
  n.not.na       <- length(indexes.non.na)
  
  if (n.not.na == 0) return(v)
  
  x <- 1:n
  v <- approx(x=x, y=v, xout=x, rule=2:2, method=ifelse(n.not.na == 1, "constant", "linear"))$y
  
  if (!is.na(max.extrapolate)){
    # Set to NA the data beyond the permitted extrapolation range
    non.na.range.min <- max(1, (min(indexes.non.na) - max.extrapolate))
    non.na.range.max <- min(n, (max(indexes.non.na) + max.extrapolate))
    v[setdiff(1:n, non.na.range.min:non.na.range.max)] <- NA
  }
  
  return(v)
}

# function to get calculate the input data for given directory
input_data_prep.dir <- function(indicator.dir=NULL, logfilename=NULL, log.msg.prefix="") {
  # init the success of cleaning status
  is.success <- TRUE
  # init the input data
  input.dat.numeric <- {}
  
  # extract indicator name
  folder.info <- strsplit(indicator.dir, "/")
  indicator.name <- folder.info[[1]][length(folder.info[[1]])]
  # print (indicator.name)
  cat(paste(log.msg.prefix, format(Sys.time(), "%a %b %d %X %Y"), "\n", sep=""), file = logfilename, append = TRUE)
  log.msg <- paste(log.msg.prefix, "Working on indicator: ", indicator.name, sep = "")
  print (log.msg)
  cat(log.msg, file = logfilename, append = TRUE)
  cat("\n", file = logfilename, append = TRUE)
  
  filepath.raw <- file.path(indicator.dir, 'raw.csv')
  # file path for input data output
  filepath.input <- file.path(indicator.dir, 'input.csv')
  # check if raw exists. If not, warning and log errors
  if (file.exists(filepath.raw)) {
    # read the raw.csv file
    raw.dat <- read.csv(filepath.raw, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
    colnames.list <- colnames(raw.dat)
    
    # loop through all cities
    for (j in 1:length(raw.dat$geo.id)) {
      raw.city.dat <- raw.dat[j,]
      indicator.val <- as.numeric(raw.city.dat[4:length(colnames.list)])
      input.dat.row <- LinearlyInterpolateFlatExtrapolate(indicator.val, NA)
      # add to the overall data frame
      input.dat.numeric <- rbind(input.dat.numeric, input.dat.row)
    }
  } else {
    log.msg <- paste(log.msg.prefix, "    ERROR: could not find raw.csv", sep="")
    warning(paste(log.msg.prefix, "could not find raw.csv", sep=""))
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    is.success <- FALSE
  }
  
  if (is.success) {
    if (file.exists(filepath.input)) file.remove(filepath.input)
    rownames(input.dat.numeric) <- NULL
    input.dat <- data.frame(raw.dat[,1:3], input.dat.numeric)
    colnames(input.dat) <- colnames.list
    write.csv(input.dat, filepath.input, row.names = FALSE, quote=TRUE, na = "")
    cat(paste(log.msg.prefix, "    ## Success ##", sep=""), file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
  }
  
  return (is.success)
}

# start the input data preparation

input_data_prep <- function(dir.now=NULL, raw.cleaning.status=FALSE) {
  #load library
  library('xlsx')
  # make sure the directory is correct
  setwd(dir.now)

  # init the array to track the success clean
  input.prep.status <- {}
  input.overall.log <- {}
  
  # filename for this step
  logfilename <- file.path(dir.now, "logs", "input data preparation_global (step 2).txt")
  # remove the existing log file if it exists
  if (file.exists(logfilename)) file.remove(logfilename)
  
  # read the overall control flow file
  filepath.overall.control <- file.path(dir.now, "logs", "overall_control_panel.xlsx")
  overall.control.log <- read.xlsx(filepath.overall.control, sheetName = 1, header = TRUE)
  # check the status for raw data preparation
  raw.cleaning.status.file <- all(overall.control.log$Raw.Data.Preparation == "DONE")
  
  # first check the input flag
  if (raw.cleaning.status & raw.cleaning.status.file) {
    # find all indicator folders
    index.dir <- file.path(dir.now, "index")
    indicator.list <- list.dirs(path = index.dir, full.names = TRUE, recursive = FALSE)
    # remove the supplemental data folder from the indicator list
    indicator.list <- indicator.list[indicator.list != file.path(index.dir, "supplemental_data")]
    
    # loop through all indicators
    for(i in 1:length(indicator.list)) {
      # extract indicator name
      folder.info <- strsplit(indicator.list[i], "/")
      indicator.name <- folder.info[[1]][length(folder.info[[1]])]
      status <- TRUE
      
      status <- input_data_prep.dir(indicator.dir=indicator.list[i], logfilename=logfilename, log.msg.prefix="")
      
      # update the overall status
      input.prep.status <- rbind(input.prep.status, status)
      
      # output input.csv file if everything works fine
      if (status) {
        # update the overall workflow log
        input.overall.log <- c(input.overall.log, "DONE")
      } else {
        # update the overall workflow log
        input.overall.log <- c(input.overall.log, "NOT READY")
      }
      cat("\n", file = logfilename, append = TRUE)
    }
    
    # update the overall workflow log
    overall.control.log$Input.Data.Preparation <- input.overall.log
    # write to file
    write.xlsx(overall.control.log, filepath.overall.control, row.names = FALSE, col.names = TRUE, showNA=FALSE)
    
    return (all(as.logical(input.prep.status)))
    
  } else {
    log.msg  <- "## Raw data preparation step is not fully finished. Please check the log files and review the data accordingly. ##"
    warning(log.msg)
    cat(paste(format(Sys.time(), "%a %b %d %X %Y"), "\n    ", log.msg, sep=""), file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    
    return (FALSE)
  }
  
}
