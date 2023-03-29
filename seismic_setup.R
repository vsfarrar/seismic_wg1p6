#SetUp
################################
#import SEISMIC-formatted data

#set your working directory 
#(the folder where your data is currently stored and where exports will be saved)
setwd("~/Downloads/seismic_R_files/")

#select your SEISMIC-formatted data file (.csv) 
#please call this file "dat" for downstream scripts to work
dat <- read.csv("UCD_BIS101_BIS104_f09-f19_SEISMIC-format_GPAO-cumulative_2022-08-08.csv", 
                na.strings=c("","NA"))

#name your institution - used for file naming (e.g."UMich", "IU", "UCD")
institution <- "UCD"

################################

#use pacman to install and load all packages required
if (!require("pacman")) install.packages("pacman") #install pacman if not already installed
pacman::p_load(tidyverse, dplyr,broom, plotrix, broom.mixed, lme4, lmerTest, robustlmm, gmodels)

#grab current date using Sys.Date()
current_date <- as.Date(Sys.Date(), format = "%m/%d/%Y")

# make sure demographic variables are entered as character class
dat <- dat %>% 
  mutate(across(c(female, firstgen, ethniccode_cat, 
                  lowincomeflag, transfer, international), as.character))

# RUN ALL SCRIPTS
source("seismic_data_filtering.R") #filters data and produces two datasets, one with and one without international

#1.Run all scripts including international students (conservatively coded)
dat_new <- dat_int
source("seismic_gaps_over_time.R") 
source("seismic_advantages_groups.R")
#source("seismic_model_outputs.R") #currently turned off, robust rlmer models run instead. 
source("seismic_model_outputs_robust.R") #note: may take >30 min for large datasets. 

#2.Run all scripts again excluding international students completely
dat_new <- dat_noInt

#create folder with analyses when international students are excluded
mainDir <- getwd()
dir.create(file.path(mainDir, "international_excluded"))
  #move scripts to this new folder 
filestocopy <- c("seismic_gaps_over_time.R", "seismic_advantages_groups.R", "seismic_model_outputs_robust.R") #scripts to move
targetDir <- paste0(getwd(),"/international_excluded") #target directory to move them

file.copy(from=filestocopy, to=targetDir, 
          overwrite = TRUE, recursive = FALSE, 
          copy.mode = TRUE) #copies files

setwd(file.path(mainDir, "international_excluded")) #set new folder as working directory

#re-run scripts
source("seismic_gaps_over_time.R") 
source("seismic_advantages_groups.R")
#source("seismic_model_outputs.R") #currently turned off, robust rlmer models run instead. 
source("seismic_model_outputs_robust.R") #note: may take >30 min for large datasets. 

#edit names of files in this directory for clarity

x <- list.files(full.names = TRUE) #get file paths 
newNames <- ifelse(tools::file_ext(x) == "csv",
                   paste(tools::file_path_sans_ext(x), "no-international.csv", sep = "_"),
                   x) #suffix with folder
file.rename(x, newNames) #rename with old names (returns TRUE)

#remove extra,copied R files 
file.remove(filestocopy)

