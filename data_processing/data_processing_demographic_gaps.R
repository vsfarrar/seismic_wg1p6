#Data Processing: SAI 
source(file = "~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#load data ####
setwd("~/Google Drive/My Drive/WG1P6/Output files/")

#demographics
asudem <- read.csv("ASU_demographic_gaps_by_offering_2023-04-24.csv")
iudem <- read.csv("IUB_demographic_gaps_by_offering_2023-04-25.csv")
purdem <-read.csv("Purdue_demographic_gaps_by_offering_2023-04-26.csv")
umdem <- read.csv("UMich_demographic_gaps_by_offering_2023-04-12.csv")
ucddem<- read.csv("UCD_demographic_gaps_by_offering_2023-09-19.csv")

#no longer excluding international students, this code is commented out 

#demographics excluding international students
# asudem_noint <- read.csv("International students excluded/ASU_demographic_gaps_by_offering_2022-09-27_no-international.csv")
# iudem_noint <- read.csv("International students excluded/IUB_demographic_gaps_by_offering_2022-09-08_no-international.csv")
# purdem_noint <-read.csv("International students excluded/Purdue_demographic_gaps_by_offering_2022-09-26_no-international.csv")
# umdem_noint <- read.csv("International students excluded/UMich_demographic_gaps_by_offering_2022-09-19_no-international.csv")
# ucddem_noint <- read.csv("International students excluded/UCD_demographic_gaps_by_offering_2022-09-27_no-international.csv")

#fix class mismatches
umdem$crs_term <- as.integer(umdem$crs_term)
#umdem_noint$crs_term <-as.integer(umdem_noint$crs_term)

#bind rows
all_dem_int <- dplyr::bind_rows(asudem, iudem, purdem, umdem, ucddem)
all_dem_int$international_included <- 1 #code international included

#all_dem_noint <- dplyr::bind_rows(asudem_noint, iudem_noint, purdem_noint, umdem_noint, ucddem_noint)
#all_dem_noint$international_included <- 0 #code international included

#bind two dataframes
#all_dem <- dplyr::bind_rows(all_dem_int, all_dem_noint)

all_dem <- all_dem_int

#data cleanup

#new data as of 4/2023 no longer needs this; commented out 
# #create course topic shared variable 
# all_dem$crs_topic <- as.factor(all_dem$crs_name)
# levels(all_dem$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104","Biology III: Cell Structure And Function", "BIO 353"), 
#                               Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311","Biology IV: Genetics And Molecular Biology", "BIO 340"),
#                               Physiology = c("BIOL-P451"))

#recode universities
all_dem$university = recode_factor(all_dem$university, 
                               "IUB" = "IU", "UMich" = "UM")

#export data to table ####
write.csv(all_dem, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/all_demographic_gaps", current_date,".csv"))

