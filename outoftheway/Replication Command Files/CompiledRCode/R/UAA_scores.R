# read the scores at indicator level and calculate ND GAIN scores 
# init currect directory
# dir.now <- "/Users/Cheng/Documents/CRC projects/Projects/CSR/cheng/ND_GAIN/Automatic workflow"
# setwd(dir.now)

# load source so that we could re-use a function there
source("C:/Users/yxu6/uaa_index/R/score_calculation.R")

UAA.score.calculation <- function(dir.now=NULL, score.calculation.status=FALSE) {
  #load library
  library('xlsx')
  
  # make sure the directory is correct
  setwd(dir.now)
  
  # init the array to track the success scores 
  score.combine.status <- {}
  score.combine.log <- {}
  
  #init five hazards
  hazards <- c("flood", "heat", "cold", "sea", "drought")
  
  # filename for this step
  logfilename <- file.path(dir.now, "logs", "score_UAA (step 4).txt")
  # configration file
  config.filename <- file.path(dir.now, "config_never_change.csv")
  dat.config <- read.csv(config.filename, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
  
  # remove the existing log file if it exists
  if (file.exists(logfilename)) file.remove(logfilename)
  
  # read the overall control flow file
  filepath.overall.control <- file.path(dir.now, "logs", "overall_control_panel.xlsx")
  overall.control.log <- read.xlsx(filepath.overall.control, sheetName = 1, header = TRUE)
  # check the status for raw data preparation
  score.calculation.status.file <- all(overall.control.log$Score == "DONE")
  
  # create hierarchical folder structure
  # get categories
  folder.category <- unique(dat.config$category)
  for (i in 1:length(folder.category)) {
    foldername.category <- tolower(folder.category[i])
    # create folder if it does not exist
    if (!file.exists(file.path(dir.now, foldername.category))) {
      dir.create(file.path(dir.now, foldername.category))
    } 
    
    # get groups in this category
    folder.group <- unique(dat.config[tolower(dat.config$category)==foldername.category,]$group)
    for (j in 1:length(folder.group)) {
      foldername.group <- tolower(folder.group[j])
      # create folder if it does not exist
      if (!file.exists(file.path(dir.now, foldername.category, foldername.group))) {
        dir.create(file.path(dir.now, foldername.category, foldername.group))
      }
      # get sectors in this group
      folder.sector <- unique(dat.config[tolower(dat.config$category)==foldername.category & tolower(dat.config$group)==foldername.group,]$sector)
      for (k in 1:length(folder.sector)) {
        foldername.sector <- tolower(folder.sector[k])
        # create folder if it does not exist
        if (!file.exists(file.path(dir.now, foldername.category, foldername.group, foldername.sector))) {
          dir.create(file.path(dir.now, foldername.category, foldername.group, foldername.sector))
        }
      }
    }
  }
  
  # create folder in the UAA score
  for (idx.hazard in 1:length(hazards)) {
    UAA.hazard.foldername <- file.path(dir.now, "UAA", hazards[idx.hazard])
    # create folder if it does not exist
    if (!file.exists(UAA.hazard.foldername)) {
      dir.create(UAA.hazard.foldername)
    }
  }
  
  # first check the input flag
  if (score.calculation.status & score.calculation.status.file) {
    # find all indicator folders
    index.dir <- file.path(dir.now, "index")
    indicator.list <- list.dirs(path = index.dir, full.names = TRUE, recursive = FALSE)
    # remove the supplemental data folder from the indicator list
    indicator.list <- indicator.list[indicator.list != file.path(index.dir, "supplemental_data")]

    # first read all scores and combine them into a date frame
    # log
    log.msg <- paste("Load indicator scores", sep = "")
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    # read 
    scores.info <- score.reader.dirs(dir.list=indicator.list, logfilename=logfilename, log.msg.prefix="    ")
    status <- scores.info$status
    score.all <- scores.info$score.all
    col.names <- scores.info$col.names
    # get all ISO3 tags
    geo.id.all <- unique(score.all$geo.id)
    
    # add extra line in between
    cat("\n", file = logfilename, append = TRUE)
    
    # first calculate sector scores
    # extract all sectors
    sectors <- unique(dat.config$sector)
    # remove empty string 
    sectors <- sectors[!(sectors == "")]
    # loop through all sectors and calculate scores at sector level
    log.msg <- paste("Calculating sector scores", sep = "")
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    
    # init a sector score matrix for validate the sector level tolerance
    sector.scores.all <- {}
    for (idx.sector in 1:length(sectors)) {
      # get corresponding indicators
      dat.config.sector <- dat.config[dat.config$sector == sectors[idx.sector], ]
      
      # check the group
      sector.category.info <- unique(dat.config.sector$category)
      sector.category <- NA
      if (length(sector.category) > 1) {
        # log error
        log.msg <- paste("    Error: please check the category information for sector (", sectors[idx.sector], ")", sep = "")
        cat(log.msg, file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
      } else {
        sector.category <- sector.category.info[1]
      }
      
      # check the group
      sector.group.info <- unique(dat.config.sector$group)
      sector.group <- NA
      if (length(sector.group) > 1) {
        # log error
        log.msg <- paste("    Error: please check the group information for sector (", sectors[idx.sector], ")", sep = "")
        cat(log.msg, file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
      } else {
        sector.group <- sector.group.info[1]
      }
      
      # loop through all five hazards
      for (idx.hazard in 1:length(hazards)) {
        hazard <- hazards[idx.hazard]
        log.msg <- paste("    (", hazard,")Working on sector: ", sectors[idx.sector], sep = "")
        cat(log.msg, file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
        
        # get the number of indicators in this sector
        hazard.sectors <- dat.config.sector[dat.config.sector[[hazard]]=="1",]
        # calculate the tolerance value. Pass 50%
        hazard.sectors.count <- nrow(hazard.sectors)
        num.missing.val <- hazard.sectors.count/2
        
        # indicators for this sector
        hazard.sector.indicator <- hazard.sectors$indicator
        
        # loop through all cities
        score.final <- {}
        for (idx.geo.id in 1:length(geo.id.all)) {
          # get all the indicator data for this sector
          sector.dat <- score.all[score.all$geo.id==geo.id.all[idx.geo.id] & score.all$indicator %in% hazard.sector.indicator,]
          sector.dat.numeric <- sector.dat[, 4:(ncol(sector.dat)-1)]
          
          # calculate the mean score
          score.mean.sector <- mean(sector.dat.numeric, na.rm = TRUE)
          # check the tolerance
          score.mean.sector[sum(is.na(sector.dat.numeric)) > num.missing.val] <- NA
          # add to the overall sector scores
          score.final <- rbind(score.final, as.numeric(score.mean.sector))
        }
        
        # validate score.final and save
        if (is.matrix(score.final)) {
          sector.score.filepath <- file.path(dir.now, tolower(sector.category), tolower(sector.group), tolower(sectors[idx.sector]), paste(hazard, ".csv", sep = "") )
          score.final <- cbind(score.all[1:length(geo.id.all),1:3], score.final)
          colnames(score.final) <- col.names
          # save the score
          write.csv(score.final, sector.score.filepath, row.names = FALSE, na = "")
          cat(paste("    (", hazard,")## Success ##", sep=""), file = logfilename, append = TRUE)
          cat("\n", file = logfilename, append = TRUE)
          
          # update the sector scores all
          sector.scores.all <- rbind(sector.scores.all, data.frame(sector=rep(sectors[idx.sector], length(geo.id.all)), hazard=rep(hazard, length(geo.id.all)), score.final))
        } else {
          log.msg <- paste("    (", hazard,")Error: could not calculate the sector score for (", sectors[idx.sector], ")", sep = "")
          cat(log.msg, file = logfilename, append = TRUE)
          cat("\n", file = logfilename, append = TRUE)
          stop(log.msg)
        }
        
      }

    }
    
    # set the colname
    colnames(sector.scores.all)[1:2] <- c("sector", "hazard")
    sector.scores.all[, ncol(sector.scores.all)][which(sector.scores.all$sector == "Adaptive Capacity")] <- 1 - sector.scores.all[, ncol(sector.scores.all)][which(sector.scores.all$sector == "Adaptive Capacity")]

    
    # second calculate group scores for Vulnerability, exposure and readiness
    group.score.final <- {}
    # extract all groups
    groups <- unique(dat.config$group)
    # remove empty string 
    groups <- groups[!(groups == "")]
    # loop through all groups and calculate scores at groups level
    log.msg <- paste("Calculating groups scores", sep = "")
    cat("\n", file = logfilename, append = TRUE)
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    
    for (idx.group in 1:length(groups)) {
      # get corresponding indicators
      dat.config.group <- dat.config[dat.config$group == groups[idx.group], ]
      # check the group
      group.info <- unique(dat.config.group$group)
      group <- NA
      if (length(group) > 1) {
        # log error
        log.msg <- paste("    Error: please check the group information for group (", groups[idx.group], ")", sep = "")
        cat(log.msg, file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
      } else {
        group <- group.info[1]
      }
      
      # loop through all five hazards
      for (idx.hazard in 1:length(hazards)) {
        hazard <- hazards[idx.hazard]
        log.msg <- paste("    (", hazard,")Working on group: ", group, sep = "")
        cat(log.msg, file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
      
        # get the tolerance value
        # get number of sectors in this group
        group.sectors <- unique(dat.config.group$sector)
        num.missing.val <- length(group.sectors)/2
        
        # loop through all countries
        score.final <- {}
        for (idx.geo.id in 1:length(geo.id.all)) {
          # get all the indicator data for this component
          group.dat <- sector.scores.all[sector.scores.all$geo.id==geo.id.all[idx.geo.id] & sector.scores.all$sector %in% group.sectors & sector.scores.all$hazard==hazard,]
          group.dat.numeric <- group.dat[, ncol(group.dat)]
          
          # calculate the mean score
          score.mean.group <- mean(group.dat.numeric, na.rm = TRUE)
          # check the tolerance
          if (sum(is.na(group.dat.numeric)) >= num.missing.val)  score.mean.group <- NA
          
          # add to the overall group scores
          score.final <- rbind(score.final, score.mean.group)
        }
        
        # validate score.final and save
        if (is.matrix(score.final)) {
          group.score.filepath <- file.path(dir.now, "UAA", hazard, paste(tolower(group), ".csv", sep = "") )
          score.final <- cbind(score.all[1:length(geo.id.all),1:3], score.final)
          colnames(score.final) <- col.names
          # add group scores to the overall group scores
          group.score.final <- rbind(group.score.final, data.frame(category=rep(group, length(geo.id.all)), hazard=rep(hazard, length(geo.id.all)),score.final))
          # save the score
          write.csv(score.final, group.score.filepath, row.names = FALSE, na = "")
          cat(paste("    (", hazard,")## Success ##", sep=""), file = logfilename, append = TRUE)
          cat("\n", file = logfilename, append = TRUE)
        } else {
          log.msg <- paste("    (", hazard,")Error: could not calculate the group score for (", group, ")", sep = "")
          cat(log.msg, file = logfilename, append = TRUE)
          cat("\n", file = logfilename, append = TRUE)
          stop(log.msg)
        }
      }
    }
    # assign column names
    colnames(group.score.final)[1:2] <- as.character(colnames(group.score.final)[1:2])
    colnames(group.score.final)[1:2] <- c("group", "hazard")
    
    # calculate category scores
    category.score.final <- {}
    # extract all categories
    categories <- unique(dat.config$category)
    # remove empty string 
    categories <- categories[!(categories == "")]
    # loop through all categories and calculate scores at category level
    log.msg <- paste("Calculating category scores", sep = "")
    cat("\n", file = logfilename, append = TRUE)
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    
    for (idx.category in 1:length(categories)) {
      # init average for all hazards
      category.score.average <- {}
      # get corresponding indicators
      dat.config.category <- dat.config[dat.config$category == categories[idx.category], ]
      # check the group
      category.info <- unique(dat.config.category$category)
      category <- NA
      if (length(category) > 1) {
        # log error
        log.msg <- paste("    Error: please check the category information for category (", categories[idx.category], ")", sep = "")
        cat(log.msg, file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
      } else {
        category <- category.info[1]
      }
      
      # loop through all five hazards
      for (idx.hazard in 1:length(hazards)) {
        hazard <- hazards[idx.hazard]
        log.msg <- paste("    (", hazard,")Working on category: ", category, sep = "")
        cat(log.msg, file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
        
        # get the tolerance value
        # get number of groups in this category
        category.groups <- unique(dat.config.category$group)
        num.missing.val <- length(category.groups)/2
        
        # loop through all countries
        score.final <- {}
        for (idx.geo.id in 1:length(geo.id.all)) {
          # get all the group data for this category
          category.dat <- group.score.final[group.score.final$geo.id==geo.id.all[idx.geo.id] & group.score.final$group %in% category.groups & group.score.final$hazard==hazard,]
          category.dat.numeric <- category.dat[, ncol(category.dat)]
          
          # calculate the mean score
          score.mean.category <- mean(category.dat.numeric, na.rm = TRUE)
          # check the tolerance
          if (sum(is.na(category.dat.numeric)) >= num.missing.val)  score.mean.category <- NA
          # if sea level rise, only keep the score for those cities that have exposure data
          if (hazard == "sea" && category == "Risk") {
            if (is.na(category.dat[category.dat$group=="Exposure", ncol(category.dat)])) {
              score.mean.category <- NA
            }
          }
          
          # add to the overall category scores
          score.final <- rbind(score.final, score.mean.category)
        }
        
        # validate score.final and save
        if (is.matrix(score.final)) {
          category.score.filepath <- file.path(dir.now, "UAA", hazard, paste(tolower(category), ".csv", sep = "") )
          score.final <- cbind(score.all[1:length(geo.id.all),1:3], score.final)
          colnames(score.final) <- col.names
          # add category scores to the overall category scores
          category.score.final <- rbind(category.score.final, data.frame(category=rep(category, length(geo.id.all)), hazard=rep(hazard, length(geo.id.all)),score.final))
          # save the score
          write.csv(score.final, category.score.filepath, row.names = FALSE, na = "")
          cat(paste("    (", hazard,")## Success ##", sep=""), file = logfilename, append = TRUE)
          cat("\n", file = logfilename, append = TRUE)
          
          # collect the score for category in col format
          category.score.average <- cbind(category.score.average, score.final[,ncol(score.final)])

        } else {
          log.msg <- paste("    (", hazard,")Error: could not calculate the category score for (", category, ")", sep = "")
          cat(log.msg, file = logfilename, append = TRUE)
          cat("\n", file = logfilename, append = TRUE)
          stop(log.msg)
        }
      }
      
      # calculate the averaged category score for each city
      category.average <- rowMeans(category.score.average, na.rm = TRUE)
      category.average <- cbind(score.all[1:length(geo.id.all),1:3], category.average)
      # save the category averaged score to the current directory
      write.csv(category.average, file.path(dir.now, "UAA", paste(category, "_average.csv", sep="")), row.names = FALSE, na = "")
    }
    # assign column names
    colnames(category.score.final)[1:2] <- as.character(colnames(category.score.final)[1:2])
    colnames(category.score.final)[1:2] <- c("category", "hazard")
    
    # calculate the final UAA score
    log.msg <- paste("Calculating UAA scores", sep = "")
    cat("\n", file = logfilename, append = TRUE)
    cat(log.msg, file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    # init UAA matrix
    UAA.score.average <- {}
    
    # loop through all five hazards
    for (idx.hazard in 1:length(hazards)) {
      hazard <- hazards[idx.hazard]
      log.msg <- paste("    (", hazard,")Working on UAA score: ", categories[idx.category], sep = "")
      cat(log.msg, file = logfilename, append = TRUE)
      cat("\n", file = logfilename, append = TRUE)
      
      # get the tolerance value
      # get number of groups in this category
      UAA.categories <- unique(dat.config$category)
      num.missing.val <- length(UAA.categories)/2
      
      # loop through all countries
      score.final <- {}
      for (idx.geo.id in 1:length(geo.id.all)) {
        # get all the indicator data for this component
        UAA.dat <- category.score.final[category.score.final$geo.id==geo.id.all[idx.geo.id] & category.score.final$category %in% UAA.categories & category.score.final$hazard==hazard,]
        # redirect Risk before average
        UAA.dat[,ncol(UAA.dat)][which(UAA.dat$category == "Risk")] <- 1- UAA.dat[,ncol(UAA.dat)][which(UAA.dat$category == "Risk")]
        UAA.dat.numeric <- UAA.dat[, ncol(UAA.dat)]
        
        # calculate the mean score
        score.mean.UAA <- mean(UAA.dat.numeric, na.rm = TRUE)
        # check the tolerance
        if (sum(is.na(UAA.dat.numeric)) >= num.missing.val)  score.mean.UAA <- NA
        # if sea level rise, only keep the score for those cities that have exposure data
        if (hazard == "sea") {
          if (is.na(UAA.dat[UAA.dat$category=="Risk", ncol(UAA.dat)])) {
            score.mean.UAA <- NA
          }
        }
        
        # add to the overall UAA scores
        score.final <- rbind(score.final, score.mean.UAA * 100)
      }
      
      # validate score.final and save
      if (is.matrix(score.final)) {
        category.score.filepath <- file.path(dir.now, "UAA", hazard, "UAA.csv" )
        score.final <- cbind(score.all[1:length(geo.id.all),1:3], score.final)
        colnames(score.final) <- col.names
        # save the score
        write.csv(score.final, category.score.filepath, row.names = FALSE, na = "")
        cat(paste("    (", hazard,")## Success ##", sep=""), file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
        # collect scores for each hazard
        UAA.score.average <- cbind(UAA.score.average, score.final[,ncol(score.final)])
      } else {
        log.msg <- paste("    (", hazard,")Error: could not calculate the UAA score", sep = "")
        cat(log.msg, file = logfilename, append = TRUE)
        cat("\n", file = logfilename, append = TRUE)
        stop(log.msg)
      }
    }
      
    # calculate the average of all hazards for each city
    UAA.average <- rowMeans(UAA.score.average, na.rm = TRUE)
    UAA.average <- cbind(score.all[1:length(geo.id.all),1:3], UAA.average)
    # save the category averaged score to the current directory
    write.csv(UAA.average, file.path(dir.now, "UAA", "UAA_average.csv"), row.names = FALSE, na = "")
    
    return (TRUE)
    
  } else {
    log.msg  <- "## Indicator level score calculation is not fully finished. Please check the log files and review the data accordingly. ##"
    warning(log.msg)
    cat(paste(format(Sys.time(), "%a %b %d %X %Y"), "\n    ", log.msg, sep=""), file = logfilename, append = TRUE)
    cat("\n", file = logfilename, append = TRUE)
    
    return (FALSE)
  }
}