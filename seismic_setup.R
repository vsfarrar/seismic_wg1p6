#SetUp
################################
#import SEISMIC-formatted data

#set your working directory 
#(the folder where your data is currently stored and where exports will be saved)
setwd("X:/BAR/Projects/SEISMIC/MeasurementGroup/MeasuresAndEquity/Replicating Victoria's code/Original code/")

#select your SEISMIC-formatted data file (.csv) 
#please call this file "dat" for downstream scripts to work
dat <- read.csv("X:/BAR/Projects/SEISMIC/MeasurementGroup/MeasuresAndEquity/Replicating Victoria's code/Data/cleaned_data.csv", 
                na.strings=c("","NA"))

#name your institution - used for file naming (e.g."UMich", "IU", "UCD")
institution <- "UCD"

################################

#use pacman to install and load all packages required
if (!require("pacman")) install.packages("pacman") #install pacman if not already installed
pacman::p_load(tidyverse, dplyr,broom, plotrix, broom.mixed, lme4, lmerTest, robustlmm)

#grab current date using Sys.Date()
current_date <- as.Date(Sys.Date(), format = "%m/%d/%Y")

#confidence interval functions
lower_ci <- function(mean, se, n, conf_level = 0.95){
  lower_ci <- mean - qt(1 - ((1 - conf_level) / 2), n - 1) * se
}
upper_ci <- function(mean, se, n, conf_level = 0.95){
  upper_ci <- mean + qt(1 - ((1 - conf_level) / 2), n - 1) * se
}

# make sure the variables are in the right format
dat$female = as.character(dat$female)
dat$firstgen = as.character(dat$firstgen)
dat$lowincomeflag = as.character(dat$lowincomeflag)

# RUN ALL SCRIPTS
source("seismic_data_filtering.R")
source("seismic_gaps_over_time.R") 
source("seismic_advantages_groups.R")
source("seismic_model_outputs.R") # warnings
source("seismic_model_outputs_robust.R") 
