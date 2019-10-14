# init currect directory
# dir.now <- "/Users/Cheng/Documents/CRC projects/Projects/CSR/cheng/ND_GAIN/Automatic workflow"
# setwd(dir.now)

# function to calculate score for given indicator directory
score_calculation.dir <- function(indicator.dir=NULL, logfilename=NULL, dat.config=NULL, log.msg.prefix="") {
  # init the success of cleaning status
  is.success <- TRUE
  score <- NULL
  
  # extract indicator name
  folder.info <- strsplit(indicator.dir, "/")
  indicator.name <- folder.info[[1]][length(folder.info[[1]])]
  # print (indicator.name)
  cat(paste(log.msg.prefix, format(Sys.time(), "%a %b %d %X %Y"), "\n", sep=""), file = logfilename, append = TRUE)
  log.msg <- paste(log.msg.prefix, "Working on indicator: ", indicator.name, sep = "")
  print (log.msg)
  cat(log.msg, file = logfilename, append = TRUE)
  cat("\n", file = logfilename, append = TRUE)
  
  filepath.input <- file.path(indicator.dir, 'input.csv')
  filepath.score <- file.path(indicator.dir, 'score.csv')
  # check if raw exists. If not, warning and log errors
  score.pars <- NA
  if (file.exists(filepath.input)) {
    # read the raw.csv file
    input.dat <- read.csv(filepath.input, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
    colnames.list <- colnames(input.dat)
    
    # calculate skewness of all data
    input.dat.numeric <- data.matrix(input.dat[,4:length(colnames.list)], rownames.force = NA)
    
    # find the corresponding config info for the given indicator/sub-indicator
    indicator.config <- dat.config[dat.config$indicator == indicator.name,]
    # get direction
    # print (indicator.config)
    direction <- indicator.config$direction
    
    # get the mean and std for z score calculation
    z.mean <- mean(input.dat.numeric[,ncol(input.dat.numeric)], na.rm = TRUE)
    z.std <- sd(input.dat.numeric[,ncol(input.dat.numeric)], na.rm = TRUE)
    z.count <- sum(!is.na(input.dat.numeric[, ncol(input.dat.numeric)]))
    
    # print (score.pars)
    
    # perform the score calculation
    # calculate z score
    # print (z.mean)
    # print (z.std)
    # print (z.count)
    z.score <- (input.dat.numeric[,ncol(input.dat.numeric)] - z.mean)/z.std
    # core score calculation
    score <-  abs((1 - as.numeric(direction)) - pnorm(z.score))
    
    # convert the final score into [0, 1]
    score.min <- min(score, na.rm = TRUE)
    score.max <- max(score, na.rm = TRUE)
    score.final <- (score - score.min)/(score.max - score.min)
    
    score.pars <- c(indicator.name, z.mean, z.std, z.count, score.min, score.max)
    
    # validate the score
    # print (min(score, na.rm = TRUE))
    # print (max(score, na.rm = TRUE))
    
    # combine cities info and save
    score.dat <- data.frame(input.dat[,1:3], score.final)
    colnames(score.dat) <- colnames.list[c(1:3, ncol(input.dat))]
    
  } else {
    log.msg <- paste(log.msg.prefix, "    ERROR: could not find input.csv", sep="")
    warning(paste(log.msg.prefix, "could not find input.csv", sep=""))
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    is.success <- FALSE
  }
  
  if (is.success) {
    if (file.exists(filepath.score)) file.remove(filepath.score)
    # save score data
    write.csv(score.dat, filepath.score, row.names = FALSE, na = "")
    cat(paste(log.msg.prefix, "    ## Success ##", sep=""), file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
  }
  
  return (list(status=is.success, score.pars=score.pars, score.final=score.dat))
}

score.reader.dirs <- function (dir.list=NULL, logfilename=NULL, log.msg.prefix="") {
  is.success <- TRUE
  score.all <- {}
  colnames.score <- NULL
  # given a list of dirs that already have socre.csv. read and return a list of scores
  for (i in 1:length(dir.list)) {
    indicator.dir <- dir.list[i]
    # extract indicator name
    folder.info <- strsplit(indicator.dir, "/")
    indicator.name <- folder.info[[1]][length(folder.info[[1]])]
    # log the score combine process
    cat(paste(log.msg.prefix, format(Sys.time(), "%a %b %d %X %Y"), "\n", sep=""), file = logfilename, append = TRUE)
    log.msg <- paste(log.msg.prefix, "    Loading indicator: ", indicator.name, sep = "")
    print (log.msg)
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    
    filepath.score <- file.path(indicator.dir, 'score.csv')
    
    if (file.exists(filepath.score)) {
      # read the score
      score.dat <- read.csv(filepath.score, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
      if (is.null(colnames.score)) colnames.score <- colnames(score.dat)
      score.dat.indicator <- data.frame(score.dat, indicator=rep(indicator.name, nrow(score.dat)))
      score.all <- rbind(score.all, score.dat.indicator)
    } else {
      log.msg <- paste(log.msg.prefix, "    ERROR: could not find score.csv", sep="")
      warning(paste(log.msg.prefix, "could not find score.csv", sep=""))
      cat(log.msg, file = logfilename, append = TRUE)
      cat("\n", file = logfilename, append = TRUE)
      is.success <- FALSE
    }
  }
  
  return(list(status=is.success, score.all=score.all, col.names=colnames.score))
}

score_calculation <- function(dir.now=NULL, input.prep.status=FALSE) {
  #load library
  library('xlsx')
  library('e1071')
  # make sure the directory is correct
  setwd(dir.now)
  
  # init the array to track the success clean
  score.cal.status <- {}
  score.overall.log <- {}
  
  # filename for this step
  logfilename <- file.path(dir.now, "logs", "score_calculation_global (step 3).txt")
  # configration file
  config.filename <- file.path(dir.now, "config_never_change.csv")
  dat.config <- read.csv(config.filename, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
  
  # remove the existing log file if it exists
  if (file.exists(logfilename)) file.remove(logfilename)
  
  # read the overall control flow file
  filepath.overall.control <- file.path(dir.now, "logs", "overall_control_panel.xlsx")
  overall.control.log <- read.xlsx(filepath.overall.control, sheetName = 1, header = TRUE)
  # check the status for raw data preparation
  input.prep.status.file <- all(overall.control.log$Input.Data.Preparation == "DONE")
  
  # first check the input flag
  if (input.prep.status & input.prep.status.file) {
    # find all indicator folders
    index.dir <- file.path(dir.now, "index")
    indicator.list <- list.dirs(path = index.dir, full.names = TRUE, recursive = FALSE)
    # remove the supplemental data folder from the indicator list
    indicator.list <- indicator.list[indicator.list != file.path(index.dir, "supplemental_data")]
    
    # loop through all indicators
    # init the parameters for score calculation
    score.pars <- {}
    # init the missing value status matrix
    missing.status.mat <- {}
    for(i in 1:length(indicator.list)) {
      # extract indicator name
      folder.info <- strsplit(indicator.list[i], "/")
      indicator.name <- folder.info[[1]][length(folder.info[[1]])]
      status <- TRUE
      
      score.info <- score_calculation.dir(indicator.dir=indicator.list[i], logfilename=logfilename, dat.config=dat.config, log.msg.prefix="")
      status <- status & score.info$status
      
      # update the score parameters
      if (!is.na(score.info$score.pars[1])) {
        score.pars <- rbind(score.pars, score.info$score.pars)
      }
      
      # update the overall status
      score.cal.status <- rbind(score.cal.status, status)
      
      # output input.csv file if everything works fine
      if (status) {
        score.overall.log <- c(score.overall.log, "DONE")
      } else {
        # update the overall workflow log
        score.overall.log <- c(score.overall.log, "NOT READY")
      }
      cat("\n", file = logfilename, append = TRUE)
      
      # update the missing value status matrix
      missing.status.mat <- rbind(missing.status.mat, c(indicator.name, dat.config[dat.config$indicator==indicator.name,]$sector[1], is.na(score.info$score.final[,4])))
      
    }

    # update the overall workflow log
    overall.control.log$Score <- score.overall.log
    # write to file
    write.xlsx(overall.control.log, filepath.overall.control, row.names = FALSE, col.names = TRUE, showNA=FALSE)
    
    # update the parameter log file
    par.log.filepath <- file.path(dir.now, "logs", "parameters_log.xlsx")
    # write to file
    colnames(score.pars) <- c("indicator", "z.mean", "z.std", "z.count.eff", "score_cdf_min", "score_cdf_max")
    # print (score.pars)
    write.xlsx(score.pars, par.log.filepath, row.names = FALSE, col.names = TRUE, showNA=FALSE)
    
    # write to the missing status file
    # get city name from score.info
    score.final <- score.info$score.final
    colnames(missing.status.mat) <- c("indicator", "sector", score.final$city)
    missing.status.mat[missing.status.mat==FALSE] <- NA
    # re-order it to aggregate the sector
    missing.status.mat.re_ordered <- c("NA", "NA", score.final$state)
    for (idx.missing in 1:nrow(dat.config)) {
      if (!is.na(dat.config$sector[idx.missing])) {
        missing.status.mat.re_ordered <- rbind(missing.status.mat.re_ordered, c(missing.status.mat[missing.status.mat[,1]==dat.config$indicator[idx.missing],]))
      }
    }
    # remove row names
    rownames(missing.status.mat.re_ordered) <- NULL
    missing_status.log.filepath <- file.path(dir.now, "logs", "missing_status_log.xlsx")
    write.xlsx(missing.status.mat.re_ordered, missing_status.log.filepath, row.names = FALSE, col.names = TRUE, showNA=FALSE)
    
    return (all(as.logical(score.cal.status)))
    
  } else {
    log.msg  <- "## Input data preparation step is not fully finished. Please check the log files and review the data accordingly. ##"
    warning(log.msg)
    cat(paste(format(Sys.time(), "%a %b %d %X %Y"), "\n    ", log.msg, sep=""), file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    
    return (FALSE)
  }
}