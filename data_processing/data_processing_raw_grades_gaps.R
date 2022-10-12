#Data Processing: Raw Grades and Gaps

source(file = "~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#load data ####
setwd("~/Google Drive/My Drive/WG1P6/Output files/")

#raw grades and gaps files
asu_gap <- read.csv("ASU_mean_grade_gpa_differences_by_offering_2022-09-27.csv")
iu_gap <- read.csv("IUB_mean_grade_gpa_differences_by_offering_2022-09-08.csv")
pur_gap <-read.csv("Purdue_mean_grade_gpa_differences_by_offering_2022-09-26.csv")
um_gap<- read.csv("UMich_mean_grade_gpa_differences_by_offering_2022-09-19.csv")
ucd_gap <- read.csv("UCD_mean_grade_gpa_differences_by_offering_2022-09-27.csv")

#by ethniccode
asu_eth <- read.csv("ASU_mean_grade_gpa_diff_offering_ethniccode_2022-09-27.csv")
iu_eth <- read.csv("IUB_mean_grade_gpa_diff_offering_ethniccode_2022-09-08.csv")
pur_eth <-read.csv("Purdue_mean_grade_gpa_diff_offering_ethniccode_2022-09-26.csv")
um_eth<- read.csv("UMich_mean_grade_gpa_diff_offering_ethniccode_2022-09-19.csv") 
ucd_eth <- read.csv("UCD_mean_grade_gpa_diff_offering_ethniccode_2022-09-27.csv")

#prep for bind: convert UM terms to integers
um_eth$crs_term <- as.integer(um_eth$crs_term)
um_gap$crs_term <- as.integer(um_gap$crs_term)

#rbind
all_gaps <- dplyr::bind_rows(asu_gap, asu_eth, iu_gap, iu_eth, pur_gap, pur_eth, 
          um_gap, um_eth, ucd_gap, ucd_eth)

#create course topic shared variable 
all_gaps$crs_topic <- as.factor(all_gaps$crs_name)
levels(all_gaps$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104","Biology III: Cell Structure And Function", "BIO 353"), 
                              Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311","Biology IV: Genetics And Molecular Biology", "BIO 340"),
                              Physiology = c("BIOL-P451"))

#recode universities
all_gaps$university = recode_factor(all_gaps$university, 
                               "IUB" = "IU", "UMich" = "UM")

#export processed data
write.csv(all_gaps, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/all_raw_grades_GPA_gaps", current_date,".csv"))


