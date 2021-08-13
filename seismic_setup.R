#SetUp
################################
#import SEISMIC-formatted data

#set your working directory (the folder where your data is currently stored and where exports will be saved)
setwd("~/Documents/projects/dber_seismic/test_code/")

#select your SEISMIC-formatted data file (.csv)
dat <- read.csv("~/Documents/projects/dber_seismic/UCD_CBS_upper_division_SEISMIC-format_2021-08-06.csv", 
                na.strings=c("","NA"))

################################

#use pacman to install and load all packages required
if (!require("pacman")) install.packages("pacman") #install pacman if not already installed
pacman::p_load(tidyverse, broom, plotrix, broom.mixed, lme4, lmerTest)

#grab current date using Sys.Date()
current_date <- as.Date(Sys.Date(), format = "%m/%d/%Y")

#confidence interval functions
lower_ci <- function(mean, se, n, conf_level = 0.95){
  lower_ci <- mean - qt(1 - ((1 - conf_level) / 2), n - 1) * se
}
upper_ci <- function(mean, se, n, conf_level = 0.95){
  upper_ci <- mean + qt(1 - ((1 - conf_level) / 2), n - 1) * se
}

# RUN ALL SCRIPTS
source("seismic_data_filtering.R")
source("seismic_gaps_over_time.R")
source("seismic_advantages_groups.R")
source("seismic_model_outputs.R")