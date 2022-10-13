#Data Processing: SAI 
source(file = "~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#load data ####
setwd("~/Google Drive/My Drive/WG1P6/Output files/")

#demographics
asudem <- read.csv("ASU_demographic_gaps_by_offering_2022-09-27.csv")
iudem <- read.csv("IUB_demographic_gaps_by_offering_2022-09-08.csv")
purdem <-read.csv("Purdue_demographic_gaps_by_offering_2022-09-26.csv")
umdem <- read.csv("UMich_demographic_gaps_by_offering_2022-09-19.csv")
ucddem<- read.csv("UCD_demographic_gaps_by_offering_2022-09-27.csv")

#fix class mismatches
umdem$crs_term <- as.integer(umdem$crs_term)

#bind rows
all_dem <- dplyr::bind_rows(asudem, iudem, purdem, umdem, ucddem)

#data cleanup

#create course topic shared variable 
all_dem$crs_topic <- as.factor(all_dem$crs_name)
levels(all_dem$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104","Biology III: Cell Structure And Function", "BIO 353"), 
                              Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311","Biology IV: Genetics And Molecular Biology", "BIO 340"),
                              Physiology = c("BIOL-P451"))

#recode universities
all_dem$university = recode_factor(all_dem$university, 
                               "IUB" = "IU", "UMich" = "UM")

#export data to table ####
write.csv(all_dem, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/all_demographic_gaps", current_date,".csv"))

