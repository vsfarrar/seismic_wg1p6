#Data Processing: SAI 
source(file = "~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#load data ####
setwd("~/Google Drive/My Drive/WG1P6/Output files/")

#sai (raw)
asusai <- read.csv("ASUsai_plot_2022-09-27.csv")
iusai <- read.csv("IUBsai_plot_2022-09-08.csv")
purduesai <-read.csv("Purdue_sai_plot_2022-09-26.csv")
umsai <- read.csv("UMich_sai_plot_2022-09-19.csv")
ucdsai<- read.csv("UCD_sai_plot_2022-09-27.csv")

sai <- rbind(asusai, iusai, purduesai, umsai, ucdsai)

#create course topic shared variable 
sai$crs_topic <- as.factor(sai$crs_name)
levels(sai$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104","Biology III: Cell Structure And Function", "BIO 353"), 
                                     Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311","Biology IV: Genetics And Molecular Biology", "BIO 340"),
                                     Physiology = c("BIOL-P451"))

#recode universities
sai$university = recode_factor(sai$university, 
                                  "IUB" = "IU", "UMich" = "UM")


#export processed data
#write.csv(sai, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_plot_data", current_date,".csv"))
