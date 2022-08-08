#SetUp
################################
#import SEISMIC-formatted data

#set your working directory 
#(the folder where your data is currently stored and where exports will be saved)
setwd("~/Downloads/seismic_R_files/")

#select your SEISMIC-formatted data file (.csv) 
#please call this file "dat" for downstream scripts to work
dat <- read.csv("UCD_BIS101_BIS104_SEISMIC-format_GPAO-cum_2022-01-24.csv", 
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
  mutate(across(c(female, firstgen, ethniccode, ethniccode_cat, 
                  urm, lowincomeflag, transfer, international), as.character))

# RUN ALL SCRIPTS
source("seismic_data_filtering.R")
source("seismic_gaps_over_time.R") 
source("seismic_advantages_groups.R")
#source("seismic_model_outputs.R") #currently turned off, robust rlmer models run instead. 
source("seismic_model_outputs_robust.R") #note: may take >30 min for large datasets. 
