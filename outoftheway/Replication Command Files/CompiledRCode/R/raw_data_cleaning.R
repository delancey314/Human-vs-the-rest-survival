# init currect directory
# dir.now <- "/Users/Cheng/Documents/CRC projects/Projects/CSR/cheng/ND_GAIN/Automatic workflow"
# setwd(dir.now)

# function to clean the data in the given director
raw_data_clean.dir <- function(indicator.dir=NULL, cutoff.p=0.0001, logfilename=NULL, log.msg.prefix="", debug=TRUE) {
  # init the success of cleaning status
  is.success <- TRUE
  raw.clean.status <- {}
  
  # extract indicator name
  folder.info <- strsplit(indicator.dir, "/")
  indicator.name <- folder.info[[1]][length(folder.info[[1]])]
  # print (indicator.name)
  cat(paste(log.msg.prefix, format(Sys.time(), "%a %b %d %X %Y"), "\n", sep=""), file = logfilename, append = TRUE)
  log.msg <- paste(log.msg.prefix, "Working on indicator: ", indicator.name, sep = "")
  print (log.msg)
  cat(log.msg, file = logfilename, append = TRUE)
  cat("\n", file = logfilename, append = TRUE)
  
  # indicator level log file
  logfilename.indicator <- file.path(indicator.dir, "raw_data_preparation log.txt")
  filepath.raw0 <- file.path(indicator.dir, 'raw0.csv')
  filepath.raw <- file.path(indicator.dir, 'raw.csv')
  filepath.raw_review <- file.path(indicator.dir, 'raw_expert_review.xlsx')
  
  # check if raw0 exists. If not, warning and log errors
  if (file.exists(filepath.raw0)) {
    # remove the existing log file if it exists
    if (file.exists(logfilename.indicator)) file.remove(logfilename.indicator)
    # read raw0 and combine it with the raw_review data
    raw.dat <- read.csv(filepath.raw0, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
    # first check if it is a debug mode. If so, directly save raw0 to raw.
    if (debug) {
      if (file.exists(filepath.raw)) file.remove(filepath.raw)
      # clean the YES and NO
      for (j in 1:length(raw.dat$geo.id)) {
        # replace YES to 1, and No to 0
        raw.dat[j,][raw.dat[j,]=="Yes"] <- 1
        raw.dat[j,][raw.dat[j,]=="No"] <- 0
      }
      write.csv(raw.dat, filepath.raw, row.names = FALSE, na = "")
      cat(paste(log.msg.prefix, "    ## Success ##", sep=""), file = logfilename, append = TRUE)
      cat("\n", file = logfilename, append = TRUE)
      return (TRUE)
    }
    colnames.list <- colnames(raw.dat)
    years <- as.numeric(colnames.list[4:length(colnames.list)])
    
    # read raw_review if this file exists. Combine the modification to raw
    if (file.exists(filepath.raw_review)) {
      raw_review.before <- read.xlsx(filepath.raw_review, sheetName = 1, header = T)
    } else {
      raw_review.before <- NA
    }
    
    # check the difference col by col
    if (class(raw_review.before) == "data.frame") {
      for (row.index in 1:length(raw_review.before$geo.id)) {
        raw_review.row <- raw_review.before[row.index, ]
        # print (raw_review.row)
        reviewer.name <- as.character(raw_review.row$UAA.Reviewer.Name)
        # get the corresponding raw data
        raw.dat.row <- raw.dat[raw.dat$geo.id == as.character(raw_review.row$geo.id), ]
        # print (raw.dat.row)
        # Check if this field was updated. If so, log the change and replace the original data with this row
        is.review_name.valid <- TRUE
        if (is.na(reviewer.name)) {
          is.review_name.valid <- FALSE
        } else {
          if (reviewer.name == "") is.review_name.valid <- FALSE
        }
        
        if (is.review_name.valid) {
          # print (reviewer.name)
          for (col.index in 3:(length(raw_review.row)-2)) {
            #print (col.index)
            #print (row.index)
            raw_review.cell <- as.numeric(as.character(raw_review.row[col.index]))
            #print (raw_review.row[row.index, col.index])
            #print (raw_review.cell)
            # find the corresponding value for raw
            raw.cell <- as.numeric(raw.dat.row[col.index])
            
            # compare
            validation.flag <- raw.cell != raw_review.cell
            validation.flag <- ifelse(is.na(validation.flag), TRUE, validation.flag)
            if (is.na(raw.cell) && is.na(raw_review.cell)) validation.flag <- FALSE
            if (validation.flag) {
              raw.cell.str <- ifelse(is.na(raw.cell), "NA", as.character(raw.cell))
              raw_review.cell.str <- ifelse(is.na(raw_review.cell), "NA", as.character(raw_review.cell))
              log.msg.raw <- paste(log.msg.prefix, format(Sys.time(), "%a %b %d %X %Y"), ": (", raw.dat.row$Name, ", ", colnames.list[col.index], ") is updated from ", raw.cell.str, " to ", raw_review.cell.str, " by ", reviewer.name, sep="") 
              # print (log.msg.raw)
              cat(log.msg.raw, file = logfilename.indicator, append = TRUE)
              cat("\n", file = logfilename.indicator, append = TRUE)
              # replace the raw with the updated data
              raw.dat[raw.dat$ISO3 == raw_review.row$ISO3, col.index] <- raw_review.cell
            } 
          } 
        } else {
          log.msg <- paste(log.msg.prefix, "    Reviewer's Name for ", as.character(raw_review.row$Name),  " (", as.character(raw_review.row$ISO3), ") cannot be blank.", sep = "")
          warning(paste(log.msg, " (", indicator.name, ")", sep=""))
          print (log.msg)
          cat(log.msg, file = logfilename, append = TRUE)
          cat("\n", file = logfilename, append = TRUE)
          is.success <- FALSE
        }
      }
    }
    
    # if we already have the raw_review file generated. No need to run the hypothesis test again, since we assume the expert from UAA team will make sure the data are correct when he/she signs
    if (class(raw_review.before) == "data.frame") {
      # update the overall status
      raw.clean.status <- rbind(raw.clean.status, c(indicator.name, is.success))
      # save the raw data if success
      if (is.success) {
        if (file.exists(filepath.raw)) file.remove(filepath.raw)
        write.csv(raw.dat, filepath.raw, row.names = FALSE,na = "")
        cat(log.msg.prefix, "    ## Success ##", file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
      }
      cat("\n", file = logfilename, append = TRUE)
      # skip
      
      return (is.success)
    }
    
    # loop through all countries and find fishy data
    # init raw_review output
    raw_review.dat <- c(colnames.list, "UAA Reviewer Name", "comments")
    for (j in 1:length(raw.dat$geo.id)) {
      raw.city.dat <- raw.dat[j,]
      # print (raw.country.dat$Name)
      # replace YES to 1, and No to 0
      raw.city.dat[raw.city.dat=="Yes"] <- 1
      raw.city.dat[raw.city.dat=="No"] <- 0
      indicator.val <- as.numeric(raw.city.dat[4:length(colnames.list)])
      # validate the input data. In order to perform a linear regression, we need at least three data points
      # If less than three data points, only check the magnitude to make sure one is not 10 times large/small
      # If the last two values are not the same sign, raise warning as well
      is.numeric.index <- sapply(indicator.val, is.numeric) & !sapply(indicator.val, is.na)
      number.valid.val <- sum(is.numeric.index)
      if (number.valid.val > 2) {
        indicator.val.valid <- indicator.val[is.numeric.index]
        years.valid <- years[is.numeric.index]
        fit <- lm(indicator.val.valid ~ years.valid)
        
        # hypothesis test for the residues
        std <- sd(fit$residuals)
        p.value <- ifelse(std > 0, chisq.out.test(fit$residuals)$p.value, std^2)
        # print (p.value)
        
        # init the flag if added to the raw_review file
        is.added.to.raw_review <- FALSE
        if (p.value < cutoff.p) {
          log.msg <- paste(log.msg.prefix, "    A positive outlier detection has been reported. Please take a close look at the data for #", raw.city.dat$city, ".", sep="")
          warning(paste(log.msg.prefix, log.msg, " (", indicator.name, ")", sep=""))
          print (log.msg)
          cat(log.msg, file = logfilename, append = TRUE)
          cat("\n", file = logfilename, append = TRUE)
          is.success <- FALSE
          # add this colume to raw_review
          # check if this one has been updated by reviewer
          reviewer.name.before <- comments.before <- ""
          if (class(raw_review.before) == "data.frame") {
            # find corresponding row in raw_review
            row.index.same <- as.character(raw_review.before$geo.id) == raw.city.dat$geo.id
            if (any(row.index.same)) {
              reviewer.dat.before.row <- raw_review.before[row.index.same,]
              reviewer.name.before <- as.character(reviewer.dat.before.row$UAA.Reviewer.Name)
              comments.before <- as.character(reviewer.dat.before.row$comments)
            }
          }
          raw_review.dat <- rbind(raw_review.dat, c(raw.city.dat, reviewer.name.before, comments.before))
        } 
        
      } else {
        if (number.valid.val == 2) {
          # check magnitude
          val.valid.index <- which(is.numeric.index)
          #print (indicator.val)
          #print (val.valid.index)
          if (as.numeric(indicator.val[val.valid.index[1]]) * as.numeric(indicator.val[val.valid.index[2]]) == 0) {
            # set it to be always valid
            val.ratio <- 1
          } else {
            val.ratio <- abs(as.numeric(indicator.val[val.valid.index[1]])/as.numeric(indicator.val[val.valid.index[2]]))
          }
          
          #print (val.ratio)
          if (val.ratio > 10 | val.ratio < 0.1) {
            log.msg <- paste(log.msg.prefix, "    WARNING:The magnitude of the last two valid values are 10 times different. Please check.", sep="")
            warning(paste(log.msg, " (", indicator.name, ")", sep=""))
            print (log.msg)
            cat(log.msg, file = logfilename, append = TRUE)
            cat("\n", file = logfilename, append = TRUE)
            is.success <- FALSE
            # add this colume to raw_review
            # check if this one has been updated by reviewer
            reviewer.name.before <- comments.before <- ""
            if (class(raw_review.before) == "data.frame") {
              # find corresponding row in raw_review
              row.index.same <- as.character(raw_review.before$geo.id) == raw.city.dat$geo.id
              if (any(row.index.same)) {
                reviewer.dat.before.row <- raw_review.before[row.index.same,]
                reviewer.name.before <- as.character(reviewer.dat.before.row$UAA.Reviewer.Name)
                comments.before <- as.character(reviewer.dat.before.row$comments)
              }
            }
            raw_review.dat <- rbind(raw_review.dat, c(raw.city.dat, reviewer.name.before, comments.before))
          }
          
        } else {
          # do nothing here
        }
      }
    }
    
    # save raw_review
    # avoid the prefix X added to the years
    # check raw_review format 
    if (class(raw_review.dat) == "matrix") {
      write.xlsx(raw_review.dat, filepath.raw_review, row.names = FALSE, col.names = FALSE, showNA=FALSE)
    }
    
  } else {
    log.msg <- paste(log.msg.prefix, "    ERROR: could not find raw0.csv", sep="")
    warning(paste(log.msg.prefix, "could not find raw0.csv", sep = ""))
    print (log.msg)
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    is.success <- FALSE
  }
  
  # save the raw data if success
  if (is.success) {
    if (file.exists(filepath.raw)) file.remove(filepath.raw)
    write.csv(raw.dat, filepath.raw, row.names = FALSE, na = "")
    cat(paste(log.msg.prefix, "    ## Success ##", sep=""), file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
  }
  cat("\n", file = logfilename, append = TRUE)
  
  return (is.success)
}

raw_data_clean <- function(dir.now=NULL, cutoff.p=0.0001, raw0.preparation.status=FALSE) {
  #load library
  library("outliers")
  library('xlsx')
  # make sure the directory is correct
  setwd(dir.now)
  
  # init the array to track the success clean
  raw.clean.status <- {}
  
  # filename for this step
  logfilename <- file.path(dir.now, "logs", "raw data preparation_global (step 1).txt")
  # remove the existing log file if it exists
  if (file.exists(logfilename)) file.remove(logfilename)
  
  # find all indicator folders
  index.dir <- file.path(dir.now, "index")
  indicator.list <- list.dirs(path = index.dir, full.names = TRUE, recursive = FALSE)
  # remove the supplemental data folder from the indicator list
  indicator.list <- indicator.list[indicator.list != file.path(index.dir, "supplemental_data")]
  
  # read the overall control flow file
  filepath.overall.control <- file.path(dir.now, "logs", "overall_control_panel.xlsx")
  overall.control.log <- read.xlsx(filepath.overall.control, sheetName = 1, header = TRUE)
  # check the status for raw data preparation
  raw0.prep.status.file <- all(overall.control.log$Raw0.Data.Preparation == "DONE")
  
  if (raw0.prep.status.file) {
    # loop through all indicators
    for(i in 1:length(indicator.list)) {
      # extract indicator name
      log.msg.prefix <- "    "
      folder.info <- strsplit(indicator.list[i], "/")
      indicator.name <- folder.info[[1]][length(folder.info[[1]])]
      status <- TRUE
      status <- raw_data_clean.dir(indicator.dir=indicator.list[i], cutoff.p=cutoff.p, logfilename=logfilename, debug=TRUE)
      
      # update the overall status
      raw.clean.status <- rbind(raw.clean.status, c(indicator.name, status))
    }
    
    # update the overall workflow control panel
    filepath.overall.control <- file.path(dir.now, "logs", "overall_control_panel.xlsx")
    overall.all.log <- c("indicator", "Raw Data Preparation", "Input Data Preparation", "Score")
    for (i in 1:dim(raw.clean.status)[1]) {
      status.str <- ifelse(raw.clean.status[i, 2], "DONE", "NOT READY")
      rownames(overall.all.log) <- NULL
      overall.all.log <- rbind(overall.all.log, c(raw.clean.status[i, 1], status.str, "NOT READY", "NOT READY"))
    }
    # write to file
    write.xlsx(overall.all.log, filepath.overall.control, row.names = FALSE, col.names = FALSE, showNA=FALSE)
  } else {
    log.msg  <- "## Raw0 data preparation step is not fully finished. Please check the log files and review the data accordingly. ##"
    warning(log.msg)
    cat(paste(format(Sys.time(), "%a %b %d %X %Y"), "\n    ", log.msg, sep=""), file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
  }
  
  return(all(as.logical(raw.clean.status[, 2])))
}

